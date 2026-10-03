---
title: Flutter
description: One notes client, built three times. Pick hybrid, layer-first, or feature-first, then instrument it.
tags: [clean-architecture, flutter]
---

The [book](../README.md) keeps the dependency rule the same in every layout. This course builds that rule as a Flutter notes client, three times, so you can diff the trees. Each app saves a note and lists notes. A late chapter in each track adds `talaria_flutter`.

Providers are hand-written Riverpod 3. There is no `riverpod_annotation` and no `build_runner` step, so `flutter test` is the whole check. Entities are plain Dart. Beamer is the router adapter: a location builds the page and reports the screen. The repository keeps notes in memory, in the place an API client would sit, so the tests do not need a backend.

## Pick a track

| | Hybrid | Layer-first | Feature-first |
| --- | --- | --- | --- |
| Where a feature lives | Domain, application, and data stay horizontal. The screen is `presentation/features/notes/` | The name `notes` repeats inside each layer, including `presentation/notes/` | `features/notes/` holds every layer |
| Presentational tile | `ui/note_tile.dart`, no Riverpod | Beside the page in `presentation/notes/` | Beside the page inside the feature |
| App | `examples/flutter/hybrid` | `examples/flutter/layer_first` | `examples/flutter/feature_first` |

- [Hybrid](hybrid/README.md) — shared inner layers, a feature screen, and a `ui/` tile with no Riverpod. This is the tree to copy when screens change and the domain stays shared.
- [Layer-first](layer-first/README.md) — top folders are the layers.
- [Feature-first](feature-first/README.md) — one folder is the whole client feature.

Read one track to the end. Then open the other two trees and diff `save_note_use_case.dart`. The use case is the same. The path is the variable.
