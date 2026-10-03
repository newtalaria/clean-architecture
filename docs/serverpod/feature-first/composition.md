---
title: Composition root
description: UseCases is the only type that constructs NoteRepositoryImpl.
tags: [clean-architecture, serverpod, feature-first]
---

`lib/src/app/` stays outside the feature. Feature-first does not mean the endpoint constructs the repository. `UseCases` still does, so a test can build `SaveNoteUseCase` without the feature's infra.

`Repositories` holds the store and returns `NoteRepositoryImpl(store)`. `UseCases` holds the repositories, the clock, and the id generator, and returns a `SaveNoteUseCase` or a `ListNotesUseCase`.

```dart
SaveNoteUseCase saveNote() => SaveNoteUseCase(
  _repositories.noteRepository(),
  clock: _clock,
  ids: _ids,
);
```

The endpoint calls `useCases.saveNote()`. A unit test does not. It constructs `SaveNoteUseCase` with a fake repository, which is why the use case depends on the port.

`app/` has no title check and no SQL. Those stay in `Note.create` and the repository impl. The files are [`lib/src/app/use_cases.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/feature_first/lib/src/app/use_cases.dart) and [`lib/src/app/repositories.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/feature_first/lib/src/app/repositories.dart).

Next: [Tests](tests.md).
