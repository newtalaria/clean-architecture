---
title: Failures
description: Three domain exceptions. Validation, missing rows, and conflicts. No HTTP status codes in the domain.
tags: [clean-architecture, tutorial, serverpod]
---

A use case reports failure by throwing a domain exception. It does not throw a Serverpod exception, and it does not return a status code. The endpoint is the only place that learns those types, and that file does not exist yet.

Three failures are enough for Shelf. A blank title is a validation failure. A missing shelf is not found. A full shelf, or a book that already sits on one, is a conflict.

Create `lib/src/domain/shared/exceptions/validation_failure.dart`. This folder is `shared` because every feature throws the same types. It is not a place for use cases.

```dart
/// A business rule rejected the input. The endpoint maps this to a 400.
class ValidationFailure implements Exception {
  const ValidationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
```

The comment names the HTTP status so you remember the mapping. The class itself has no status field. Domain code must still compile if Serverpod is deleted.

Create `not_found.dart`:

```dart
/// The requested entity does not exist. The endpoint maps this to a 404.
class NotFound implements Exception {
  const NotFound(this.message);

  final String message;

  @override
  String toString() => message;
}
```

Create `conflict.dart`:

```dart
/// The request fights the current state. The endpoint maps this to a 409.
class Conflict implements Exception {
  const Conflict(this.message);

  final String message;

  @override
  String toString() => message;
}
```

Nothing imports these yet. That is fine. The next file is the first type that throws one.

Next: [the book title](book-title.md).
