---
title: Presentation
description: A Riverpod notifier calls the use case. The note tile does not import Riverpod. Beamer reports the screen.
tags: [clean-architecture, flutter]
---

The page and the notifier live in `presentation/features/notes/`. The tile lives in `ui/note_tile.dart`. That split is the point of this track: a feature owns its screen, and a presentational widget owns nothing about Riverpod.

`NotesPage` watches `notesProvider` and calls `save` on the notifier. `NoteTile` takes a title and a body. The tile file imports Flutter only.

Beamer is the router adapter. `presentation/router/notes_location.dart` builds the notes page inside `ScreenReporter`, which calls `NotesMonitoring.setScreen` when the location is shown. Repeats of the same path and title are dropped once a client exists.

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

The files are [`lib/presentation/features/notes/notes_page.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/presentation/features/notes/notes_page.dart) and [`lib/presentation/features/notes/notes_controller.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/presentation/features/notes/notes_controller.dart) and [`lib/ui/note_tile.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/ui/note_tile.dart) and [`lib/presentation/router/notes_location.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/presentation/router/notes_location.dart).

Next: [Composition root](composition.md).
