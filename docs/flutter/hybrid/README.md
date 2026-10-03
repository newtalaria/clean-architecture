---
title: Hybrid
description: Shared domain and application, a feature screen, and a presentational tile that does not import Riverpod.
tags: [clean-architecture, flutter]
---

The [chooser](../README.md) puts this track first because it is the layout to copy when the domain is shared and the screens are not.

`domain/`, `application/`, and `data/` stay horizontal. The screen is `presentation/features/notes/`. `ui/note_tile.dart` imports Flutter only. `app/providers.dart` is the composition root. Beamer lives in `presentation/router/` and is the router adapter.

```text
lib/domain/notes/
lib/application/notes/
lib/data/notes/
lib/presentation/features/notes/   page and notifier
lib/presentation/router/           Beamer
lib/ui/note_tile.dart              no Riverpod
lib/app/providers.dart             composition root
lib/bootstrap/talaria_monitoring.dart
```

The app is `examples/flutter/hybrid` (`notes_flutter_hybrid`).

## In this track

- [Pros and cons](pros-and-cons.md)
- [When to use it](when-to-use.md)
- [Domain](domain.md)
- [Application](application.md)
- [Data](data.md)
- [Presentation](presentation.md)
- [Composition root](composition.md)
- [Tests](tests.md)
- [Talaria](talaria.md)
