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

The four cases are: trim the title and the author, reject a blank title, reject a title past `BookTitle.maxLength`, and reject `placeOnShelf` the second time. A blank title expects `isA<ValidationFailure>()`. A second shelf expects `isA<Conflict>()`.

Create `test/unit/application/save_book_use_case_test.dart`. Build `SaveBookUseCase` with the fake, `FixedClock(DateTime.utc(2026, 10, 3, 12))`, and `SequenceIds`. Execute a command whose title is `' The Dispossessed '`. Expect the stored title `'The Dispossessed'`, the id above, and `createdAt` equal to that fixed instant. Then execute a command whose title is `' '` and expect `ValidationFailure` with `books` still empty. The use case must not catch the failure and return null. The test sees the throw, and the map stays empty because `save` never ran.

From `shelf_server`:

```bash
dart test test/unit
```

Those tests do not import `package:serverpod/serverpod.dart`. If one of them does, the domain or the use case has started to depend on the framework.

Next: [the Postgres model](stored-book.md).
