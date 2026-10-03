---
title: When to use it
description: Choose hybrid when most changes are endpoints and the domain is still shared.
tags: [clean-architecture, serverpod, hybrid]
---

Choose hybrid when most changes are endpoints and the domain is still shared. Persistence and business rules stay in the horizontal layers. The endpoint and its wire mapper are the part that grows by feature.

Choose it over [layer-first](../layer-first/when-to-use.md) when a shared `wire_mappers.dart` would become the file everyone conflicts on, and when you still want one `domain/notes`.

Choose it over [feature-first](../feature-first/when-to-use.md) when the repository impl must stay shared. Two features that both save notes should call the same `NoteRepository`, implemented once under `infra/notes`, not two private copies under two feature folders.

The rule to write down for this track: a use case lives in `application/`, even when the only caller is `presentation/notes`.

The dependency rule does not change if you pick a different track. [Domain](domain.md) is the same note either way.
