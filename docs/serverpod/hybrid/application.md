---
title: Application
description: SaveNoteUseCase takes the repository port, a clock, and an id generator.
tags: [clean-architecture, serverpod, hybrid]
---

The use case lives at `lib/src/application/notes/`, not under `presentation/notes/`. That split is the hybrid rule. The clock and id generator stay in `lib/src/application/ports/` because they are shared workflow ports.

`SaveNoteUseCase.execute` does one thing. It asks `Note.create` for a note, then returns whatever `NoteRepository.save` returns. The adapter reads the row back, so the caller sees the timestamp that survived `createdAtMicros`. The use case does not catch `ValidationFailure`. Presentation maps that failure.

```dart
Future<Note> execute({required String title, required String body}) {
  final note = Note.create(
    id: _ids.newId(),
    title: title,
    body: body,
    now: _clock.now(),
  );
  return _notes.save(note);
}
```

`ListNotesUseCase` calls `findAll`. Two intents, two classes. The clock and the id generator are ports beside the use case, so a test can pass a fixed instant and a fixed id. The source is [`lib/src/application/notes/save_note_use_case.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/hybrid/lib/src/application/notes/save_note_use_case.dart).

The use case constructor takes `NoteRepository`. It never mentions `NoteRepositoryImpl`.

Next: [Infrastructure](infrastructure.md).
