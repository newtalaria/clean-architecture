---
title: Shelves on Flutter
description: The shelf form and list. The place control is the next chapter.
tags: [clean-architecture, tutorial, flutter]
---

The shelf screen follows the book screen. This page adds a capacity field and a tile. Leave the place row out until the server use case exists. A button that calls `client.shelf.place` from the page would skip the use case provider.

`ShelvesNotifier.save` parses nothing itself. The page parses the capacity field with `int.tryParse` and passes `0` when the text is not a number. `Shelf.create` rejects `0`, the use case throws `ValidationFailure`, and the notifier returns `Capacity must be from 1 to 500`. Parsing in the page is presentation. The legal range is the entity.

## Domain

`lib/domain/shelf/shelf_name.dart`:

```dart
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

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

`lib/domain/shelf/shelf.dart`:

```dart
import 'package:dart_mappable/dart_mappable.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf_name.dart';

part 'shelf.mapper.dart';

@MappableClass()
class Shelf with ShelfMappable {
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

  void ensureRoomForAnother(int booksAlreadyOnShelf) {
    if (booksAlreadyOnShelf >= capacity) {
      throw const Conflict('Shelf is full');
    }
  }
}
```

`lib/domain/shelf/shelf_repository.dart`:

```dart
import 'package:shelf_flutter/domain/shelf/shelf.dart';

abstract interface class ShelfRepository {
  Future<Shelf> save(Shelf shelf);

  Future<List<Shelf>> list();
}
```

Generate the mapper part:

```bash
dart run build_runner build
```

## Application

`lib/application/shelf/save_shelf_command.dart`:

```dart
class SaveShelfCommand {
  const SaveShelfCommand({required this.name, required this.capacity});

  final String name;
  final int capacity;
}
```

`lib/application/shelf/save_shelf_use_case.dart`:

```dart
import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_command.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

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
    final draft = Shelf.create(
      id: ids.newId(),
      name: command.name,
      capacity: command.capacity,
      createdAt: clock.now(),
    );
    return _shelves.save(draft);
  }
}
```

`lib/application/shelf/list_shelves_use_case.dart`:

```dart
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class ListShelvesUseCase {
  const ListShelvesUseCase(this._shelves);

  final ShelfRepository _shelves;

  Future<List<Shelf>> execute() => _shelves.list();
}
```

Do not add `PlaceBookOnShelfUseCase` in this chapter. That class is the place-control page.

## Data

Add these two methods to `ProtocolMappers`:

```dart
Shelf toShelf(ShelfDto dto) {
  return Shelf(
    id: dto.id.toString(),
    name: dto.name,
    capacity: dto.capacity,
    createdAt: dto.createdAt,
  );
}

