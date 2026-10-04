---
title: Favourite a book
description: A flag on the book. The use case loads, copies, and saves. The shelf does not change.
tags: [clean-architecture, tutorial, serverpod]
---

A favourite is a `bool` on the book. It does not move the book onto a shelf, and placing a book does not clear it.

## Domain

On `Book`, add `this.favorite = false` to the constructor and a field:

```dart
/// A favourite is a flag on the book. It does not move the book between shelves.
final bool favorite;
```

`placeOnShelf` must copy `favorite: favorite` into the new `Book`. Then add `setFavorite`:

```dart
/// Returns the same book with [favorite] set. The shelf does not change.
Book setFavorite(bool favorite) {
  return Book(
    id: id,
    title: title,
    authorName: authorName,
    status: status,
    createdAt: createdAt,
    shelfId: shelfId,
    favorite: favorite,
  );
}
```

`Book.create` leaves the flag false. The default on the constructor does that.

Add this test to `test/unit/domain/book_test.dart`:

```dart
test('setFavorite keeps the shelf and placeOnShelf keeps the flag', () {
  final book = Book.create(
    id: 'b1',
    title: 'The Dispossessed',
    authorName: 'Le Guin',
    status: ReadingStatus.unread,
    createdAt: created,
  );
  expect(book.favorite, isFalse);
  final loved = book.setFavorite(true);
  expect(loved.favorite, isTrue);
  expect(loved.shelfId, isNull);
  final placed = loved.placeOnShelf('shelf-1');
  expect(placed.favorite, isTrue);
  expect(placed.shelfId, 'shelf-1');
});
```

## Use case

`lib/src/application/book/set_book_favorite_use_case.dart` takes `BookRepository` only.

```dart
import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';
import '../../domain/shared/exceptions/not_found.dart';

/// Marks a book as a favourite or clears the flag. The shelf is unchanged.
class SetBookFavoriteUseCase {
  const SetBookFavoriteUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({
    required String bookId,
    required bool favorite,
  }) async {
    final book = await _books.findById(bookId);
    if (book == null) {
      throw const NotFound('Book not found');
    }
    return _books.save(book.setFavorite(favorite));
  }
}
```

`test/unit/application/set_book_favorite_use_case_test.dart` saves a placed book into `FakeBookRepository`, calls the use case, and expects `favorite` true and `shelfId` still `'shelf-1'`. A missing id throws `NotFound`.

## Row and wire

Add the column to `lib/src/infra/models/stored_book.spy.yaml`:

```yaml
  favorite: bool, default=false
```

`BookMapper.toDomain` reads `favorite: row.favorite`. `toRow` writes `favorite: book.favorite`.

Add the field to `lib/src/presentation/book/dto/book_dto.spy.yml`:

```yaml
  favorite: bool
```

Create `lib/src/presentation/book/input/set_book_favorite_input.spy.yml`:

```yaml
class: SetBookFavoriteInput
fields:
  bookId: UuidValue
  favorite: bool
```

`BookWireMappers.toDto` sets `favorite: book.favorite`.

On `BookEndpoint`, add `setFavorite`. It maps the id with `toString()`, calls one use case, and maps the book back.

```dart
Future<BookDto> setFavorite(Session session, SetBookFavoriteInput input) {
  return runUseCase(() async {
    final book = await _useCases
        .setBookFavorite(session)
        .execute(bookId: input.bookId.toString(), favorite: input.favorite);
    return _mappers.toDto(book);
  });
}
```

In `UseCases`, add:

```dart
SetBookFavoriteUseCase setBookFavorite(Session session) {
  return SetBookFavoriteUseCase(_repositories.books(session));
}
```

## Generate

From `shelf_server`:

```bash
serverpod generate
serverpod create-migration
```

The migration adds `favorite boolean NOT NULL DEFAULT false` on `stored_book`.

In `test/integration/save_book_test.dart`, save a book, expect `favorite` false, call `endpoints.book.setFavorite` with `SetBookFavoriteInput`, and expect `list` to return the flag.

```bash
dart test
```

Next: [favourite on Flutter](../flutter/favorite.md).
