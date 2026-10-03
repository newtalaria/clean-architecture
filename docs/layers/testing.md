---
title: Testing by layer
description: Pure domain tests, fake ports around a use case, one integration test at the store, and mapper tests at the edge.
tags: [clean-architecture, testing]
---

Test the ring you mean to lock. A test that boots the whole process to check that a blank title is rejected is slower than the rule it protects, and it fails for reasons that are not the rule. Each ring has a different substitute.

| Ring | What you lock | What you substitute |
| ---- | ------------- | ------------------- |
| Domain | Invariants | Nothing. Call the function |
| Application | The workflow, including the paths that must not touch a port | Fake ports |
| Infrastructure | The mapper and the query, against a real store | The production adapter, a test database |
| Presentation | Wire mapping and failure mapping | A fake use case, or no use case at all for a pure mapper |

One integration test that starts at the entry point and hits a test store is worth having. It checks that the composition root's graph actually connects. It does not replace the four rows above.

## Domain

```text
test "blank title is rejected":
  expect Note.create("", "body", fixedInstant) fails with InvalidTitle

test "a title is kept":
  note = Note.create("Market", "body", fixedInstant)
  expect note.title == "Market"
```

No repository, no clock port. `now` is an argument. If this test needs a framework running, the type has imported something it should not.

## Application

```text
test "saves a valid note":
  notes = FakeNoteRepository()
  save = SaveNote(notes, clock at T)
  result = save.execute(SaveNoteCommand("Market", "Buy oat milk"))
  expect notes.saved == [result.note]
  expect result.note.createdAt == T

test "does not save a blank title":
  notes = FakeNoteRepository()
  save = SaveNote(notes, clock at T)
  expect save.execute(SaveNoteCommand("", "body")) fails with InvalidTitle
  expect notes.saved is empty
```

The fake implements `NoteRepository` in memory. It is not a mock of the database driver. The second test is the one that catches a use case which writes first and validates later.

## Infrastructure

```text
test "round trip":
  repo = SqlNoteRepository(testDatabase)
  note = Note.create("Market", "body", T)
  repo.save(note)
  loaded = repo.findAll()
  expect loaded == [note]
```

This is the test that locks `toRow` and `toNote`, including a timestamp that survives the column type. `findAll` is the port the courses use, because the workflow lists notes. Add `findById` to the same port, and to this test, when a workflow loads one note. Run it against the same engine production uses. A fake here would not catch a wrong column.

Keep this test on the adapter. Do not re-test `InvalidTitle` through SQL.

## Presentation

```text
test "payload becomes a command":
  command = toSaveNoteCommand(SaveNotePayload("Market", "Buy oat milk"))
  expect command.title == "Market"

test "invalid title becomes a field error":
  response = toResponse(InvalidTitle())
  expect response.status == 400
  expect response.field == "title"
```

Mapper tests do not need a server. A thin entry-point test can pass a fake `SaveNote` if you want to lock the try/catch. The mapping table in [Presentation](presentation.md) is the list of failures that test should mention: domain failure to a client error, storage failure to a server error.

## What the fake must not do

A fake repository that accepts a blank title is fine, because the real repository is not the blank-title rule. A fake that throws `InvalidTitle` itself hides whether the use case called `Note.create`. Put the invariant in the domain test, and make the application test assert the fake was not called.

A fake that returns a note object the domain could not have created will train the use case to trust bad data. Build notes with `Note.create` inside the fake's setup, or have the fake store whatever the use case passed and let the domain test police creation.

## The one crossing test

After the layer tests, one test calls the entry point wired the way production wires it, with the test database behind `SqlNoteRepository`. It saves `"Market"` and reads the response id back. A second case sends a blank title and expects the field error and an empty table.

That test fails when the composition root forgets to pass the repository, or when presentation stops translating `InvalidTitle`. It is allowed to be slower. The layer tests are the ones you run on every edit to a rule.
