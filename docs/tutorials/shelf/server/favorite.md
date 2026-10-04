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

Create `test/unit/application/set_book_favorite_use_case_test.dart`. It saves a placed book into `FakeBookRepository`, calls the use case, and expects `favorite` true and `shelfId` still `'shelf-1'`. A missing id throws `NotFound`.

```dart
import 'package:shelf_server/src/application/book/set_book_favorite_use_case.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/not_found.dart';
import 'package:test/test.dart';

import '../../fakes/fake_book_repository.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  test('setFavorite persists the flag and keeps the shelf', () async {
    final books = FakeBookRepository();
    final book = Book.create(
      id: 'b1',
      title: 'The Dispossessed',
      authorName: 'Le Guin',
      status: ReadingStatus.unread,
      createdAt: created,
    ).placeOnShelf('shelf-1');
    await books.save(book);

    final updated = await SetBookFavoriteUseCase(books).execute(
      bookId: 'b1',
      favorite: true,
    );

    expect(updated.favorite, isTrue);
    expect(updated.shelfId, 'shelf-1');
    expect(books.books['b1']!.favorite, isTrue);
  });

  test('a missing book is not found', () {
    expect(
      () => SetBookFavoriteUseCase(FakeBookRepository()).execute(
        bookId: 'missing',
        favorite: true,
      ),
      throwsA(isA<NotFound>()),
    );
  });
}
```

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

Add this test inside the existing `withServerpod('Given the book endpoint'` group in `test/integration/save_book_test.dart`, after the blank-title test. It saves a book, expects `favorite` false, calls `endpoints.book.setFavorite`, and expects `list` to return the flag.

```dart
    test('setFavorite persists and list returns the flag', () async {
      final saved = await endpoints.book.save(
        sessionBuilder,
        SaveBookInput(
          title: 'The Dispossessed',
          authorName: 'Le Guin',
          status: ReadingStatusWire.unread,
        ),
      );
      expect(saved.favorite, isFalse);

      final loved = await endpoints.book.setFavorite(
        sessionBuilder,
        SetBookFavoriteInput(bookId: saved.id, favorite: true),
      );
      expect(loved.favorite, isTrue);
      expect(loved.id, saved.id);

      final listed = await endpoints.book.list(sessionBuilder);
      expect(listed.books.single.favorite, isTrue);
    });
```

```bash
dart test
```

Next: [favourite on Flutter](../flutter/favorite.md).
