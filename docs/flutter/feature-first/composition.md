---
title: Composition root
description: app/providers.dart is the only file that constructs NoteRepositoryImpl.
tags: [clean-architecture, flutter]
---

`lib/app/providers.dart` imports the feature's data implementation and is the only place that constructs `NoteRepositoryImpl`. The notifier imports that file. The page imports the controller and the tile.

The shell imports the feature. A feature does not import a sibling feature. A type both need moves to `shared/`.

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

The files are [`lib/app/providers.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/app/providers.dart) and [`lib/main.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/main.dart).

Next: [Tests](tests.md).
