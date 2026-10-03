---
title: Infrastructure
description: Adapters that implement ports. Map the persistence model to the domain entity at this boundary.
tags: [clean-architecture, infrastructure]
---

Infrastructure is how the process reaches a database, a cache, a clock, or another service. It implements ports that the domain or the application declared. It does not decide the workflow, and it does not speak the wire format.

## What lives here

| Artifact | Notes example | Why it is here |
| -------- | ------------- | -------------- |
| Repository adapter | `SqlNoteRepository` | Implements `NoteRepository` |
| Row mapper | `toRow` / `toNote` | Persistence model on one side, entity on the other |
| Technical adapters | `SystemClock`, an id generator | Things the use case needs that are not business rules |
| Transaction boundary | A unit-of-work adapter | Atomic writes, when a use case must commit several ports together |

```text
SqlNoteRepository implements NoteRepository
  save(note):
    row = toRow(note)
    insert row
    return note

  findById(id):
    row = select where id
    if row is missing: return nothing
    return toNote(row)
```

The adapter may use the framework's session, client, or connection. That type stays a field on the adapter. It never appears on `Note` or on `SaveNote`.

## The persistence model

The row is allowed to differ from the entity.

| Domain `Note` | Persistence row |
| ------------- | --------------- |
| `id` as the domain's identity type | A database uuid or a numeric key |
| `title` that cannot be blank | A string column the database will store even if a bug writes it blank |
| `createdAt` as an instant | A timestamp column, sometimes in a different precision |
| No storage metadata | An `updated_at` the domain does not care about |

`toRow` and `toNote` are the only functions that see both shapes. If `toNote` can build a `Note` that `Note.create` would have rejected, the mapper is wrong: load the fields, then go through the same invariant, or treat a corrupt row as an infrastructure failure rather than a silent domain object.

## What stays outside

- Whether the title may be blank. That is `Note.create`.
- The order of steps in the workflow. That is the use case.
- Mapping a wire payload. That is presentation.
- Choosing which adapter is constructed. That is the composition root.

Infrastructure imports the domain, because it must implement the port and build the entity. It does not import the application use case. The use case depends on the port; the adapter does not depend on who calls the port.

Presentation is the other outer ring. An endpoint does not import `SqlNoteRepository`. A repository does not import the endpoint. They share the domain types and nothing else.

## Transactions

When one use case writes two aggregates, keep each port single-purpose and wrap the calls in a transaction the use case can see as a port.

```text
port UnitOfWork
  run(work):
    work()

SqlUnitOfWork implements UnitOfWork
  run(work):
    begin transaction
    work()
    commit
```

The use case calls `unitOfWork.run`, and inside it calls `notes.save` and `notebooks.updateCount`. The use case still does not import the database session. The adapter does.

A request-scoped handle (a session, a connection) is constructed per request in the composition root and passed into the adapter. Do not store that handle in a process-wide singleton. The next request would share it.
