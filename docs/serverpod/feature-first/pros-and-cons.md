---
title: Pros and cons
description: What you gain when one folder is the whole use case, and where the dependency rule gets easier to break.
tags: [clean-architecture, serverpod, feature-first]
---

## What you gain

A feature is one place to read, delete, or hand to someone. A change to notes stays inside `features/notes/` except for the composition-root factory. Extracting the feature later is mostly a folder move.

The wire mapper sits next to the endpoint, so you do not grow a shared `wire_mappers.dart` hotspot just to save a note.

## What it costs

Infra sits next to domain. Nothing in the folder tree stops `note.dart` from importing `note_repository_impl.dart`. The rule is the import, and you have to keep it.

Shared business rules slide into `shared/` or get copied into the next feature. A workflow that saves a note and updates a notebook has no obvious home: it is not only `features/notes` and not only `features/notebooks`.

You cannot open one directory and see every repository or every use case. They are spread across feature folders.

Back to the [introduction](README.md), or continue to [when to use it](when-to-use.md).
