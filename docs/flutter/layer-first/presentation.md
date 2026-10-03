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

`null` means the list state was replaced and the page clears the fields. A string means the form shows that message and the list stays as it was. A blank title never reaches the store.

- [`lib/presentation/notes/notes_page.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/notes/notes_page.dart) watches the provider and draws the form
- [`lib/presentation/notes/notes_controller.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/notes/notes_controller.dart) calls the use cases
- [`lib/presentation/notes/note_tile.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/notes/note_tile.dart) takes a title and a body, beside the page
- [`lib/presentation/router/notes_location.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/layer_first/lib/presentation/router/notes_location.dart) builds the page and reports the screen

Next: [Composition root](composition.md).
