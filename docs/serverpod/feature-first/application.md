---
title: Application
description: SaveNoteUseCase takes the repository port, a clock, and an id generator.
tags: [clean-architecture, serverpod, feature-first]
---

The use case lives at `lib/src/features/notes/application/`. The clock and the id generator are ports under that same application folder. They are not a top-level `application/ports` shared with other features. A second feature that needs a clock either duplicates the port or lifts it into `shared/` on purpose.

`SaveNoteUseCase.execute` does one thing. It asks `Note.create` for a note, then `NoteRepository.save`. It does not catch `ValidationFailure`. Presentation maps that failure.

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

`ListNotesUseCase` calls `findAll`. Two intents, two classes. The clock and the id generator are ports beside the use case, so a test can pass a fixed instant and a fixed id. The source is [`lib/src/features/notes/application/save_note_use_case.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/feature_first/lib/src/features/notes/application/save_note_use_case.dart).

The use case constructor takes `NoteRepository`. It never mentions `NoteRepositoryImpl`.

Next: [Infrastructure](infrastructure.md).
