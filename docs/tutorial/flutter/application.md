---
title: Flutter application
description: The client use case validates with Book.create, then saves. The server id replaces the local one.
tags: [clean-architecture, tutorial, flutter]
---

The client use case has the same shape as the server use case: a command, a clock, an id generator, and `Book.create`. The difference is what `save` means.

On the server, `save` stores the book whose id the use case just minted. On the client, `SaveBookInput` has no id field. The server mints the id that gets stored. The client still calls `Book.create` so a blank title throws before any HTTP call. The id passed into `create` is only there because a book has an identity. `ServerpodBookRepository.save` ignores it and returns the book from `BookDto`.

Create `lib/application/book/save_book_use_case.dart`:

```dart
class SaveBookUseCase {
  const SaveBookUseCase(
    this._books, {
    required this.clock,
    required this.ids,
  });

  final BookRepository _books;
  final Clock clock;
  final IdGenerator ids;

  Future<Book> execute(SaveBookCommand command) {
    final draft = Book.create(
      id: ids.newId(),
      title: command.title,
      authorName: command.authorName,
      status: command.status,
      createdAt: clock.now(),
    );
    return _books.save(draft);
  }
}
```

`ListBooksUseCase` is one line, `return _books.list()`. Copy `Clock`, `SystemClock`, `IdGenerator`, and `UuidIdGenerator` into `lib/application/ports/`. They are application ports, not widgets.

Do not import `package:shelf_client` in this folder. `SaveBookCommand.status` is the domain `ReadingStatus`, not `ReadingStatusWire`.

Next: [the data layer](data.md).
