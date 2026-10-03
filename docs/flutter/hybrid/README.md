---
title: Hybrid
description: Hybrid notes client. Providers are hand-written. The tile does not import Riverpod.
tags: [clean-architecture, flutter]
---

The [chooser](../README.md) puts this track first because it is the layout to copy when the domain is shared and the screens are not. Domain, application, and data stay horizontal. The notes screen is a feature folder. The note tile is presentational and does not import Riverpod.

This tree follows the customer dashboard: `domain/`, `application/`, `data/`, `presentation/features/notes/`, `ui/`, and `app/providers.dart` as the composition root. Beamer lives in `presentation/router/` and is the router adapter.

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
