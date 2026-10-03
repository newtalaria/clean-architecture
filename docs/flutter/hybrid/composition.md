---
title: Composition root
description: app/providers.dart is the only file that constructs NoteRepositoryImpl.
tags: [clean-architecture, flutter]
---

`lib/app/providers.dart` is the only file that constructs `NoteRepositoryImpl`. The page never imports `data/`. It reads `saveNoteUseCaseProvider` and `listNotesUseCaseProvider`.

`main.dart` overrides `notesHttpClientProvider` with `NotesMonitoring.httpClient()`. When `TALARIA_API_KEY` is set, that client is `Talaria.wrapHttpClient`. The notes store stays in memory, so the wrapped client is the composition-root hook a real API client would use.

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

The files are [`lib/app/providers.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/app/providers.dart) and [`lib/main.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/main.dart).

Next: [Tests](tests.md).
