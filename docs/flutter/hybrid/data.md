---
title: Data
description: An in-memory store, a row type, and a mapper. This is where the API client would sit.
tags: [clean-architecture, flutter]
---

`lib/data/notes/`. `NoteStore` is an in-memory list of rows. It stands where an API client would sit. The repository does not call HTTP. The wrapped client in [Composition root](composition.md) is ready for that call. The row keeps `createdAtMicros`. The entity keeps a `DateTime`.

```dart
factory NoteRow.fromNote(Note note) {
  return NoteRow(
    id: note.id,
    title: note.title,
    body: note.body,
    createdAtMicros: note.createdAt.microsecondsSinceEpoch,
  );
}
```

`save` appends a row and returns nothing. `findAll` maps each row with `toNote`, which uses the `Note` constructor. Rows here were written after `Note.create`, so the list keeps a title the domain already accepted. A store that can hold a row `create` would refuse should follow [Infrastructure](../../layers/infrastructure.md): run the invariant on load, or fail the load.

The files are [`lib/data/notes/note_row.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/data/notes/note_row.dart) and [`lib/data/notes/note_repository_impl.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/data/notes/note_repository_impl.dart).

The same mapping sits at the edge of an HTTP or Serverpod call when the store is no longer memory. `flutter test` starts no server because the list is the store.

Next: [Presentation](presentation.md).
