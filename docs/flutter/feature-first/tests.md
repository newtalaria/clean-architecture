---
title: Tests
description: A domain test, a fake-repository use case test, a page test, and a tile test with no provider scope.
tags: [clean-architecture, flutter]
---

The same checks as the other tracks. Paths differ: the tile is `features/notes/presentation/note_tile.dart`, the use case is under `features/notes/application/`, and the monitoring test imports the location from `app/router/`.

The domain test trims the title and the body, and expects `ValidationFailure` for a blank title. The application test uses a fake repository, then a real `NoteStore`, and asserts `createdAtMicros`. The page test saves `Market` inside `ProviderScope` and expects the tile. A blank title expects `Title is required` and `No notes yet`. The tile test pumps the tile inside a `Scaffold` and no `ProviderScope`. The monitoring test checks the empty key, the quiet no-client calls, and the `/notes` path. It does not start the SDK.

```bash
cd examples/flutter/feature_first
flutter test
```

Next: [Talaria](talaria.md).
