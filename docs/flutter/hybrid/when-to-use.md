---
title: When to use it
description: When this layout matches the way the app changes.
tags: [clean-architecture, flutter]
---

Choose hybrid when most changes are screens and the domain is still shared. One `domain/` and `application/`, features under `presentation/features/`, and presentational widgets that do not import Riverpod.

Choose another track when that split is the wrong cost. [Layer-first](../layer-first/README.md) if you want one rule for every folder, including the screen. [Feature-first](../feature-first/README.md) if a feature should be deletable as one directory.

Next: [Domain](domain.md).
