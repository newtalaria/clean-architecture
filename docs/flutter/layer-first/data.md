---
title: Data
description: An in-memory store, a row type, and a mapper. This is where the API client would sit.
tags: [clean-architecture, flutter]
---

`lib/data/notes/`. The row and the repository implementation sit in the data layer, named for the feature. `NoteStore` stands in for the API client.

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

`NoteRepositoryImpl` writes rows and reads them back as notes. The files are [`lib/data/notes/note_row.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/data/notes/note_row.dart) and [`lib/data/notes/note_repository_impl.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/data/notes/note_repository_impl.dart).

A production client would perform the same mapping at the edge of the HTTP or Serverpod call. This sample keeps the store in memory so `flutter test` has no server to start. The HTTP client the app would wrap still belongs to the composition root, covered in [Composition root](composition.md).

Next: [Presentation](presentation.md).
