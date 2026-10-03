---
title: Save a book
description: One command and one use case. The use case builds a Book and asks the port to save it.
tags: [clean-architecture, tutorial, serverpod]
---

One use case is one intent and one `execute` method. Saving a book does not list books and does not place a book on a shelf.

The command is the input object. It is Dart, in the application layer, next to the use case. It is not `SaveBookInput`. That spy type does not exist yet, and this layer is not allowed to import it.

Create `lib/src/application/book/save_book_command.dart`:

```dart
import '../../domain/book/value_objects/reading_status.dart';

/// Input to [SaveBookUseCase]. Plain Dart. Not a spy type.
class SaveBookCommand {
  const SaveBookCommand({
    required this.title,
    required this.authorName,
    required this.status,
  });

  final String title;
  final String authorName;
  final ReadingStatus status;
}
```

The title and the author are still unchecked strings. `Book.create` checks them. The command does not, because a command is a bag of input, and the entity is the rule.

Create `lib/src/application/book/save_book_use_case.dart`:

```dart
import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';
import '../ports/clock.dart';
import '../ports/id_generator.dart';
import 'save_book_command.dart';

/// One intent: create a book. The entity checks the title and the author.
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
    final book = Book.create(
      id: ids.newId(),
      title: command.title,
      authorName: command.authorName,
      status: command.status,
      createdAt: clock.now(),
    );
    return _books.save(book);
  }
}
```

Read that method as three steps. Ask the id port for an id. Ask `Book.create` for a book, which throws `ValidationFailure` before `save` if the title or the author is blank. Ask the repository to store the book. The use case does not catch the failure. The endpoint will.

The constructor takes the repository first, then the ports by name. `clock` and `ids` are fields on the use case so the constructor can use initializing formals and the call site still reads `clock:` and `ids:`.

There is no `Session` parameter. When you later construct this class from `app/use_cases.dart`, the session is used to build `BookRepositoryImpl`, and the use case only sees `BookRepository`.

Next: [list books](list-books.md).
