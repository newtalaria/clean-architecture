---
title: Pros and cons
description: What you gain when the folder tree is the dependency rule, and what a feature change costs.
tags: [clean-architecture, serverpod, layer-first]
---

## What you gain

The directory is the dependency rule. `domain/` has no import path that reaches `infra/` without climbing out of the folder, and a review can see that. Every use case is under `application/`. Every mapper is under `infra/` or `presentation/mappers`. Tests follow the same split: `test/unit/domain`, `test/unit/application`, `test/integration`.

A workflow that touches two features has a home. It stays a use case in `application/`, calling both ports. You do not have to decide which feature folder owns the workflow.

## What it costs

A change to notes touches `domain/notes`, `application/notes`, `infra/notes`, and `presentation/notes`. Someone new to the tree follows one request across four directories.

The shared files grow. `app/use_cases.dart` and `presentation/mappers/wire_mappers.dart` become the hotspots, because every feature adds a factory and a mapping function there. That concentration is the point of the layout, and it is also why the files get long.

Back to the [introduction](README.md), or continue to [when to use it](when-to-use.md).
