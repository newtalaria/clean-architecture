---
title: Feature-first
description: One notes folder holds domain, application, infrastructure, and presentation. The composition root stays shared.
tags: [clean-architecture, serverpod, feature-first]
---

Feature-first puts the whole notes use case in one folder. `features/notes/domain`, `application`, `infra`, and `presentation` sit together. A small `shared/` kernel holds `ValidationFailure`. `app/` is still the only wiring site.

Open `features/notes/` and you can read save-a-note without jumping to four top-level directories. The dependency rule is unchanged: `features/notes/domain` imports nothing from the other three, even though they are siblings.

## The tree

```text
lib/src/features/notes/domain/note.dart
lib/src/features/notes/application/save_note_use_case.dart
lib/src/features/notes/infra/note_repository_impl.dart
lib/src/features/notes/presentation/notes_endpoint.dart
lib/src/features/notes/presentation/wire_mappers.dart
lib/src/shared/validation_failure.dart
lib/src/app/use_cases.dart
lib/src/bootstrap/talaria_monitoring.dart
```

The package is [`examples/serverpod/feature_first`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/feature_first/README.md). From that directory, `dart test` runs the domain test, the use-case test with a fake repository, and one integration test through the endpoint.

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
