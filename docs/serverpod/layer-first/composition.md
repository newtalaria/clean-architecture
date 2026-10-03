---
title: Composition root
description: UseCases is the only type that constructs NoteRepositoryImpl.
tags: [clean-architecture, serverpod, layer-first]
---

`lib/src/app/` is the composition root, same as the other tracks. Layer-first makes that obvious because it is the only folder that is allowed to import both `infra/` and `application/`.

`Repositories` holds the store and returns `NoteRepositoryImpl(store)`. `UseCases` holds the repositories, the clock, and the id generator, and returns a `SaveNoteUseCase` or a `ListNotesUseCase`.

```dart
SaveNoteUseCase saveNote() => SaveNoteUseCase(
  _repositories.noteRepository(),
  clock: _clock,
  ids: _ids,
);
```

The endpoint calls `useCases.saveNote()`. A unit test does not. It constructs `SaveNoteUseCase` with a fake repository, which is why the use case depends on the port.

`app/` has no title check and no SQL. Those stay in `Note.create` and the repository impl. The files are [`lib/src/app/use_cases.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/lib/src/app/use_cases.dart) and [`lib/src/app/repositories.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/lib/src/app/repositories.dart).

Next: [Tests](tests.md).
