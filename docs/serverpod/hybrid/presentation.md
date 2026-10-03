---
title: Presentation
description: A thin save method maps the wire input, calls the use case, and maps ValidationFailure to a 400.
tags: [clean-architecture, serverpod, hybrid]
---

The endpoint and the wire mapper both live at `lib/src/presentation/notes/`. That is the vertical edge. Layer-first would have put the mapper in `presentation/mappers/wire_mappers.dart`. Hybrid keeps the mapping next to the endpoint so a feature's wire shape is local, while the entity stays shared.

`SaveNoteInput` and `NoteDto` are the wire model. The client sends a title and a body. The response adds `id` and `createdAt`. Those classes are what `.spy.yml` inputs and DTOs become after `serverpod generate`. This package writes them by hand so the tests do not need a generated protocol.

`NotesEndpoint.save` is the whole edge:

```dart
Future<NoteDto> save(SaveNoteInput input) async {
  try {
    final note = await useCases.saveNote().execute(
      title: input.title,
      body: input.body,
    );
    return mappers.toNoteDto(note);
  } on ValidationFailure catch (error) {
    throw NoteRequestFailure(400, error.message);
  }
}
```

On a generated server this method sits on a class that extends `Endpoint`, and the first argument is a `Session`. The body stays map, call, map. `WireMappers` turns a `Note` into a `NoteDto`. The endpoint does not construct `NoteRepositoryImpl`. It receives `UseCases` from the composition root.

`list` is the same shape for the read path. The endpoint is [`lib/src/presentation/notes/notes_endpoint.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/hybrid/lib/src/presentation/notes/notes_endpoint.dart). The mapper is [`lib/src/presentation/notes/wire_mappers.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/hybrid/lib/src/presentation/notes/wire_mappers.dart).

A blank title becomes status 400. A store failure is not caught here and is not relabeled as `ValidationFailure`.

Next: [Composition root](composition.md).
