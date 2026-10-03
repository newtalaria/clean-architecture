---
title: Infrastructure
description: A request-scoped store, a row type, and a mapper. This is where Session would sit.
tags: [clean-architecture, serverpod, layer-first]
---

The adapter lives at `lib/src/infra/notes/`. Opening `infra/` shows every repository implementation in the process.

`NoteRow` is the persistence model. It stores `createdAtMicros` instead of a `DateTime`, so the row is not a note with a different name. `NoteMapper.toRow` and `toNote` are the only functions that see both.

`NoteStore` is a map of rows. `NoteRepositoryImpl` takes that store in its constructor, the way a Serverpod repository impl takes a `Session`. The composition root builds a new store per graph. Do not cache the impl on a process-wide singleton. The next request would share it.

```dart
class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._store, {NoteMapper? mapper})
    : _mapper = mapper ?? const NoteMapper();

  final NoteStore _store;
  final NoteMapper _mapper;
}
```

In a generated Serverpod server, replace `NoteStore` with `Session`, put the table in a `serverOnly` model, and map uuid columns at this boundary. The port in the domain stays `save` and `findAll`. The file is [`lib/src/infra/notes/note_repository_impl.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/lib/src/infra/notes/note_repository_impl.dart).

This layer imports the domain. It does not import the use case or the endpoint.

Next: [Presentation](presentation.md).
