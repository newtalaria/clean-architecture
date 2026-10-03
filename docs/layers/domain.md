---
title: Domain
description: Entities, value objects, repository ports, and the rules that stay true with no framework in the room.
tags: [clean-architecture, domain]
---

The domain is the center. It names the things the business cares about and the rules that are true no matter how a note is stored or who asked for it.

## What lives here

| Artifact | Notes example | Why it is here |
| -------- | ------------- | -------------- |
| Entity | `Note` | Identity and lifecycle |
| Invariant | A title that cannot be blank | The rule lives on `Note.create`, not in the database |
| Port | `NoteRepository` | The domain needs to load and save a note, and must not know how |
| Domain service | A policy that uses more than one entity | The rule does not belong on a single object |
| Domain failure | `InvalidTitle` | A business fact, not a transport error |

A repository port lives in the domain when the entity cannot fulfill its lifecycle without persistence. The interface says what is needed: save, find one, list. It does not say which engine, which table, or which session object. The courses list every note, so their port is `save` and `findAll`. Add `findById` when a workflow loads one note.

```text
entity Note
  id
  title
  body
  createdAt

  create(title, body, now):
    if title is blank:
      fail InvalidTitle
    return Note(newId(), title, body, now)

port NoteRepository
  save(note) -> note
  findById(id) -> note or nothing
  findAll() -> notes
```

`Note.create` is how outside input becomes a note. A mapper may rebuild one from a row with the field constructor. That rebuild keeps a title the domain already accepted when every row was written through `create`. When a store can hold a row `create` would refuse, the mapper runs the invariant again or fails the load. [Infrastructure](infrastructure.md) is that rule.

## What stays outside

- Queries, row types, and connection handles
- Wire payloads and status codes
- The steps of a workflow ("validate, then save, then return")
- Hashing, clocks from the operating system, and network clients

A workflow that coordinates several ports is an application use case, even when every step is a domain rule. The domain exposes the entity and the ports. The use case decides the order.

## Modules

Group the domain by concept, not by the screen that displays it. A notes application has a `notes` concept. Shared failures and small types used by every concept sit in a shared kernel that is still domain: `InvalidTitle` might be notes-specific, while a generic `NotFound` might be shared.

Cross-concept work does not become a method on `Note`. If saving a note also updates a notebook's count, that coordination is a use case that calls both ports. The note entity stays about a note.

## Purity

The domain imports no application types, no adapter, no presentation type, and no framework. A value object may use the language's standard library. It may not use the web framework's request type, the UI toolkit, or a generated client.

That constraint is what makes a domain test a function call. [Testing by layer](testing.md) starts here because there is nothing to substitute.