SaveShelfInput toSaveShelfInput(Shelf shelf) {
  return SaveShelfInput(name: shelf.name, capacity: shelf.capacity);
}
```

`lib/data/serverpod_shelf_repository.dart`:

```dart
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/data/protocol_mappers.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class ServerpodShelfRepository implements ShelfRepository {
  ServerpodShelfRepository(this._client, {ProtocolMappers? mappers})
    : _mappers = mappers ?? const ProtocolMappers();

  final Client _client;
  final ProtocolMappers _mappers;

  @override
  Future<Shelf> save(Shelf shelf) async {
    try {
      final dto = await _client.shelf.save(_mappers.toSaveShelfInput(shelf));
      return _mappers.toShelf(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }

  @override
  Future<List<Shelf>> list() async {
    final response = await _client.shelf.list();
    return response.shelves.map(_mappers.toShelf).toList();
  }
}
```

## Providers

Add these to `lib/app/providers.dart`. `placeBookOnShelfUseCaseProvider` waits for the next chapter.

```dart
final shelfRepositoryProvider = Provider<ShelfRepository>((ref) {
  return ServerpodShelfRepository(ref.watch(clientProvider));
});

final saveShelfUseCaseProvider = Provider<SaveShelfUseCase>((ref) {
  return SaveShelfUseCase(
    ref.watch(shelfRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final listShelvesUseCaseProvider = Provider<ListShelvesUseCase>((ref) {
  return ListShelvesUseCase(ref.watch(shelfRepositoryProvider));
});
```

## Presentation

`lib/ui/shelf_tile.dart` uses the same card as a book. The subtitle stays `Capacity $capacity`.

```dart
import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
class ShelfTile extends StatelessWidget {
  const ShelfTile({super.key, required this.name, required this.capacity});

  final String name;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.bookmarks_outlined,
                size: 20,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      'Capacity $capacity',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

`test/widget/shelf_tile_test.dart` pumps the tile inside a `MaterialApp` whose home is a `Scaffold`. It does not wrap the tile in `ProviderScope`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/ui/shelf_tile.dart';

void main() {
  testWidgets('renders without a provider scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ShelfTile(name: 'Fiction', capacity: 10),
        ),
      ),
    );
    expect(find.text('Fiction'), findsOneWidget);
    expect(find.text('Capacity 10'), findsOneWidget);
  });
}
```

`lib/presentation/features/shelves/shelves_notifier.dart` has `save` only. The place method is the next chapter.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_command.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';

class ShelvesNotifier extends AsyncNotifier<List<Shelf>> {
  @override
  Future<List<Shelf>> build() {
    return ref.watch(listShelvesUseCaseProvider).execute();
  }

  Future<String?> save({required String name, required int capacity}) async {
    try {
      await ref
          .read(saveShelfUseCaseProvider)
          .execute(SaveShelfCommand(name: name, capacity: capacity));
      state = AsyncData(await ref.read(listShelvesUseCaseProvider).execute());
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    }
  }
}

final shelvesProvider = AsyncNotifierProvider<ShelvesNotifier, List<Shelf>>(
  ShelvesNotifier.new,
);
```

`lib/presentation/features/shelves/shelves_page.dart` is the form and the list. It uses `ShelfFrame` and `ShelfPanel` from the books screen. It does not contain the place control.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_notifier.dart';
import 'package:shelf_flutter/ui/shelf_frame.dart';
import 'package:shelf_flutter/ui/shelf_tile.dart';

class ShelvesPage extends ConsumerStatefulWidget {
  const ShelvesPage({super.key});

  @override
  ConsumerState<ShelvesPage> createState() => _ShelvesPageState();
}

class _ShelvesPageState extends ConsumerState<ShelvesPage> {
  final _name = TextEditingController();
  final _capacity = TextEditingController(text: '10');
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _capacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shelves = ref.watch(shelvesProvider);
    final theme = Theme.of(context);
    return ShelfFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShelfNav(section: ShelfSection.shelves),
          const SizedBox(height: 20),
          ShelfPanel(
            title: 'New shelf',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: const Key('shelf-name'),
                  controller: _name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('shelf-capacity'),
                  controller: _capacity,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Capacity'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    key: const Key('save-shelf'),
                    onPressed: () async {
                      final capacity = int.tryParse(_capacity.text.trim()) ?? 0;
                      final message = await ref
                          .read(shelvesProvider.notifier)
                          .save(name: _name.text, capacity: capacity);
                      if (!mounted) return;
                      setState(() => _error = message);
                      if (message == null) _name.clear();
                    },
                    child: const Text('Save shelf'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Shelves', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Expanded(
            child: shelves.when(
              data: (items) {
                if (items.isEmpty) {
                  return const ShelfEmpty(
                    message: 'No shelves yet',
                    hint: 'Give a shelf a name and how many books it holds.',
                  );
                }
                return ListView(
                  children: [
                    for (final shelf in items)
                      ShelfTile(name: shelf.name, capacity: shelf.capacity),
                  ],
                );
              },
              loading: () => const Text('Loading'),
              error: (error, _) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
```

`lib/presentation/router/shelves_location.dart`:

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_page.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class ShelvesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [RoutePaths.shelves];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('shelves'),
        title: 'Shelves',
        child: ScreenReporter(
          path: RoutePaths.shelves,
          title: 'Shelves',
          child: ShelvesPage(),
        ),
      ),
    ];
  }
}
```

In `ShelfApp`, add `ShelvesLocation()` to `beamLocations` next to `BooksLocation()`.

`test/fakes/fake_shelf_repository.dart`:

```dart
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class FakeShelfRepository implements ShelfRepository {
  final shelves = <String, Shelf>{};

  @override
  Future<Shelf> save(Shelf shelf) async {
    shelves[shelf.id] = shelf;
    return shelf;
  }

  @override
  Future<List<Shelf>> list() async => shelves.values.toList();
}
```

```bash
flutter test
```

Next: [place a book on a shelf](../server/place-book.md).
