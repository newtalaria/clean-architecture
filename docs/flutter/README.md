---
title: Flutter
description: One notes client, built three times. Pick hybrid, layer-first, or feature-first, then instrument it.
tags: [clean-architecture, flutter]
---

The [book](../README.md) keeps the dependency rule the same in every layout. This course builds that rule as a Flutter notes client, three times, so you can diff the trees. Each app saves a note and lists notes. A late chapter in each track adds `talaria_flutter`.

The long walkthrough is [Shelf](../tutorial/README.md). The Flutter half is the hybrid layout: shared domain and application, feature screens, and a `ui/` tile with no Riverpod. These three tracks stay the comparison.

Providers are written by hand in Riverpod 3. `flutter test` is the whole check, with no code generator for providers. Entities are plain Dart. Beamer is the router adapter: a location builds the page and reports the screen. Notes are kept in memory, where an API client would sit, so the tests do not need a backend. `main` still wraps an HTTP client when `TALARIA_API_KEY` is set. The notes repository does not call it. That client is the hook a real API call would use.

## Pick a track

| | Hybrid | Layer-first | Feature-first |
| --- | --- | --- | --- |
| Where a feature lives | Domain, application, and data stay horizontal. The screen is `presentation/features/notes/` | The name `notes` repeats inside each layer, including `presentation/notes/` | `features/notes/` holds every layer |
| Presentational tile | `ui/note_tile.dart`, no Riverpod | Beside the page in `presentation/notes/` | Beside the page inside the feature |
| App | `examples/flutter/hybrid` | `examples/flutter/layer_first` | `examples/flutter/feature_first` |

- [Hybrid](hybrid/README.md) — shared inner layers, a feature screen, and a `ui/` tile with no Riverpod. This is the tree to copy when screens change and the domain stays shared.
- [Layer-first](layer-first/README.md) — top folders are the layers.
- [Feature-first](feature-first/README.md) — one folder is the whole client feature.

Read one track to the end. Then open the other two trees and diff `save_note_use_case.dart`. The method asks `Note.create` for a note and `NoteRepository.save` to store it, then returns the note it built. `Note.create` trims the title and the body. A blank title throws `ValidationFailure` with the message `Title is required`, and the page shows that string under the form. The [book](../layers/domain.md) calls the same failure `InvalidTitle`. The path of the file is the variable.
