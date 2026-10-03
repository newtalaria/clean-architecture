---
title: Composition root
description: app/providers.dart is the only file that constructs NoteRepositoryImpl.
tags: [clean-architecture, flutter]
---

`lib/app/providers.dart` imports the feature's data implementation and is the only place that constructs `NoteRepositoryImpl`. The feature presentation depends on the providers, not on the store.

That inward dependency is the whole rule. The feature may not import a sibling feature. The shell may import the feature.

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
