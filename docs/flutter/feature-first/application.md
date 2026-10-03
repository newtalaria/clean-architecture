---
title: Application
description: SaveNoteUseCase takes the repository port, a clock, and an id generator.
tags: [clean-architecture, flutter]
---

`lib/features/notes/application/`. The use case imports the feature's own port. It does not import another feature.

`SaveNoteUseCase.execute` builds a note with `Note.create`, asks the port to save it, and returns that note. The repository's `save` returns nothing, so the caller sees the `DateTime` the use case passed in. `ListNotesUseCase` returns whatever `findAll` mapped from the rows.

The clock and the id generator are constructor arguments, so a test can pin both. A blank title throws from `Note.create`. The notifier turns that failure into the string under the form.

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

The file is [`lib/features/notes/application/save_note_use_case.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/application/save_note_use_case.dart).

The use case imports the port, `Clock`, and `IdGenerator`. `SystemClock` and `SequentialIdGenerator` live in those same files. The composition root is the file that names them. The notifier calls the use case through the providers. The page watches `notesProvider`.

Next: [Data](data.md).
