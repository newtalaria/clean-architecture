---
title: Serverpod
description: One notes API, built three times. Pick layer-first, feature-first, or hybrid, then instrument it.
tags: [clean-architecture, serverpod]
---

The [book](../README.md) keeps the dependency rule the same in every layout. This course builds that rule as a Serverpod notes API, three times, so you can diff the trees. Each app saves a note and lists notes. A late chapter in each track adds `talaria_serverpod`.

The notes sample is the slice, not a full generated server. Wire types are the classes `serverpod generate` would emit. The repository takes a request-scoped store in the place a Serverpod `Session` would sit, so `dart test` runs without Postgres. The folders, the imports, and the composition root are the lesson.

## Pick a track

| | Layer-first | Feature-first | Hybrid |
| --- | --- | --- | --- |
| Where a feature lives | The name `notes` repeats inside each layer | `features/notes/` holds every layer | Domain, application, and infra stay horizontal. Presentation is the feature folder |
| Wire mappers | One shared `presentation/mappers` file | Next to that feature's endpoint | Next to that feature's endpoint |
| App | `examples/serverpod/layer_first` | `examples/serverpod/feature_first` | `examples/serverpod/hybrid` |

- [Layer-first](layer-first/README.md) — top folders are the layers. This is the tree to copy when workflows cross features and you want every port in one place.
- [Feature-first](feature-first/README.md) — one folder is the whole use case.
- [Hybrid](hybrid/README.md) — shared inner layers, feature-sliced endpoints.

Read one track to the end. Then open the other two trees and diff `save_note_use_case.dart`. The use case is the same. The path is the variable.
