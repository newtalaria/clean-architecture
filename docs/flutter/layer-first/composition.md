---
title: Composition root
description: app/providers.dart is the only file that constructs NoteRepositoryImpl.
tags: [clean-architecture, flutter]
---

`lib/app/providers.dart` is the only file that constructs `NoteRepositoryImpl`. The notifier imports that file and reads the use-case providers. The page imports the controller and the tile.

`main.dart` overrides the HTTP client provider with `NotesMonitoring.httpClient()`. That method returns `Talaria.wrapHttpClient` when a key is set, and a plain `http.Client` otherwise. The notes repository takes `NoteStore`. The store stays in memory so `flutter test` does not need a server.

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
