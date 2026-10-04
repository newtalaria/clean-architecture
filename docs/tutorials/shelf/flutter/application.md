---
title: Flutter application
description: The client use case validates with Book.create, then saves. The server id replaces the local one.
tags: [clean-architecture, tutorial, flutter]
---

The client use case has the same shape as the server use case: a command, a clock, an id generator, and `Book.create`. The difference is what `save` means.

On the server, `save` stores the book whose id the use case just minted. On the client, `SaveBookInput` has no id field. The server mints the id that gets stored. The client still calls `Book.create` so a blank title throws before any HTTP call. The id passed into `create` is only there because a book has an identity. `ServerpodBookRepository.save` ignores it and returns the book from `BookDto`.

Create `lib/application/book/save_book_command.dart`:

```dart
import 'package:shelf_flutter/domain/book/reading_status.dart';

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

Create `lib/application/book/save_book_use_case.dart`:

```dart
import 'package:shelf_flutter/application/book/save_book_command.dart';
import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// Validates with [Book.create], then stores through the port.
///
/// The id used for validation is replaced by the id the server returns.
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

`lib/application/book/list_books_use_case.dart`:

```dart
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

class ListBooksUseCase {
  const ListBooksUseCase(this._books);

  final BookRepository _books;

  Future<List<Book>> execute() => _books.list();
}
```

Copy the ports into `lib/application/ports/`. They are application ports, not widgets.

`clock.dart`:

```dart
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}
```

`id_generator.dart`:

```dart
import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String newId();
}

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const _uuid = Uuid();

  @override
  String newId() => _uuid.v4();
}
```

Do not import `package:shelf_client` in this folder. `SaveBookCommand.status` is the domain `ReadingStatus`, not `ReadingStatusWire`.

Next: [the data layer](data.md).
