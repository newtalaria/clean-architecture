---
title: Domain
description: The note entity and the repository port, with no Serverpod import.
tags: [clean-architecture, serverpod, layer-first]
---

In this track the entity lives at `lib/src/domain/notes/`. The shared failure type lives at `lib/src/domain/shared/`, because more than one feature would use it and it is still domain.

A note has an identity, a title, and a body. `Note.create` is the only way to build one. A blank title fails with `ValidationFailure` before any repository is involved.

```dart
static Note create({
  required String id,
  required String title,
  required String body,
  required DateTime now,
}) {
  final trimmed = title.trim();
  if (trimmed.isEmpty) {
    throw const ValidationFailure('Title is required');
  }
  return Note(id: id, title: trimmed, body: body, createdAt: now.toUtc());
}
```

`NoteRepository` is the port: `save` and `findAll`. It returns notes, not rows. The file is [`lib/src/domain/notes/entities/note.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/lib/src/domain/notes/entities/note.dart) and [`lib/src/domain/notes/note_repository.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/lib/src/domain/notes/note_repository.dart).

Nothing in this folder imports application, infrastructure, presentation, or Serverpod. That is the dependency rule for this track, same as the others.

Next: [Application](application.md).
