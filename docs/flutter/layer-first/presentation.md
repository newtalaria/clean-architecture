---
title: Presentation
description: A Riverpod notifier calls the use case. The note tile does not import Riverpod. Beamer reports the screen.
tags: [clean-architecture, flutter]
---

`presentation/notes/` holds the page, the notifier, and the tile. The tile still does not import Riverpod. It takes a title and a body. The difference from hybrid is ownership: the tile lives in the presentation layer, beside the page, instead of in a separate `ui/` tree.

Beamer stays in `presentation/router/`. `ScreenReporter` calls `NotesMonitoring.setScreen` when the notes location is built.

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

The files are [`lib/presentation/notes/notes_page.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/notes/notes_page.dart) and [`lib/presentation/notes/notes_controller.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/notes/notes_controller.dart) and [`lib/presentation/notes/note_tile.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/notes/note_tile.dart) and [`lib/presentation/router/notes_location.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/router/notes_location.dart).

Next: [Composition root](composition.md).
