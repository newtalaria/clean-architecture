---
title: Application
description: SaveNoteUseCase takes the repository port, a clock, and an id generator.
tags: [clean-architecture, flutter]
---

`lib/application/notes/`. The clock and the id generator sit beside the use cases. They are ports the use case needs, not widgets.

`SaveNoteUseCase.execute` builds a note, then asks the port to save it. The clock and the id generator are injected so a test can pin both. `ListNotesUseCase` returns whatever the port has stored.

```dart
Future<Note> execute({required String title, required String body}) async {
  final note = Note.create(
    id: _ids.next(),
    title: title,
    body: body,
    createdAt: _clock.now(),
  );
  await _notes.save(note);
  return note;
}
```

The file is [`lib/application/notes/save_note_use_case.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/application/notes/save_note_use_case.dart).

The use case does not import a widget, a provider, or `NoteRepositoryImpl`. The screen calls it through a provider defined in the composition root.

Next: [Data](data.md).
