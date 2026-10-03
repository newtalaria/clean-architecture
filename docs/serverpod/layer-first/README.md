---
title: Layer-first
description: Top folders are the layers. The notes feature repeats inside each one, and wire mappers live in one shared file.
tags: [clean-architecture, serverpod, layer-first]
---

Layer-first is the horizontal tree. `domain/`, `application/`, `infra/`, and `presentation/` are the top folders. `notes` is a folder inside each of them. `app/` is the only place that constructs `NoteRepositoryImpl`.

This is the shape to copy from a Serverpod server whose modules repeat by layer: an endpoint under `presentation/notes`, a use case under `application/notes`, a port under `domain/notes`, and an impl under `infra/notes`. Wire mapping sits in `presentation/mappers/wire_mappers.dart`, one file for every endpoint, instead of beside a single feature.

## The tree

```text
lib/src/domain/notes/entities/note.dart
lib/src/domain/notes/note_repository.dart
lib/src/application/notes/save_note_use_case.dart
lib/src/application/ports/clock.dart
lib/src/infra/notes/note_repository_impl.dart
lib/src/presentation/notes/notes_endpoint.dart
lib/src/presentation/mappers/wire_mappers.dart
lib/src/app/use_cases.dart
lib/src/bootstrap/talaria_monitoring.dart
```

The package is [`examples/serverpod/layer_first`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/layer_first/README.md). From that directory, `dart test` runs the domain test, the use-case test with a fake repository, and one integration test through the endpoint.

## Read this track

1. [Pros and cons](pros-and-cons.md)
2. [When to use it](when-to-use.md)
3. [Domain](domain.md)
4. [Application](application.md)
5. [Infrastructure](infrastructure.md)
6. [Presentation](presentation.md)
7. [Composition root](composition.md)
8. [Tests](tests.md)
9. [Talaria](talaria.md)

The other tracks are [layer-first](../layer-first/README.md), [feature-first](../feature-first/README.md), and [hybrid](../hybrid/README.md). The [chooser](../README.md) compares where a file sits.
