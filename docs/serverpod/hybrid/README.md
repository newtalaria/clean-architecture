---
title: Hybrid
description: Domain, application, and infrastructure stay horizontal. The notes endpoint and its wire mapper are the feature slice.
tags: [clean-architecture, serverpod, hybrid]
---

Hybrid keeps the inner rings horizontal and slices the outer edge by feature. `domain/notes`, `application/notes`, and `infra/notes` match the layer-first tree. `presentation/notes/` holds the endpoint and the wire mapper together. There is no shared `presentation/mappers/wire_mappers.dart`.

`app/` is still the only wiring site. A use case does not move into `presentation/notes/` just because the endpoint lives there. If it does, the workflow has started to depend on the edge.

## The tree

```text
lib/src/domain/notes/entities/note.dart
lib/src/application/notes/save_note_use_case.dart
lib/src/infra/notes/note_repository_impl.dart
lib/src/presentation/notes/notes_endpoint.dart
lib/src/presentation/notes/wire_mappers.dart
lib/src/app/use_cases.dart
lib/src/bootstrap/talaria_monitoring.dart
```

The package is [`examples/serverpod/hybrid`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/hybrid/README.md). From that directory, `dart test` runs the domain test, the use-case test with a fake repository, and one integration test through the endpoint.

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

Compare this tree with [layer-first](../layer-first/README.md) and [feature-first](../feature-first/README.md). The [chooser](../README.md) is the table of where a file sits.
