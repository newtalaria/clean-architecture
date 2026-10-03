---
title: Pros and cons
description: What this folder rule costs, and what it keeps obvious.
tags: [clean-architecture, flutter]
---

## What you gain

The hard boundary stays obvious. `domain/` and `application/` are shared, so two screens cannot each invent a `Note`. Screen work is local: a new feature adds `presentation/features/notebooks/` and leaves the note entity where it is.

`ui/` stays dumb. A tile can be pumped in a test with no `ProviderScope`, which keeps presentational widgets from growing a provider of their own.

## What it costs

Two rules, not one. Inner code is horizontal. Screens are vertical. A feature is not one folder, so you still cross `domain/notes` and `presentation/features/notes` to follow a save.

Use cases drift into the feature folder unless you forbid it. `presentation/features/notes/save_note_use_case.dart` would look convenient and would couple the workflow to the screen.

Back to the [introduction](README.md), or continue to [when to use it](when-to-use.md).
