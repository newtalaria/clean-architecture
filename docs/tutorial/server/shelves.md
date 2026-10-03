---
title: Shelves on the server
description: The same path as books. A name, a capacity, a row, a mapper, wire types, and a thin endpoint.
tags: [clean-architecture, tutorial, serverpod]
---

A shelf is the second feature. You already know where each file goes. This chapter names what is different.

## Domain

`ShelfName.parse` trims the name. An empty name is `ValidationFailure('Name is required')`. A name longer than 80 characters is `ValidationFailure('Name is too long')`. `Shelf.create` rejects a capacity outside 1 to 500 with `ValidationFailure('Capacity must be from 1 to 500')`. `ensureRoomForAnother(int booksAlreadyOnShelf)` throws `Conflict('Shelf is full')` when `booksAlreadyOnShelf >= capacity`. It does not look at books. The use case will pass the count.

`lib/src/domain/shelf/value_objects/shelf_name.dart`:

```dart
import '../../shared/exceptions/validation_failure.dart';

/// A shelf name. Construct it only through [parse].
class ShelfName {
  const ShelfName._(this.value);

  final String value;

  static const maxLength = 80;

  static ShelfName parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Name is required');
    }
    if (trimmed.length > maxLength) {
      throw const ValidationFailure('Name is too long');
    }
    return ShelfName._(trimmed);
  }
}
```

`lib/src/domain/shelf/entities/shelf.dart`:

```dart
import '../../shared/exceptions/conflict.dart';
import '../../shared/exceptions/validation_failure.dart';
import '../value_objects/shelf_name.dart';

/// A named place with a finite number of books.
class Shelf {
  const Shelf({
    required this.id,
    required this.name,
    required this.capacity,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int capacity;
  final DateTime createdAt;

  static const maxCapacity = 500;

  factory Shelf.create({
    required String id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) {
    if (capacity < 1 || capacity > maxCapacity) {
      throw const ValidationFailure('Capacity must be from 1 to 500');
    }
    return Shelf(
      id: id,
      name: ShelfName.parse(name).value,
      capacity: capacity,
      createdAt: createdAt.toUtc(),
    );
  }

  /// Throws [Conflict] when another book would exceed [capacity].
  void ensureRoomForAnother(int booksAlreadyOnShelf) {
    if (booksAlreadyOnShelf >= capacity) {
      throw const Conflict('Shelf is full');
    }
  }
}
```

`ShelfRepository` is `save`, `findById`, and `list`. It does not count books. Counting books is `BookRepository.countOnShelf`.

`lib/src/domain/shelf/shelf_repository.dart`:

```dart
import 'entities/shelf.dart';

/// What the domain needs stored about shelves. No SQL, no Session.
abstract interface class ShelfRepository {
  Future<Shelf> save(Shelf shelf);

  Future<Shelf?> findById(String id);

  /// Newest first.
  Future<List<Shelf>> list();
}
```

`test/unit/domain/shelf_test.dart` covers the trimmed name, a capacity of 0, and a full shelf.

## Application

`SaveShelfCommand` holds `name` and `capacity`. `SaveShelfUseCase` matches `SaveBookUseCase`: id port, clock, `Shelf.create`, `save`. `ListShelvesUseCase` calls `list`.

Do not put `PlaceBookOnShelfUseCase` in this chapter. That class is the next server chapter, because it is the one that takes both repositories.

`lib/src/application/shelf/save_shelf_command.dart`:

```dart
/// Input to [SaveShelfUseCase]. Plain Dart. Not a spy type.
class SaveShelfCommand {
  const SaveShelfCommand({required this.name, required this.capacity});

  final String name;
  final int capacity;
}
```

`lib/src/application/shelf/save_shelf_use_case.dart`:

```dart
import '../../domain/shelf/entities/shelf.dart';
import '../../domain/shelf/shelf_repository.dart';
import '../ports/clock.dart';
import '../ports/id_generator.dart';
import 'save_shelf_command.dart';

class SaveShelfUseCase {
  const SaveShelfUseCase(
    this._shelves, {
    required this.clock,
    required this.ids,
  });

  final ShelfRepository _shelves;
  final Clock clock;
  final IdGenerator ids;

  Future<Shelf> execute(SaveShelfCommand command) {
    final shelf = Shelf.create(
      id: ids.newId(),
      name: command.name,
      capacity: command.capacity,
      createdAt: clock.now(),
    );
    return _shelves.save(shelf);
  }
}
```

`lib/src/application/shelf/list_shelves_use_case.dart`:

```dart
import '../../domain/shelf/entities/shelf.dart';
import '../../domain/shelf/shelf_repository.dart';

class ListShelvesUseCase {
  const ListShelvesUseCase(this._shelves);

  final ShelfRepository _shelves;

  Future<List<Shelf>> execute() => _shelves.list();
}
```

Add the shelf factory methods to `UseCases`. Import the two use cases.

```dart
SaveShelfUseCase saveShelf(Session session) {
  return SaveShelfUseCase(
    _repositories.shelves(session),
    clock: const SystemClock(),
    ids: const UuidIdGenerator(),
  );
}

ListShelvesUseCase listShelves(Session session) {
  return ListShelvesUseCase(_repositories.shelves(session));
}
```

`Repositories.shelves` returns `ShelfRepositoryImpl`. Add it now if the book slice left it out:

