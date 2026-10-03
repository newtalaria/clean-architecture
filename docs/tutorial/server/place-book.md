---
title: Place a book on a shelf
description: PlaceBookOnShelfUseCase lives in application/shelf and takes both repositories. Feature-first has no folder for it.
tags: [clean-architecture, tutorial, serverpod]
---

This is the use case the layout is for. It loads a shelf, loads a book, asks the shelf whether there is room, asks the book to record the shelf, and saves the book. Two ports, one intent.

The class file is `lib/src/application/shelf/place_book_on_shelf_use_case.dart`. It lives under `shelf/` because the user is placing something on a shelf. It imports `BookRepository` from `domain/book/`. Application code is allowed to see both features. That is the home a `features/shelf/` tree does not have: the workflow is not only a shelf and not only a book, and a `shared/` folder would become the place every cross-feature rule slides into.

It does not live in `presentation/shelf/`. The endpoint is a caller. If the class sat next to the endpoint, the rule would depend on the edge, and a second caller (a job, a test) would import presentation.

```dart
class PlaceBookOnShelfUseCase {
  const PlaceBookOnShelfUseCase(this._shelves, this._books);

  final ShelfRepository _shelves;
  final BookRepository _books;

  Future<Book> execute({
    required String bookId,
    required String shelfId,
  }) async {
    final shelf = await _shelves.findById(shelfId);
    if (shelf == null) {
      throw const NotFound('Shelf not found');
    }
    final book = await _books.findById(bookId);
    if (book == null) {
      throw const NotFound('Book not found');
    }
    final alreadyThere = await _books.countOnShelf(shelf.id);
    shelf.ensureRoomForAnother(alreadyThere);
    final placed = book.placeOnShelf(shelf.id);
    return _books.save(placed);
  }
}
```

Walk the lines.

`findById` on the shelf throws `NotFound` when the id is unknown. The message is `Shelf not found`. The same for the book, with `Book not found`. The use case does not return null.

`countOnShelf` is the book port answering a shelf question. The shelf entity then applies its own capacity. The use case does not compare integers itself. If you wrote `if (alreadyThere >= shelf.capacity)` here, the rule would have two homes.

`placeOnShelf` throws `Conflict` when the book already has a shelf. A full shelf throws `Conflict` from `ensureRoomForAnother` before that line. Order matters: a missing shelf fails before you touch the book; a full shelf fails before you mutate the book; a book that is already placed fails inside the entity.

`save` writes the updated book. There is no composite repository method called `placeBookAndUpdateShelf`. The use case is the transaction of the workflow. The sample does not open a database transaction because each save is one row. When a workflow writes two rows that must commit together, the repository implementation uses `session.db.transaction`. The use case still calls the two ports. It does not receive a `Session`.

## The test

`test/unit/application/place_book_on_shelf_use_case_test.dart` uses `FakeShelfRepository` and `FakeBookRepository`. Five cases:

- A book and a shelf with room: the returned book's `shelfId` is the shelf id.
- No shelf: `NotFound`.
- No book: `NotFound`.
- Capacity 1 and another book already on the shelf: `Conflict`. The other book is saved on the fake with `placeOnShelf` before `execute`.
- The book already has a `shelfId`: `Conflict`, even when the target shelf has room.

None of these tests import Serverpod.

## The endpoint

Add `PlaceBookInput` at `presentation/shelf/input/place_book_input.spy.yml`:

```yaml
class: PlaceBookInput
fields:
  bookId: UuidValue
  shelfId: UuidValue
```

`ShelfEndpoint.place` returns `BookDto`, not `ShelfDto`. The thing that changed on the wire is the book. The shelf endpoint borrows `BookWireMappers` for that return value. It does not define a second book DTO.

```dart
Future<BookDto> place(Session session, PlaceBookInput input) {
  return runUseCase(() async {
    final book = await _useCases.placeBook(session).execute(
      bookId: input.bookId.toString(),
      shelfId: input.shelfId.toString(),
    );
    return _books.toDto(book);
  });
}
```

`_useCases.placeBook` is the factory in `app/use_cases.dart` from the composition chapter. Generate again so the client method `client.shelf.place` exists.

Add two tests to `test/integration/save_book_test.dart` inside a second `withServerpod` group. One saves a book and a shelf and expects `placed.shelfId` to equal `shelf.id`. One saves a shelf with capacity 1, places the first book, and expects `ApiConflictException` for the second. The integration test sees the wire exception. The unit test sees `Conflict`.

```bash
dart test
```

Next: [the place control](../flutter/place-book.md).
