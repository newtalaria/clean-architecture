---
title: Data
description: ProtocolMappers and ServerpodBookRepository. Wire types do not leave this folder.
tags: [clean-architecture, tutorial, flutter]
---

`data/` is the only folder that imports `BookDto` and `SaveBookInput`, aside from `main.dart` constructing `Client`. A page that imports `package:shelf_client` has skipped the boundary.

Create `lib/data/protocol_mappers.dart`. `toBook` reads `dto.id.toString()` and `ReadingStatus.values.byName(dto.status.name)`. `toSaveBookInput` writes `ReadingStatusWire.values.byName(book.status.name)` and does not send `book.id`. `throwDomain` turns the three generated exceptions back into `ValidationFailure`, `NotFound`, and `Conflict`, and returns `Never` so the repository methods can call it from a `catch` and still type-check. `toShelf` and `toSaveShelfInput` are added with the shelf screen, after `serverpod generate` has written those types.

```dart
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/not_found.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

/// Protocol types in, domain types out. This file is the wire boundary.
class ProtocolMappers {
  const ProtocolMappers();

  Book toBook(BookDto dto) {
    return Book(
      id: dto.id.toString(),
      title: dto.title,
      authorName: dto.authorName,
      status: ReadingStatus.values.byName(dto.status.name),
      shelfId: dto.shelfId?.toString(),
      createdAt: dto.createdAt,
    );
  }

  SaveBookInput toSaveBookInput(Book book) {
    return SaveBookInput(
      title: book.title,
      authorName: book.authorName,
      status: ReadingStatusWire.values.byName(book.status.name),
    );
  }

  Never throwDomain(Object error) {
    if (error is ApiValidationException) {
      throw ValidationFailure(error.message);
    }
    if (error is ApiNotFoundException) {
      throw NotFound(error.message);
    }
    if (error is ApiConflictException) {
      throw Conflict(error.message);
    }
    throw error;
  }
}
```

The page catches the domain types. It does not catch `ApiValidationException`. That name stays in this file.

Create `lib/data/serverpod_book_repository.dart`:

```dart
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/data/protocol_mappers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

class ServerpodBookRepository implements BookRepository {
  ServerpodBookRepository(this._client, {ProtocolMappers? mappers})
    : _mappers = mappers ?? const ProtocolMappers();

  final Client _client;
  final ProtocolMappers _mappers;

  @override
  Future<Book> save(Book book) async {
    try {
      final dto = await _client.book.save(_mappers.toSaveBookInput(book));
      return _mappers.toBook(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }

  @override
  Future<List<Book>> list() async {
    final response = await _client.book.list();
    return response.books.map(_mappers.toBook).toList();
  }
}
```

This file implements `save` and `list` only. `placeOnShelf` calls `client.shelf.place`, and that method does not exist until [Place a book on a shelf](../server/place-book.md) has been generated. Add the method in [the place control](place-book.md).

Next: [the providers](providers.md).