```dart
ShelfRepository shelves(Session session) => ShelfRepositoryImpl(session);
```

## Infrastructure

`lib/src/infra/models/stored_shelf.spy.yaml`:

```yaml
### Persistence row for a shelf. Not the domain entity.
class: StoredShelf
serverOnly: true
table: stored_shelf
fields:
  id: UuidValue?, defaultPersist=random_v7
  name: String
  capacity: int
  createdAt: DateTime
```

`ShelfMapper` maps `UuidValue` and `int`. There is no enum.

`lib/src/infra/shelf/shelf_mapper.dart`:

```dart
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

class ShelfMapper {
  const ShelfMapper();

  Shelf toDomain(StoredShelf row) {
    return Shelf(
      id: uuidToString(row.id!),
      name: row.name,
      capacity: row.capacity,
      createdAt: row.createdAt,
    );
  }

  StoredShelf toRow(Shelf shelf) {
    return StoredShelf(
      id: uuidFromString(shelf.id),
      name: shelf.name,
      capacity: shelf.capacity,
      createdAt: shelf.createdAt,
    );
  }
}
```

`ShelfRepositoryImpl` inserts or updates by id and sorts `list` newest first, the same way `BookRepositoryImpl` does.

`lib/src/infra/shelf/shelf_repository_impl.dart`:

```dart
import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/domain/shelf/shelf_repository.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';
import 'package:shelf_server/src/infra/shelf/shelf_mapper.dart';

class ShelfRepositoryImpl implements ShelfRepository {
  const ShelfRepositoryImpl(this._session, {ShelfMapper? mapper})
    : _mapper = mapper ?? const ShelfMapper();

  final Session _session;
  final ShelfMapper _mapper;

  @override
  Future<Shelf> save(Shelf shelf) async {
    final row = _mapper.toRow(shelf);
    final existing = await StoredShelf.db.findById(_session, row.id!);
    final stored = existing == null
        ? await StoredShelf.db.insertRow(_session, row)
        : await StoredShelf.db.updateRow(_session, row);
    return _mapper.toDomain(stored);
  }

  @override
  Future<Shelf?> findById(String id) async {
    final row = await StoredShelf.db.findById(_session, uuidFromString(id));
    return row == null ? null : _mapper.toDomain(row);
  }

  @override
  Future<List<Shelf>> list() async {
    final rows = await StoredShelf.db.find(_session);
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows.map(_mapper.toDomain).toList();
  }
}
```

## Presentation

Spy files under `presentation/shelf/`:

```yaml
class: SaveShelfInput
fields:
  name: String
  capacity: int
```

```yaml
class: ShelfDto
fields:
  id: UuidValue
  name: String
  capacity: int
  createdAt: DateTime
```

```yaml
class: ShelfListResponse
fields:
  shelves: List<ShelfDto>
```

`presentation/shelf/wire_mappers.dart` is `ShelfWireMappers`, a different class from `BookWireMappers`.

```dart
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

class ShelfWireMappers {
  const ShelfWireMappers();

  ShelfDto toDto(Shelf shelf) {
    return ShelfDto(
      id: uuidFromString(shelf.id),
      name: shelf.name,
      capacity: shelf.capacity,
      createdAt: shelf.createdAt,
    );
  }
}
```

`ShelfEndpoint.save` and `ShelfEndpoint.list` follow the book endpoint. `place` is the next chapter. Leave it out of this file until then.

```dart
import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/app/di.dart';
import 'package:shelf_server/src/application/shelf/save_shelf_command.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/presentation/shared/endpoint_support.dart';
import 'package:shelf_server/src/presentation/shelf/wire_mappers.dart';

class ShelfEndpoint extends Endpoint {
  final _useCases = AppDi.instance.useCases;
  final _mappers = const ShelfWireMappers();

  Future<ShelfDto> save(Session session, SaveShelfInput input) {
    return runUseCase(() async {
      final shelf = await _useCases
          .saveShelf(session)
          .execute(
            SaveShelfCommand(name: input.name, capacity: input.capacity),
          );
      return _mappers.toDto(shelf);
    });
  }

  Future<ShelfListResponse> list(Session session) {
    return runUseCase(() async {
      final shelves = await _useCases.listShelves(session).execute();
      return ShelfListResponse(shelves: shelves.map(_mappers.toDto).toList());
    });
  }
}
```

```bash
serverpod generate
serverpod create-migration
dart test test/unit/domain/shelf_test.dart
```

The endpoint test for place arrives with the next chapter, in the same `withServerpod` file.

## Flutter, briefly

Repeat the client split. `lib/domain/shelf/shelf.dart` is `@MappableClass()`. `SaveShelfUseCase` validates with `Shelf.create` and then calls the port. `ServerpodShelfRepository` calls `client.shelf.save` and `client.shelf.list`. Add `toShelf` and `toSaveShelfInput` on `ProtocolMappers` in the same shape as `toBook` and `toSaveBookInput`. `ShelvesPage` is a form and a list of `ShelfTile`. `ShelfTile` lives in `ui/` and does not import Riverpod. `ShelvesLocation` reports the screen `/shelves`.

The place dropdowns are not part of this page yet. Add the shelf form and the list, run `dart run build_runner build` if you annotated `Shelf`, and `flutter test`. Then add the control in [the place control](../flutter/place-book.md).

Next: [place a book on a shelf](place-book.md).
