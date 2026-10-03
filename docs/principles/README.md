---
title: Principles
description: The dependency rule, entities, use cases, ports and adapters, and the three ways a folder can own a feature.
tags: [clean-architecture, principles]
---

Clean architecture separates **what the system means** from **how a request arrives** and **how a fact is stored**. The split is there so a business rule can be tested without a server, and so a storage change does not rewrite the rule.

## The dependency rule

Source dependencies point inward.

```text
        presentation          infrastructure
               \                    /
                \                  /
                 \                /
                  application
                       |
                     domain
```

Presentation and infrastructure are both outer. They may depend on application and domain. They do not depend on each other. Application may depend on domain. Domain depends on nothing outside itself.

| Ring | May use | Never uses |
| ---- | ------- | ---------- |
| Domain | Its own types | Application, infrastructure, presentation, a framework |
| Application | Domain, and ports it declares | A database driver, a wire payload, a concrete adapter |
| Infrastructure | Domain, and the framework it adapts | Application, presentation |
| Presentation | Application, domain types | A concrete repository, a query language |
| Composition root | Every concrete type | Business rules |

The rule is about **imports**, not about the order of calls at runtime. A use case calls a repository port. The method that actually writes a row lives in infrastructure. The use case never names that class. The composition root is the only file that does.

## Entities

An entity is a business object with an identity and a lifecycle. A note is an entity: once it exists, later edits are still the same note. The rules that make a note valid live on the entity, or in a value object it holds.

A value object has no identity. Two titles with the same characters are the same title. Put an invariant there when breaking it would make the object meaningless: a title that cannot be blank, an email that must contain a domain.

```text
Note
  id
  title
  body

  create(title, body):
    require title is not blank
    return Note(new identity, title, body)
```

If you deleted the framework and the database, this type would still compile, and its tests would still pass. That is the test of whether it belongs in the domain.

## Use cases

A use case is one intent. "Save a note" is a use case. "List notes" is another. It is not a new kind of thing in the domain. It is the steps the application takes to fulfill a request:

1. Accept a command or a query that is already in application types.
2. Apply the workflow: validate, call the domain, call ports.
3. Return a result, or fail with an application or domain failure.

The use case coordinates. It does not know the table name, the HTTP status, or the widget that drew the button.

## Ports and adapters

A port is an interface the inner ring declares because it needs something from the outside. "Save this note and load it again" is a port. The domain, or the application, owns the interface. Infrastructure owns the class that implements it.

```text
port NoteRepository
  save(note) -> note
  find(id) -> note or nothing

adapter SqlNoteRepository implements NoteRepository
  save(note):
    row = toRow(note)
    write row
    return note
```

The port is named for the capability, not for the product that provides it. `NoteRepository` can be SQL today and a fake in a unit test. The use case does not change.

Adapters also sit on the way in. A presentation adapter turns a wire payload into a command and a result back into a wire response. That adapter is not the repository. Incoming and outgoing adapters meet only in the composition root.

## Boundaries

A boundary is a place where the model changes. Three models show up in a typical request, and they are not the same type with three names:

| Model | Where it lives | What it is for |
| ----- | -------------- | -------------- |
| Domain | Domain | The business object and its invariants |
| Persistence | Infrastructure | The row, document, or cache entry |
| Wire | Presentation | The payload the client sends and receives |

Map at the boundary. Do not pass a row into a use case. Do not pass a wire payload into the domain. Do not let a column name become a field on the entity just because the table has that column. [One request](../layers/request.md) walks a single save through all three.

Errors cross the same boundary in the other direction. A domain failure ("the title is blank") is a business fact. An infrastructure failure ("the store timed out") is not a business rule. Presentation decides how each one looks to the caller. The domain does not choose a status code.

## Folder ownership

The dependency rule does not change when you pick a layout. What changes is which directory owns a feature. [Layers](../layers/README.md) is written so it stays true in all three.

**Layer-first.** The top folders are the rings. The feature name repeats inside each one.

```text
domain/notes
application/notes
infrastructure/notes
presentation/notes
composition/
```

Open `application/` and you see every use case. A change to one feature touches several directories. The tree itself is the dependency rule: `domain/` has nothing to import from the folders above it.

**Feature-first.** One folder holds every ring for that feature. A small shared kernel stays outside it.

```text
features/notes/domain
features/notes/application
features/notes/infrastructure
features/notes/presentation
shared/
composition/
```

Open `features/notes/` and you see the whole use case. The dependency rule is easier to break, because the adapter sits next to the entity. The import rule is the same even so: `features/notes/domain` still imports nothing from the other three.

**Hybrid.** The inner rings stay horizontal and shared. The outer edge is vertical.

```text
domain/notes
application/notes
infrastructure/notes
presentation/notes/    # endpoints or screens for this feature only
composition/
```

Shared business rules stay in one domain. Screen or endpoint work stays in one feature folder. A use case still does not move into that feature folder. If it does, the inner ring has started to depend on the outer one.

Choose layer-first when workflows cross features and you want every port in one place. Choose feature-first when a feature is independent and one person should live in one folder. Choose hybrid when most changes are screens or endpoints and the domain is still shared.

The courses build the notes app in each tree. The book from here on talks about rings, not about which directory name you picked.
