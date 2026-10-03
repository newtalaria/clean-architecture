---
title: Tests
description: A domain test, a fake-repository use case test, a page test, and a tile test with no provider scope.
tags: [clean-architecture, flutter]
---

Same three layers of tests as the other tracks: domain, fake repository, store round-trip, page, and a tile with no provider scope. The tile import comes from `presentation/notes/`, which is the diff.

`test/unit/domain/note_test.dart` checks the trim and the blank title. `test/unit/application/save_note_use_case_test.dart` uses a fake repository, then a real `NoteStore`, and asserts the row stored `createdAtMicros`. `test/widget/notes_page_test.dart` pumps `NotesPage` inside `ProviderScope`, saves "Market", and expects the tile. The blank-title test expects `Title is required` and `No notes yet`. `test/widget/note_tile_test.dart` pumps the tile inside a `Scaffold` and no `ProviderScope`.

```bash
cd examples/flutter/layer_first
flutter test
```

Next: [Talaria](talaria.md).
