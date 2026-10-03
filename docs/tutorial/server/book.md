---
title: Book
description: The book entity. create checks the title and the author. placeOnShelf refuses a second shelf.
tags: [clean-architecture, tutorial, serverpod]
---

`Book` is the type the use case and the repository speak. It is not the Postgres row and it is not `BookDto`. The id is a `String`. Infrastructure turns that string into a `UuidValue` when it writes a row.

`create` is the factory that checks rules. The generative constructor stays public so the mapper can rebuild a book it already stored, including one that already has a `shelfId`. A mapper that called `create` would reject a stored book whose title was valid when it was saved. The mapper does not re-decide the rules.

Create `lib/src/domain/book/entities/book.dart`:

```dart
import '../../shared/exceptions/conflict.dart';
import '../../shared/exceptions/validation_failure.dart';
import '../value_objects/book_title.dart';
import '../value_objects/reading_status.dart';

/// A book on the shelf. [create] is the only constructor that checks rules.
class Book {
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

  /// Set once [placeOnShelf] succeeds. Null means the book is not on a shelf.
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

  /// Returns the same book sitting on [shelfId]. A book has one shelf.
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

`placeOnShelf` returns a new book. It does not save. Saving is the repository's job, and deciding to call this method is the use case's job. The entity only knows that a book has one shelf.

The author check lives on the entity rather than in its own value object. The title already showed the value-object shape. The author rule is the same kind of check, small enough to keep beside `create`.

Next: [the repository port](book-repository.md).
