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

`null` means the list state was replaced and the page clears the fields. A string means the form shows that message and the list stays as it was. A blank title never reaches the store.

- [`lib/features/notes/presentation/notes_page.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/presentation/notes_page.dart) watches the provider and draws the form
- [`lib/features/notes/presentation/notes_controller.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/presentation/notes_controller.dart) calls the use cases through `app/providers.dart`
- [`lib/features/notes/presentation/note_tile.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/features/notes/presentation/note_tile.dart) takes a title and a body
- [`lib/app/router/notes_location.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/feature_first/lib/app/router/notes_location.dart) lives outside the feature and reports the screen

Next: [Composition root](composition.md).
