---
title: Composition root
description: The only place that constructs concrete adapters and hands them to the outer edge.
tags: [clean-architecture, composition]
---

The composition root is the one place allowed to name concrete classes from every ring. It does not contain a business rule. It answers a single question: which adapter fulfills this port for this process.

## What lives here

```text
composition
  notesRepository(requestContext) -> SqlNoteRepository
  clock() -> SystemClock
  saveNote(requestContext) -> SaveNote(
    notesRepository(requestContext),
    clock(),
  )
```

Presentation asks the composition root for `saveNote` and calls `execute`. Presentation does not import `SqlNoteRepository`. The use case does not import it either. Only this file does, plus the adapter's own file.

## Wiring, not workflow

A composition root that validates a title, chooses a default body, or catches `InvalidTitle` has stopped being a composition root. Those are domain and presentation. If you find a branch here, move it inward or outward until this file is only constructors.

Factories can be functions, a small object, or a container. Use a container when lifetimes differ (one clock for the process, one repository per request) or when the graph is too wide to read as straight-line constructors. A notes app can stay as plain functions. The rule is the same either way: construction happens here, and nowhere else.

## Lifetimes

| Object | Lifetime | Why |
| ------ | -------- | --- |
| Clock, configuration | Process | No per-request state |
| Repository that holds a request session or connection | Request | The next request must not share it |
| Use case that closes over a request-scoped repository | Request | It holds the repository |

Build the request-scoped graph when the request starts, at the edge of the composition root. Do not cache a repository that captured the first request's session.

## Where instrumentation goes

This is also the place that starts process-wide instrumentation, because it is already the place that sees concrete types and the process lifetime. The outer edge then records which screen or which operation ran, because only presentation knows that name. The use case and the domain stay unaware of the recorder. The courses show that wiring on the notes app. The rule in the book is smaller: monitoring is an adapter, constructed here, and called from the outer ring.

## Tests build their own graph

A unit test of `SaveNote` does not boot the composition root. It constructs `SaveNote` with a fake repository and a fixed clock. An integration test builds a smaller graph on purpose: the real repository adapter, a test database, and the real use case. The production composition root stays the production wiring. Tests that import it tend to pull in every adapter, which is the opposite of testing by layer. [Testing by layer](testing.md) shows both graphs.
