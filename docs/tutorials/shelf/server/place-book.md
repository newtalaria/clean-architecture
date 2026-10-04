---
title: Place a book on a shelf
description: PlaceBookOnShelfUseCase lives in application/shelf and takes both repositories. Feature-first has no folder for it.
tags: [clean-architecture, tutorial, serverpod]
---

This is the use case the layout is for. It loads a shelf, loads a book, asks the shelf whether there is room, asks the book to record the shelf, and saves the book. Two ports, one intent.

The class file is `lib/src/application/shelf/place_book_on_shelf_use_case.dart`. It lives under `shelf/` because the user is placing something on a shelf. It imports `BookRepository` from `domain/book/`. Application code is allowed to see both features. That is the home a `features/shelf/` tree does not have: the workflow is not only a shelf and not only a book, and a `shared/` folder would become the place every cross-feature rule slides into.

It does not live in `presentation/shelf/`. The endpoint is a caller. If the class sat next to the endpoint, the rule would depend on the edge, and a second caller (a job, a test) would import presentation.

```dart
import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';
import '../../domain/shared/exceptions/not_found.dart';
import '../../domain/shelf/shelf_repository.dart';

/// Places a book on a shelf. Lives with shelves and uses the book port.
///
/// This is the workflow a feature-first folder cannot own: it is not only a
/// shelf change and not only a book change.
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

`test/fakes/fake_shelf_repository.dart`:

```dart
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/domain/shelf/shelf_repository.dart';

class FakeShelfRepository implements ShelfRepository {
  final shelves = <String, Shelf>{};

  @override
  Future<Shelf> save(Shelf shelf) async {
    shelves[shelf.id] = shelf;
    return shelf;
  }

  @override
  Future<Shelf?> findById(String id) async => shelves[id];

  @override
  Future<List<Shelf>> list() async {
    final rows = shelves.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }
}
```

`test/unit/application/place_book_on_shelf_use_case_test.dart` uses that fake and `FakeBookRepository`. None of these tests import Serverpod.

```dart
import 'package:shelf_server/src/application/shelf/place_book_on_shelf_use_case.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/not_found.dart';
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:test/test.dart';

import '../../fakes/fake_book_repository.dart';
import '../../fakes/fake_shelf_repository.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  Book book({String? shelfId}) {
    final createdBook = Book.create(
      id: 'book-1',
      title: 'The Dispossessed',
      authorName: 'Le Guin',
      status: ReadingStatus.unread,
      createdAt: created,
    );
    return shelfId == null ? createdBook : createdBook.placeOnShelf(shelfId);
  }

  Shelf shelf({int capacity = 2}) {
    return Shelf.create(
      id: 'shelf-1',
      name: 'Fiction',
      capacity: capacity,
      createdAt: created,
    );
  }

  Future<PlaceBookOnShelfUseCase> useCase({
    Book? existingBook,
    Shelf? existingShelf,
    List<Book> others = const [],
  }) async {
    final books = FakeBookRepository();
    final shelves = FakeShelfRepository();
    if (existingBook != null) await books.save(existingBook);
    for (final other in others) {
      await books.save(other);
    }
    if (existingShelf != null) await shelves.save(existingShelf);
    return PlaceBookOnShelfUseCase(shelves, books);
  }

  test('places a book when the shelf has room', () async {
    final place = await useCase(
      existingBook: book(),
      existingShelf: shelf(),
    );
    final placed = await place.execute(bookId: 'book-1', shelfId: 'shelf-1');
    expect(placed.shelfId, 'shelf-1');
  });

  test('a missing shelf is not found', () async {
    final place = await useCase(existingBook: book());
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<NotFound>()),
    );
  });

  test('a missing book is not found', () async {
    final place = await useCase(existingShelf: shelf());
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<NotFound>()),
    );
  });

  test('a full shelf is a conflict', () async {
    final other = Book.create(
      id: 'book-2',
      title: 'The Left Hand of Darkness',
      authorName: 'Le Guin',
      status: ReadingStatus.read,
      createdAt: created,
    ).placeOnShelf('shelf-1');
    final place = await useCase(
      existingBook: book(),
      existingShelf: shelf(capacity: 1),
      others: [other],
    );
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<Conflict>()),
    );
  });

  test('a book already on a shelf is a conflict', () async {
    final place = await useCase(
      existingBook: book(shelfId: 'shelf-9'),
      existingShelf: shelf(),
    );
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<Conflict>()),
    );
  });
}
```

## The endpoint

Add `PlaceBookInput` at `presentation/shelf/input/place_book_input.spy.yml`:

```yaml
class: PlaceBookInput
fields:
  bookId: UuidValue
  shelfId: UuidValue
