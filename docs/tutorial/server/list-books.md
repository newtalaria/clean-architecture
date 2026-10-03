---
title: List books
description: A second use case that only calls list. It does not share a class with save.
tags: [clean-architecture, tutorial, serverpod]
---

Listing books is a different intent from saving one. It gets its own class. A `BooksService` with `save` and `list` methods would hide two intents behind one type and would grow a third method the moment you can place a book.

Create `lib/src/application/book/list_books_use_case.dart`:

```dart
import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';

class ListBooksUseCase {
  const ListBooksUseCase(this._books);

  final BookRepository _books;

  Future<List<Book>> execute() => _books.list();
}
```

The body is one call. That is the point. The use case is still the type the endpoint calls. The endpoint does not receive a `BookRepository`. If listing later needs a filter, the change is a command object on this class, not a new query inside the endpoint.

Next: [tests with a fake repository](book-tests.md).
