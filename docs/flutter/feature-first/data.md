---
title: Data
description: An in-memory store, a row type, and a mapper. This is where the API client would sit.
tags: [clean-architecture, flutter]
---

`lib/features/notes/data/`. The repository implementation is inside the feature. The composition root is the only file outside the feature that imports it.

```dart
factory NoteRow.fromNote(Note note) {
  return NoteRow(
    id: note.id,
    title: note.title,
    body: note.body,
    createdAtMicros: note.createdAt.microsecondsSinceEpoch,
  );
}
```

`NoteRepositoryImpl` writes rows and reads them back as notes. The files are [`lib/features/notes/data/note_row.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/data/note_row.dart) and [`lib/features/notes/data/note_repository_impl.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/data/note_repository_impl.dart).

A production client would perform the same mapping at the edge of the HTTP or Serverpod call. This sample keeps the store in memory so `flutter test` has no server to start. The HTTP client the app would wrap still belongs to the composition root, covered in [Composition root](composition.md).

Next: [Presentation](presentation.md).
