---
title: Pros and cons
description: What you gain when the domain stays shared and endpoints are local, and the two rules you have to remember.
tags: [clean-architecture, serverpod, hybrid]
---

## What you gain

The hard boundary stays obvious. `domain/` and `application/` are shared, so two endpoints cannot each invent a `Note`. Endpoint work is local: a new feature adds `presentation/notebooks/` with its own mapper, and leaves the note entity where it is.

The composition root stays one place. Screen-level or endpoint-level changes do not require a new top-level layer.

## What it costs

Two rules, not one. Inner code is horizontal. Presentation is vertical. A feature is not one folder, so you still cross `domain/notes` and `presentation/notes` to follow a save.

Use cases drift into the feature folder unless you forbid it. `presentation/notes/save_note_use_case.dart` would look convenient and would couple the workflow to the endpoint slice.

Back to the [introduction](README.md), or continue to [when to use it](when-to-use.md).
