---
title: Book title
description: A value object that trims a title and rejects an empty or oversized one. Pure Dart.
tags: [clean-architecture, tutorial, serverpod]
---

A title is not a `String` that any caller may invent. `BookTitle.parse` is the only constructor that produces one. The private constructor means a test, a use case, and a mapper cannot build an empty title by calling `BookTitle('')`.

This file imports the domain exception and nothing else. It does not import Serverpod. It is not a spy enum and it is not a column.

Create `lib/src/domain/book/value_objects/book_title.dart`:

```dart
import '../../shared/exceptions/validation_failure.dart';

/// A book title the shelf will store. Construct it only through [parse].
class BookTitle {
  const BookTitle._(this.value);

  final String value;

  static const maxLength = 200;

  static BookTitle parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Title is required');
    }
    if (trimmed.length > maxLength) {
      throw const ValidationFailure('Title is too long');
    }
    return BookTitle._(trimmed);
  }
}
```

`maxLength` is a real limit a caller needs. Two hundred characters is enough for a title and short enough that a pasted page does not become one. The entity will store `value`, the checked string, so the rest of the server does not unwrap a `BookTitle` on every read. The value object still owns the rule.

Next: [reading status](reading-status.md).
