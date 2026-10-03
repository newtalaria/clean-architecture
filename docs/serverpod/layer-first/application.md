---
title: Application
description: SaveNoteUseCase takes the repository port, a clock, and an id generator.
tags: [clean-architecture, serverpod, layer-first]
---

The use case lives at `lib/src/application/notes/`. Ports that are not domain concepts, the clock and the id generator, live at `lib/src/application/ports/` so every feature's workflows can share them.

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

`ListNotesUseCase` calls `findAll`. Two intents, two classes. The clock and the id generator are ports beside the use case, so a test can pass a fixed instant and a fixed id. The source is [`lib/src/application/notes/save_note_use_case.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/lib/src/application/notes/save_note_use_case.dart).

The use case constructor takes `NoteRepository`. It never mentions `NoteRepositoryImpl`.

Next: [Infrastructure](infrastructure.md).
