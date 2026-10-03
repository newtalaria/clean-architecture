---
title: Presentation
description: A Riverpod notifier calls the use case. The note tile does not import Riverpod. Beamer reports the screen.
tags: [clean-architecture, flutter]
---

`features/notes/presentation/` holds the page, the notifier, and the tile. The tile does not import Riverpod. The notifier imports `app/providers.dart` for the use cases. Neither the page nor the notifier imports `features/notes/data/`.

The shell router is `app/router/notes_location.dart`. It imports the feature page. `ScreenReporter` calls `NotesMonitoring.setScreen` from that location, so Beamer stays the router adapter even though the route table is not inside the feature.

```dart
Future<String?> save(String title, String body) async {
  try {
    await ref.read(saveNoteUseCaseProvider).execute(title: title, body: body);
    final notes = await ref.read(listNotesUseCaseProvider).execute();
    state = AsyncData(notes);
    return null;
  } on ValidationFailure catch (error) {
    return error.message;
  }
}
```

The page shows that message under the form. A blank title never reaches the store.

The files are [`lib/features/notes/presentation/notes_page.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/presentation/notes_page.dart) and [`lib/features/notes/presentation/notes_controller.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/presentation/notes_controller.dart) and [`lib/features/notes/presentation/note_tile.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/presentation/note_tile.dart) and [`lib/app/router/notes_location.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/app/router/notes_location.dart).

Next: [Composition root](composition.md).
