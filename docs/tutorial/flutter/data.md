---
title: Data
description: ProtocolMappers and ServerpodBookRepository. Wire types do not leave this folder.
tags: [clean-architecture, tutorial, flutter]
---

`data/` is the only folder that imports `BookDto` and `SaveBookInput`, aside from `main.dart` constructing `Client`. A page that imports `package:shelf_client` has skipped the boundary.

Create `lib/data/protocol_mappers.dart`. `toBook` reads `dto.id.toString()` and `ReadingStatus.values.byName(dto.status.name)`. `toSaveBookInput` writes `ReadingStatusWire.values.byName(book.status.name)` and does not send `book.id`. `throwDomain` turns the three generated exceptions back into `ValidationFailure`, `NotFound`, and `Conflict`, and returns `Never` so the repository methods can call it from a `catch` and still type-check:

```dart
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
```

The page catches the domain types. It does not catch `ApiValidationException`. That name stays in this file.

Create `lib/data/serverpod_book_repository.dart`:

```dart
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

  @override
  Future<Book> placeOnShelf({
    required String bookId,
    required String shelfId,
  }) async {
    try {
      final dto = await _client.shelf.place(
        PlaceBookInput(
          bookId: UuidValue.fromString(bookId),
          shelfId: UuidValue.fromString(shelfId),
        ),
      );
      return _mappers.toBook(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }
}
```

`placeOnShelf` calls `client.shelf`, not `client.book`. The server method lives on the shelf endpoint because the use case lives in `application/shelf/`. The client repository is still a book repository because the method returns a `Book`. The data layer is allowed to call either endpoint. The presentation layer is not allowed to call either endpoint.

`UuidValue` comes from `package:shelf_client`. It does not appear in `domain/`.

Next: [the providers](providers.md).
