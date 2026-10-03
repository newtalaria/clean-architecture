---
title: Pros and cons
description: What this folder rule costs, and what it keeps obvious.
tags: [clean-architecture, flutter]
---

## What you gain

One directory is the feature. Reading a save means staying inside `features/notes/` until you hit `app/providers.dart`. Deleting the feature is closer to deleting the folder, plus the lines in the composition root and the route table.

The tile, the notifier, and the entity travel together, so a layout change does not hunt through four top-level trees.

## What it costs

Shared rules need a kernel. `ValidationFailure` lives in `shared/` so notes does not become a junk drawer for the next feature. Skip that and the first feature turns into an unofficial core.

The shell still sits outside the feature. Routes and providers are the tax. A use case that needs another feature's entity has to move the shared type out, or the dependency rule breaks.

Back to the [introduction](README.md), or continue to [when to use it](when-to-use.md).
