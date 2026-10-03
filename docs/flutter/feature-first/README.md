---
title: Feature-first
description: Feature-first notes client. Providers are hand-written. The tile does not import Riverpod.
tags: [clean-architecture, flutter]
---

The [chooser](../README.md) lists this track last. `features/notes/` holds the domain, the application, the data, and the presentation. A small `shared/` kernel holds `ValidationFailure`, because a blank-title failure is not private to one screen forever.

`app/providers.dart` is still the only wiring site. The router lives in `app/router/` so the shell is not trapped inside the notes feature.

```text
lib/features/notes/domain/
lib/features/notes/application/
lib/features/notes/data/
lib/features/notes/presentation/   page, notifier, and tile
lib/shared/validation_failure.dart
lib/app/providers.dart             composition root
lib/app/router/                    Beamer
lib/bootstrap/talaria_monitoring.dart
```

The app is `examples/flutter/feature_first` (`notes_flutter_feature_first`).

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
