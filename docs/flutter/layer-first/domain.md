---
title: Domain
description: The note entity and the repository port, with no Flutter import.
tags: [clean-architecture, flutter]
---

In this track the entity lives at `lib/domain/notes/`. The shared failure type lives at `lib/domain/shared/`. A second feature would add `domain/notebooks/`, not a new top-level folder.

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

`NoteRepository` is the port: `save` and `findAll`. It returns notes, not rows. The files are [`lib/domain/notes/note.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/domain/notes/note.dart) and [`lib/domain/notes/note_repository.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/domain/notes/note_repository.dart).

Nothing in the domain folder imports Flutter, Riverpod, Beamer, or the data implementation. That is the dependency rule for this track, same as the others.

Next: [Application](application.md).
