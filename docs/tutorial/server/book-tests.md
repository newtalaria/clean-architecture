---
title: Book tests
description: Domain tests and a use-case test with an in-memory repository. No YAML and no Serverpod import.
tags: [clean-architecture, tutorial, serverpod]
---

You can test the book rules before a table exists. The fake implements `BookRepository` in memory. It lives under `test/`, not under `lib/`, so production code cannot import it.

Create `test/fakes/fake_book_repository.dart`:

```dart
import 'package:shelf_server/src/application/ports/clock.dart';
import 'package:shelf_server/src/application/ports/id_generator.dart';
import 'package:shelf_server/src/domain/book/book_repository.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';

class FixedClock implements Clock {
  FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

class SequenceIds implements IdGenerator {
  int _n = 0;

  @override
  String newId() {
    _n += 1;
    return '00000000-0000-4000-8000-${_n.toString().padLeft(12, '0')}';
  }
}

class FakeBookRepository implements BookRepository {
  final books = <String, Book>{};

  @override
  Future<Book> save(Book book) async {
    books[book.id] = book;
    return book;
  }

  @override
  Future<Book?> findById(String id) async => books[id];

  @override
  Future<List<Book>> list() async {
    final rows = books.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }

  @override
  Future<int> countOnShelf(String shelfId) async {
    return books.values.where((book) => book.shelfId == shelfId).length;
  }
}
```

`SequenceIds` returns a real UUID shape so a later test can hand the same string to `UuidValue.fromString`. The first id is `00000000-0000-4000-8000-000000000001`.

Create `test/unit/domain/book_test.dart`. It constructs `Book` directly. It does not construct a use case.

```dart
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/book_title.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:test/test.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  test('create trims the title and the author', () {
    final book = Book.create(
      id: 'b1',
      title: '  The Dispossessed  ',
      authorName: '  Ursula K. Le Guin ',
      status: ReadingStatus.unread,
      createdAt: created,
    );
    expect(book.title, 'The Dispossessed');
    expect(book.authorName, 'Ursula K. Le Guin');
    expect(book.shelfId, isNull);
  });

  test('a blank title is rejected', () {
    expect(
      () => Book.create(
        id: 'b1',
        title: '   ',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('a title past the limit is rejected', () {
    expect(
      () => BookTitle.parse('a' * (BookTitle.maxLength + 1)),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('a book can be placed once', () {
    final book = Book.create(
      id: 'b1',
      title: 'The Dispossessed',
      authorName: 'Le Guin',
      status: ReadingStatus.reading,
      createdAt: created,
    );
    final placed = book.placeOnShelf('shelf-1');
    expect(placed.shelfId, 'shelf-1');
    expect(() => placed.placeOnShelf('shelf-2'), throwsA(isA<Conflict>()));
  });
}
```

Create `test/unit/application/save_book_use_case_test.dart`. The use case must not catch the failure and return null. The test sees the throw, and the map stays empty because `save` never ran.

```dart
import 'package:shelf_server/src/application/book/save_book_command.dart';
import 'package:shelf_server/src/application/book/save_book_use_case.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:test/test.dart';

import '../../fakes/fake_book_repository.dart';

void main() {
  test('saves a book with the injected clock and id', () async {
    final books = FakeBookRepository();
    final ids = SequenceIds();
    final useCase = SaveBookUseCase(
      books,
      clock: FixedClock(DateTime.utc(2026, 10, 3, 12)),
      ids: ids,
    );

    final saved = await useCase.execute(
      const SaveBookCommand(
        title: ' The Dispossessed ',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
      ),
    );

    expect(saved.id, '00000000-0000-4000-8000-000000000001');
    expect(saved.title, 'The Dispossessed');
    expect(saved.createdAt, DateTime.utc(2026, 10, 3, 12));
    expect(books.books, hasLength(1));
  });

  test('a blank title does not write', () async {
    final books = FakeBookRepository();
    final useCase = SaveBookUseCase(
      books,
      clock: FixedClock(DateTime.utc(2026, 10, 3)),
      ids: SequenceIds(),
    );

    expect(
      () => useCase.execute(
        const SaveBookCommand(
          title: ' ',
          authorName: 'Le Guin',
          status: ReadingStatus.unread,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    expect(books.books, isEmpty);
  });
}
```

From `shelf_server`:

```bash
dart test test/unit
```

Those tests do not import `package:serverpod/serverpod.dart`. If one of them does, the domain or the use case has started to depend on the framework.

Next: [the Postgres model](stored-book.md).
