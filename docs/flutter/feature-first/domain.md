---
title: Domain
description: The note entity and the repository port, with no Flutter import.
tags: [clean-architecture, flutter]
---

In this track the entity lives at `lib/features/notes/domain/`. `ValidationFailure` lives in `lib/shared/`, outside the feature, so a second feature can throw the same type without importing notes.

A note has an identity, a title, and a body. `Note.create` is the only way to build one. A blank title fails with `ValidationFailure` before any repository is involved.

```dart
factory Note.create({
  required String id,
  required String title,
  required String body,
  required DateTime createdAt,
}) {
  final trimmed = title.trim();
  if (trimmed.isEmpty) {
    throw const ValidationFailure('Title is required');
  }
  return Note(
    id: id,
    title: trimmed,
    body: body.trim(),
    createdAt: createdAt,
  );
}
```

`NoteRepository` is the port: `save` and `findAll`. It returns notes, not rows. The files are [`lib/features/notes/domain/note.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/domain/note.dart) and [`lib/features/notes/domain/note_repository.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/domain/note_repository.dart) and [`lib/shared/validation_failure.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/shared/validation_failure.dart).

Nothing in the domain folder imports Flutter, Riverpod, Beamer, or the data implementation. That is the dependency rule for this track, same as the others.

Next: [Application](application.md).
