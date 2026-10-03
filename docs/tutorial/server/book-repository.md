---
title: Book repository
description: The port the domain needs. save, findById, list, and countOnShelf. No Session and no SQL.
tags: [clean-architecture, tutorial, serverpod]
---

The repository interface says what must be stored. It does not say that Postgres exists. The use case you write next depends on this type. The class that talks to `Session` implements it later, under `infra/`.

Create `lib/src/domain/book/book_repository.dart`:

```dart
import 'entities/book.dart';

/// What the domain needs stored about books. No SQL, no Session.
abstract interface class BookRepository {
  Future<Book> save(Book book);

  Future<Book?> findById(String id);

  /// Newest first.
  Future<List<Book>> list();

  Future<int> countOnShelf(String shelfId);
}
```

`save` inserts or updates. The implementation chooses which, by looking up the id. The interface does not grow an `insert` and an `update` until a caller needs them as different intents.

`list` returns newest first. That order is part of the contract, so the in-memory fake and the Postgres implementation sort the same way. A test that only checks the fake would otherwise pass while the endpoint returned a different order.

`countOnShelf` belongs on the book port because the rows being counted are books. The shelf use case will call it. That method is the first hint that a shelf workflow is allowed to ask the book port a question. You do not add a method on the book repository that also writes the shelf. One method, one question.

Next: [the clock and the id generator](ports.md).
