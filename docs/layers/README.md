---
title: Layers
description: Domain, application, infrastructure, presentation, and the composition root. Three models meet at each boundary.
tags: [clean-architecture, layers]
---

Five places. Each one answers a different question. The names below are the rings, not a required directory spelling. A feature-first tree nests the same rings under `features/notes/`. A hybrid tree keeps the inner three horizontal and slices presentation by feature. The questions do not change. [Principles](../principles/README.md) is why.

| Ring | Question |
| ---- | -------- |
| [Domain](domain.md) | What are the concepts, and which rules always hold? |
| [Application](application.md) | What workflows does the system perform? |
| [Infrastructure](infrastructure.md) | How do we talk to the store and other processes? |
| [Presentation](presentation.md) | How does a client invoke a workflow? |
| [Composition root](composition-root.md) | Which concrete adapter fulfills each port? |

## What crosses a boundary

Three models describe the same note, and each one is allowed to look different.

```text
wire payload          command / result         entity              row
--------------        ----------------         ------              ---
{ title, body }  ->   SaveNote(title, body) -> Note(id, title, ...) -> notes(id, title, body, created_at)
```

Presentation maps the wire payload to a command, and a result back to a wire response. The use case speaks only in commands, results, and domain types. Infrastructure maps the entity to a row and back. [One request](request.md) is that chain with the failures written in.

## How a call moves

```text
caller
  -> presentation        map wire to command, call the use case
  -> application         run the workflow
  -> domain              enforce the invariant, return the entity
  -> infrastructure      persist, through the port the use case already holds
  -> presentation        map the result or the failure back to the caller
```

The infrastructure call happens at runtime inside the use case, through a port. The source dependency still points inward: the use case imports the port, and the adapter imports the use case's world only by implementing the port. The composition root is what makes the two meet.

## Read in this order

1. [Domain](domain.md)
2. [Application](application.md)
3. [Infrastructure](infrastructure.md)
4. [Presentation](presentation.md)
5. [Composition root](composition-root.md)
6. [One request](request.md)
7. [Testing by layer](testing.md)