```

`ShelfEndpoint.place` returns `BookDto`, not `ShelfDto`. The thing that changed on the wire is the book. The shelf endpoint borrows `BookWireMappers` for that return value. It does not define a second book DTO.

Import the book mapper and add a field beside `_mappers`. `_mappers` still maps shelves. `_books` maps the book this method returns.

```dart
import 'package:shelf_server/src/presentation/book/wire_mappers.dart';
```

```dart
final _mappers = const ShelfWireMappers();
final _books = const BookWireMappers();
```

```dart
/// Returns the book wire type. The shelf feature borrows the book mapper.
Future<BookDto> place(Session session, PlaceBookInput input) {
  return runUseCase(() async {
    final book = await _useCases
        .placeBook(session)
        .execute(
          bookId: input.bookId.toString(),
          shelfId: input.shelfId.toString(),
        );
    return _books.toDto(book);
  });
}
```

`_useCases.placeBook` is the factory in `app/use_cases.dart`. Add it now:

```dart
PlaceBookOnShelfUseCase placeBook(Session session) {
  return PlaceBookOnShelfUseCase(
    _repositories.shelves(session),
    _repositories.books(session),
  );
}
```

Generate again so the client method `client.shelf.place` exists.

Add two tests to `test/integration/save_book_test.dart` inside a second `withServerpod` group. The integration test sees the wire exception. The unit test sees `Conflict`.

```dart
withServerpod('Given a shelf and a book', (sessionBuilder, endpoints) {
  test('place puts the book on the shelf', () async {
    final book = await endpoints.book.save(
      sessionBuilder,
      SaveBookInput(
        title: 'The Dispossessed',
        authorName: 'Le Guin',
        status: ReadingStatusWire.reading,
      ),
    );
    final shelf = await endpoints.shelf.save(
      sessionBuilder,
      SaveShelfInput(name: 'Fiction', capacity: 2),
    );

    final placed = await endpoints.shelf.place(
      sessionBuilder,
      PlaceBookInput(bookId: book.id, shelfId: shelf.id),
    );

    expect(placed.shelfId, shelf.id);
  });

  test('a full shelf is a conflict', () async {
    final shelf = await endpoints.shelf.save(
      sessionBuilder,
      SaveShelfInput(name: 'Fiction', capacity: 1),
    );
    final first = await endpoints.book.save(
      sessionBuilder,
      SaveBookInput(
        title: 'The Dispossessed',
        authorName: 'Le Guin',
        status: ReadingStatusWire.unread,
      ),
    );
    final second = await endpoints.book.save(
      sessionBuilder,
      SaveBookInput(
        title: 'The Left Hand of Darkness',
        authorName: 'Le Guin',
        status: ReadingStatusWire.unread,
      ),
    );
    await endpoints.shelf.place(
      sessionBuilder,
      PlaceBookInput(bookId: first.id, shelfId: shelf.id),
    );

    expect(
      () => endpoints.shelf.place(
        sessionBuilder,
        PlaceBookInput(bookId: second.id, shelfId: shelf.id),
      ),
      throwsA(isA<ApiConflictException>()),
    );
  });
});
```

```bash
dart test
```

Next: [the place control](../flutter/place-book.md).
