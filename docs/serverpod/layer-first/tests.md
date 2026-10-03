---
title: Tests
description: A domain test, a fake-repository use case test, and one test through the endpoint into the store.
tags: [clean-architecture, serverpod, layer-first]
---

Three tests, one per ring you can lock without a generated server.

The domain test calls `Note.create` with a blank title and expects `ValidationFailure`. No repository.

The application test uses `FakeNoteRepository`, a clock fixed at one instant, and an id generator that returns `note-1`. Saving `"Market"` records one note. Saving a blank title records nothing. The fake implements `NoteRepository`. It does not pretend to be a database driver.

The integration test builds `UseCases` with a real `NoteStore` and calls `NotesEndpoint.save`. The trimmed title is in the response and in `store.rows`. A blank title throws `NoteRequestFailure` with status 400 and leaves the store empty. That is the test that fails when the composition root stops passing the repository, or when presentation stops translating `ValidationFailure`.

```bash
cd examples/serverpod/layer_first
dart test
```

The files are [`test/unit/domain/note_test.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/test/unit/domain/note_test.dart), [`test/unit/application/save_note_use_case_test.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/test/unit/application/save_note_use_case_test.dart), and [`test/integration/save_note_test.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/test/integration/save_note_test.dart).

Next: [Talaria](talaria.md).
