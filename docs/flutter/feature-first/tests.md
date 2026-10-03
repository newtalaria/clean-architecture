---
title: Tests
description: A domain test, a fake-repository use case test, a page test, and a tile test with no provider scope.
tags: [clean-architecture, flutter]
---

The tests match the other tracks. Paths differ: the tile import is `features/notes/presentation/note_tile.dart`, and the use case import is under `features/notes/application/`.

`test/unit/domain/note_test.dart` checks the trim and the blank title. `test/unit/application/save_note_use_case_test.dart` uses a fake repository, then a real `NoteStore`, and asserts the row stored `createdAtMicros`. `test/widget/notes_page_test.dart` pumps `NotesPage` inside `ProviderScope`, saves "Market", and expects the tile. The blank-title test expects `Title is required` and `No notes yet`. `test/widget/note_tile_test.dart` pumps the tile inside a `Scaffold` and no `ProviderScope`.

```bash
cd examples/flutter/feature_first
flutter test
```

Next: [Talaria](talaria.md).
