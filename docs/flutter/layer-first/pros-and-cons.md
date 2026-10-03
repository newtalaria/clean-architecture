---
title: Pros and cons
description: What this folder rule costs, and what it keeps obvious.
tags: [clean-architecture, flutter]
---

## What you gain

One rule. If you know the layer, you know the folder. `domain/notes`, `application/notes`, `data/notes`, and `presentation/notes` are the whole feature. A new port has one obvious home.

Diffing this tree against hybrid is mostly the screen path. The use case file is the same class in a predictable place.

## What it costs

A screen change touches the presentation layer, and a small widget has no separate presentational tree to hide in. `presentation/notes/` grows the page, the notifier, and the tile together.

Cross-feature work is easy to find and easy to entangle. Two features that share a widget either lift it to `presentation/shared/` or copy it.

Back to the [introduction](README.md), or continue to [when to use it](when-to-use.md).
