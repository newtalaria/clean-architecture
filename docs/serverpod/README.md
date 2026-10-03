---
title: Serverpod
description: One notes API, built three times. Pick layer-first, feature-first, or hybrid, then instrument it.
tags: [clean-architecture, serverpod]
---

The [book](../README.md) keeps the dependency rule the same in every layout. This course builds that rule as a Serverpod notes API, three times, so you can diff the trees. Each app saves a note and lists notes. A late chapter in each track adds `talaria_serverpod`.

The long walkthrough is [Shelf](../tutorial/README.md). It is a real Serverpod project in the hybrid layout, with books, shelves, and one use case that uses both. These three tracks stay the comparison.

Wire types in these packages are the classes `serverpod generate` would emit, written by hand so `dart test` does not need a protocol. The repository takes a request-scoped `NoteStore` where a Serverpod `Session` would sit, so the tests run without Postgres. On a generated server you replace that store with `Session`, keep the port, and run [generate and migrate](../skills/README.md) when the spy files change.

The [book](../layers/domain.md) names the blank-title failure `InvalidTitle` and passes a command object into the use case. These packages throw `ValidationFailure` and pass `title` and `body` as arguments. The rule is the same: the entity rejects the title, the use case does not catch it, and the endpoint maps the failure to status 400.

## Pick a track

| | Layer-first | Feature-first | Hybrid |
| --- | --- | --- | --- |
| Where a feature lives | The name `notes` repeats inside each layer | `features/notes/` holds every layer | Domain, application, and infra stay horizontal. Presentation is the feature folder |
| Wire mappers | One shared `presentation/mappers` file | Next to that feature's endpoint | Next to that feature's endpoint |
| App | `examples/serverpod/layer_first` | `examples/serverpod/feature_first` | `examples/serverpod/hybrid` |

- [Layer-first](layer-first/README.md) — top folders are the layers. This is the tree to copy when workflows cross features and you want every port in one place.
- [Feature-first](feature-first/README.md) — one folder is the whole use case.
- [Hybrid](hybrid/README.md) — shared inner layers, feature-sliced endpoints.

Read one track to the end. Then open the other two trees and diff `save_note_use_case.dart`. The method asks `Note.create` for a note and `NoteRepository.save` to store it. `save` returns the note the mapper read back from the row, so the caller sees the timestamp that survived `createdAtMicros`. The path of the file is the variable.
