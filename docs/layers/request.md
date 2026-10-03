---
title: One request
description: Save a note from the wire payload, through the use case and the domain, to the row that is stored.
tags: [clean-architecture, request]
---

This is `SaveNote` from the caller's payload to the row, and back. The same steps apply in a layer-first tree and a feature-first tree. Only the paths change.

## The call

A client submits:

```text
{ "title": "Market", "body": "Buy oat milk" }
```

That JSON is the wire model. It has no id and no timestamp.

## Presentation

The entry point does not construct a repository. It maps, calls, and maps again.

```text
save(request):
  try:
    command = SaveNoteCommand(
      title: request.payload.title,
      body: request.payload.body,
    )
    result = saveNote.execute(command)
    return 201, SaveNoteResponse(
      id: result.note.id,
      title: result.note.title,
      body: result.note.body,
      createdAt: result.note.createdAt,
    )
  catch InvalidTitle:
    return 400, field error on title
  catch storage failure:
    return 500
```

`saveNote` was built by the [composition root](composition-root.md) for this request.

## Application

```text
SaveNote.execute(command):
  note = Note.create(command.title, command.body, clock.now())
  saved = notes.save(note)
  return SaveNoteResult(saved)
```

No status code, no JSON, no table name. `notes` is a `NoteRepository`. In production it is `SqlNoteRepository`. In a unit test it is a fake. This function does not know which.

## Domain

```text
Note.create(title, body, now):
  if title is blank:
    fail InvalidTitle
  return Note(newId(), title, body, now)
```

For `"Market"` this returns a note. For `""` it fails, `notes.save` is never called, and presentation maps `InvalidTitle` to the field error.

## Infrastructure

```text
SqlNoteRepository.save(note):
  insert into notes (
    id, title, body, created_at
  ) values (
    note.id, note.title, note.body, note.createdAt
  )
  return note
```

The insert is the persistence model. If the driver reports a timeout, that failure propagates as an infrastructure failure. The repository does not translate it into `InvalidTitle`.

## What came back

```text
201
{
  "id": "…",
  "title": "Market",
  "body": "Buy oat milk",
  "createdAt": "…"
}
```

The response is a fourth shape only in the sense that it is the wire model on the way out. It is still presentation. The entity gained an id and a timestamp the client did not send. The mapper is the only place that copies those fields onto the response.

## A blank title

```text
{ "title": "", "body": "Buy oat milk" }
```

`Note.create` fails. The use case ends. The repository is not called. The client receives a field error. The table is unchanged. That is the dependency rule at runtime: the inner ring can refuse the outer ring's data, and the outer ring cannot write anyway, because the write lives behind a port the use case never reached.

## Where the files sit

Layer-first, the pieces are `presentation/notes`, `application/notes`, `domain/notes`, `infrastructure/notes`, and `composition`. Feature-first, the same five roles sit under `features/notes/`, and `composition` stays shared. Hybrid, the use case stays in horizontal `application/notes` even when the entry point lives in `presentation/notes`. Moving the use case into the feature folder would make the workflow depend on the edge.
