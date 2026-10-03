---
title: The place control
description: The Flutter use case calls one repository method. The page does not re-check capacity.
tags: [clean-architecture, tutorial, flutter]
---

The server use case owns the rule. The Flutter use case names the intent and calls the port.

```dart
class PlaceBookOnShelfUseCase {
  const PlaceBookOnShelfUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({required String bookId, required String shelfId}) {
    return _books.placeOnShelf(bookId: bookId, shelfId: shelfId);
  }
}
```

It takes `BookRepository` only. It does not take `ShelfRepository`. If it counted books on the client, the capacity rule would exist twice, and a full shelf could still be accepted by a stale list. `ServerpodBookRepository.placeOnShelf` calls `client.shelf.place` and maps `ApiConflictException` to `Conflict`.

`placeBookOnShelfUseCaseProvider` watches `bookRepositoryProvider`.

On `ShelvesPage`, two dropdowns list books whose `shelfId` is null and every shelf. The Place button calls `shelvesProvider.notifier.place`. The notifier catches `ValidationFailure`, `NotFound`, and `Conflict` and returns the message. On success it does not invent a local `placeOnShelf`. It invalidates `booksProvider` so the next list comes from the server, with the new `shelfId`.

Keys: `place-book`, `place-shelf`, `place-book-on-shelf`.

`test/widget/place_book_test.dart` overrides both repository providers with fakes, saves one book and one shelf into the fakes before `pumpWidget`, selects them, taps Place, and expects `books.books['book-1']!.shelfId` to be `'shelf-1'`. The fake's `placeOnShelf` applies `Book.placeOnShelf` in memory. That test proves the control calls the use case. The full-shelf rule stays covered by the server unit test and the endpoint test.

```bash
flutter test
```

Run the app against the server. Save two books and a shelf of capacity 1. Place the first book. Place the second. The page shows `Shelf is full`.

Next: [server instrumentation](../server/talaria.md).
