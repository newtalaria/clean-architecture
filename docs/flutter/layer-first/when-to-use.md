---
title: When to use it
description: When this layout matches the way the app changes.
tags: [clean-architecture, flutter]
---

Choose layer-first when the team already thinks in layers and the app is small enough that repeating `notes` in each folder is a help, not a hike. It is the same folder rule as the layer-first Serverpod track.

Choose [hybrid](../hybrid/README.md) when screens should be feature folders and presentational widgets should sit outside Riverpod. Choose [feature-first](../feature-first/README.md) when you want to delete a feature by deleting one directory.

Next: [Domain](domain.md).
