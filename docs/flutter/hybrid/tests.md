---
title: Tests
description: A domain test, a fake-repository use case test, a page test, and a tile test with no provider scope.
tags: [clean-architecture, flutter]
---

The domain test trims `" Market "` to `Market` and `" Oat milk "` to `Oat milk`, and expects `ValidationFailure` for a blank title. No repository.

The application test saves `" Market "` through a fake repository with a fixed clock and the id `note-1`, and expects the title `Market`. A blank title leaves the fake empty. A second case uses a real `NoteStore` and asserts the row stored `createdAtMicros`.

The page test pumps `NotesPage` inside `ProviderScope`, saves `Market`, and expects the tile. A blank title expects the text `Title is required` and `No notes yet`.

The tile test pumps `NoteTile` from `ui/note_tile.dart` inside a `Scaffold` and no `ProviderScope`. A tile test that needed a provider scope would mean the widget had grown a provider of its own.

`test/unit/monitoring_test.dart` checks that an empty or blank key skips init, that screen and user calls return when no client exists, and that the notes location owns `/notes`. It does not start the SDK.

```bash
cd examples/flutter/hybrid
flutter test
```

Next: [Talaria](talaria.md).
