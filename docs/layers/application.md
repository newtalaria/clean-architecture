---
title: Application
description: One use case per intent. Commands in, results out, and ports for anything that leaves the process.
tags: [clean-architecture, application]
---

The application ring is the set of intents the system performs. Each use case is one intent, with one way in and one way out.

## What lives here

| Artifact | Notes example | Why it is here |
| -------- | ------------- | -------------- |
| Use case | `SaveNote` | One class, one `execute` |
| Command | `SaveNoteCommand` | Input for a write, already free of the wire |
| Query | `ListNotesQuery` | Input for a read |
| Result | `SaveNoteResult` | What the caller of the use case gets back |
| Port | A port the workflow needs that is not a domain concept | Clock, id generator, outbound notification |

The domain already defines `Note` and `NoteRepository`. The use case defines **how to save one**:

```text
SaveNote
  execute(command):
    note = Note.create(command.title, command.body, clock.now())
    saved = notes.save(note)
    return SaveNoteResult(saved)
```

`Note.create` either returns a note or fails with `InvalidTitle`. The use case does not catch that and turn it into a stored error string. The failure propagates. Presentation decides what the client sees. See [Presentation](presentation.md).

## Commands are not entities

A command is the input to one workflow. It is allowed to be a flat bag of already-parsed values: title, body, and the id of the actor. It is not a note, and it is not the payload that arrived on the wire. Presentation builds the command. The use case trusts that the command is the application's shape, then asks the domain whether the values make a valid note.

A result is the same idea on the way out. It carries the domain objects the edge needs, plus flags that are about the workflow ("created" versus "updated") when those flags are not part of the entity.

## What stays outside

- The driver, the session, and the query language
- The wire payload and the status code
- Constructing a concrete repository
- Rendering

If the use case imported a concrete adapter, every test would need that adapter's dependencies, and a second entry point (a job, a second API) would construct the adapter again. The use case receives the port. The [composition root](composition-root.md) constructs the adapter.

## One intent

"Save a note" and "list notes" are two use cases. A method that both saves and lists has two reasons to change. A use case that needs two repositories is still one intent when both calls serve that intent: save the note, then update the notebook count, is one workflow if the product treats it as one action. It is two use cases if a caller can do either alone.

Read paths use the same shape. `ListNotes` takes a query, calls `NoteRepository.findAll` or a narrower port, and returns a page of notes. Authorization, when it is a workflow step rather than a property of the note, is a port the use case calls before the repository.

## Ports the application declares

Some needs are not domain concepts. The domain can receive `now` as an argument, which is what `Note.create` does above, so the entity stays pure. The use case asks a `Clock` port for that value. The clock adapter is infrastructure. Tests pass a clock that returns a fixed instant.

Declare the port next to the use case when only the workflow needs it. Declare it in the domain when the business concept itself needs the capability, as with `NoteRepository`.
