---
title: Composition root
description: app/providers.dart is the only file that constructs NoteRepositoryImpl.
tags: [clean-architecture, flutter]
---

`lib/app/providers.dart` is the only file that constructs `NoteRepositoryImpl`. Presentation imports the use-case providers. It does not import `data/notes/note_repository_impl.dart`.

`main.dart` overrides the HTTP client provider. The store stays in memory so `flutter test` does not need a server.

```dart
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(ref.watch(noteStoreProvider));
});

final saveNoteUseCaseProvider = Provider<SaveNoteUseCase>((ref) {
  return SaveNoteUseCase(
    ref.watch(noteRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});
```

The files are [`lib/app/providers.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/app/providers.dart) and [`lib/main.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/main.dart).

Next: [Tests](tests.md).
