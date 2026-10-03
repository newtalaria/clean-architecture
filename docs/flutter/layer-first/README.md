---
title: Layer-first
description: The feature name repeats inside every layer, including the page, the notifier, and the tile.
tags: [clean-architecture, flutter]
---

The [chooser](../README.md) lists this track second. Top folders are the layers. The feature name `notes` repeats inside each one, including the screen. There is no `ui/` folder and no `presentation/features/`.

The dependency rule matches the other tracks. The folder rule is the variable: one layer, one directory, every feature.

```text
lib/domain/notes/
lib/application/notes/
lib/data/notes/
lib/presentation/notes/     page, notifier, and tile
lib/presentation/router/    Beamer
lib/app/providers.dart      composition root
lib/bootstrap/talaria_monitoring.dart
```

The app is `examples/flutter/layer_first` (`notes_flutter_layer_first`).

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
