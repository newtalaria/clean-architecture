---
title: Flutter domain
description: Write Book again. The client cannot import the server domain. Entities use dart_mappable.
tags: [clean-architecture, tutorial, flutter]
---

`Book` on the server is not visible to this package. If the Flutter domain imported `package:shelf_server`, the client would depend on Postgres, `Session`, and the server composition root. You write the entity a second time. The rules are the same: `BookTitle.parse`, a trimmed author, `ReadingStatus`, and `placeOnShelf` throwing `Conflict` when `shelfId` is already set.

Two things change.

The files live in `lib/domain/book/`, not `lib/src/domain/book/`. Imports are `package:shelf_flutter/...`.

`Book` and `ReadingStatus` and `Shelf` carry `dart_mappable` annotations, matching a dashboard that serializes domain values in tests and logs without using the protocol types. The annotation does not make the entity a wire DTO. `BookDto` stays in `data/`.

`reading_status.dart`:

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'reading_status.mapper.dart';

@MappableEnum()
enum ReadingStatus { unread, reading, read }
```

`lib/domain/book/book.dart`:

```dart
import 'package:dart_mappable/dart_mappable.dart';
import 'package:shelf_flutter/domain/book/book_title.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

part 'book.mapper.dart';

/// A book on the shelf. [create] is the only constructor that checks rules.
@MappableClass()
class Book with BookMappable {
  const Book({
    required this.id,
    required this.title,
    required this.authorName,
    required this.status,
    required this.createdAt,
    this.shelfId,
  });

  final String id;
  final String title;
  final String authorName;
  final ReadingStatus status;
  final DateTime createdAt;
  final String? shelfId;

  static const _authorMax = 200;

  factory Book.create({
    required String id,
    required String title,
    required String authorName,
    required ReadingStatus status,
    required DateTime createdAt,
  }) {
    return Book(
      id: id,
      title: BookTitle.parse(title).value,
      authorName: _author(authorName),
      status: status,
      createdAt: createdAt.toUtc(),
    );
  }

  Book placeOnShelf(String shelfId) {
    if (this.shelfId != null) {
      throw const Conflict('Book is already on a shelf');
    }
    return Book(
      id: id,
      title: title,
      authorName: authorName,
      status: status,
      createdAt: createdAt,
      shelfId: shelfId,
    );
  }

  static String _author(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Author is required');
    }
    if (trimmed.length > _authorMax) {
      throw const ValidationFailure('Author is too long');
    }
    return trimmed;
  }
}
```

Copy `BookTitle`, `ValidationFailure`, `NotFound`, and `Conflict` from the server, and change the imports to `package:shelf_flutter/...`.

`BookRepository` on this chapter is `save` and `list` only. `client.shelf.place` does not exist until the shelf endpoint is generated. Add `placeOnShelf` in [the place control](place-book.md), after that generate step.

```dart
import 'package:shelf_flutter/domain/book/book.dart';

/// What the screen needs stored about books. The data layer talks to Serverpod.
abstract interface class BookRepository {
  Future<Book> save(Book book);

  Future<List<Book>> list();
}
```

Generate the mapper parts:

```bash
cd shelf_flutter
dart run build_runner build
```

Commit the generated `*.mapper.dart` files. Do not hand-edit them.

`test/unit/book_test.dart` repeats the trim and the blank-title cases. `flutter test test/unit/book_test.dart` does not need a running server.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

void main() {
  test('create trims the title', () {
    final book = Book.create(
      id: 'b1',
      title: '  The Dispossessed ',
      authorName: 'Le Guin',
      status: ReadingStatus.unread,
      createdAt: DateTime.utc(2026, 10, 3),
    );
    expect(book.title, 'The Dispossessed');
  });

  test('a blank title is rejected', () {
    expect(
      () => Book.create(
        id: 'b1',
        title: ' ',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: DateTime.utc(2026, 10, 3),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}
```

Next: [the client use cases](application.md).
