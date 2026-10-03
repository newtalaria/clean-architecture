---
title: Composition root
description: app/providers.dart is the only file that constructs NoteRepositoryImpl.
tags: [clean-architecture, flutter]
---

`lib/app/providers.dart` is the only file that constructs `NoteRepositoryImpl`. The page watches `notesProvider`. The notifier reads `saveNoteUseCaseProvider` and `listNotesUseCaseProvider`. Neither imports `data/`.

`main.dart` overrides `notesHttpClientProvider` with `NotesMonitoring.httpClient()`. When `TALARIA_API_KEY` is set, that client is `Talaria.wrapHttpClient`. The notes repository does not call it. A real API repository would take this client in the same provider that now takes `NoteStore`.

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
