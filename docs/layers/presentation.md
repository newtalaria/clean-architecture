---
title: Presentation
description: A thin edge that maps the wire model to a command, calls one use case, and maps failures back out.
tags: [clean-architecture, presentation]
---

Presentation is the incoming adapter. It turns an outside request into one use case call, then turns the result or the failure into the response that caller understands. A screen, an endpoint, and a job runner are all presentation when they are the thing that invokes the workflow.

## What lives here

| Artifact | Notes example | Why it is here |
| -------- | ------------- | -------------- |
| Entry point | `NotesEndpoint.save` or a submit handler | Receives the outside call |
| Wire model | `SaveNotePayload` | Fields and names the client speaks |
| Mapper | `toSaveNoteCommand` | Wire model to command, result to wire model |
| Failure mapper | `InvalidTitle` to the client's error | The caller does not import domain types |

The entry point stays thin:

```text
save(request):
  command = toSaveNoteCommand(request.payload)
  result = saveNote.execute(command)
  return toSaveNoteResponse(result)
```

Auth context that arrived with the request (who is calling) is read here and placed on the command. The policy that decides whether that person may save a note is a use case step, or a domain rule, depending on whether it is a workflow or an invariant. The entry point does not re-implement it.

## The wire model

The payload is the third model at the boundary. It exists to be serialized. It is allowed to be awkward in ways the entity is not: optional fields, names that match a public API, ids omitted on create because the server assigns them.

```text
SaveNotePayload
  title
  body

SaveNoteResponse
  id
  title
  body
  createdAt
```

The client sends no `id` and no `createdAt`. The response has both, because the use case created them. That difference is a reason the payload is not a `Note`. If the public API renames `body` to `text`, the mapper changes. `Note` does not.

## Errors across a boundary

Failures mean different things, and presentation is where they become a response.

| Failure | Raised by | What presentation does |
| ------- | --------- | ---------------------- |
| `InvalidTitle` | Domain, while creating the note | A client error that names the field |
| Not found | Application, when a load returns nothing the workflow required | A client error for an unknown id |
| Store timeout, connection reset | Infrastructure | A server failure. The title was fine |

Do not catch a store timeout inside the domain and rethrow it as `InvalidTitle`. Do not let the use case format an error string for a particular client. Map at the edge, once, so a second entry point can map the same failure differently.

Unexpected failures can stay unexpected. Presentation maps the ones it knows. A programming bug is not a domain failure and does not need a polite field error.

## What stays outside

- Constructing `SqlNoteRepository` or any concrete adapter
- Business invariants (`title` is not blank)
- Multi-step workflows
- Query text

If the entry point grows past the map-call-map shape, the extra steps belong in the use case. The edge is replaceable: the same `SaveNote` serves an HTTP route, a generated RPC endpoint, or a test that calls `execute` directly.
