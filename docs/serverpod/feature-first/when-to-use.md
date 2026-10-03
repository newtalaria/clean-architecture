---
title: When to use it
description: Choose feature-first when features are independent and a person should live in one folder.
tags: [clean-architecture, serverpod, feature-first]
---

Choose feature-first when features are independent and a person or an agent should live in one folder. Persistence and UI for that feature are owned there, not only the endpoint.

Choose it over [layer-first](../layer-first/when-to-use.md) when a feature change should not touch four top-level directories, and when you will enforce the dependency rule by review because the folders no longer do it for you.

Choose it over [hybrid](../hybrid/when-to-use.md) when the repository impl belongs to the feature. Hybrid keeps persistence in a shared `infra/` so two features cannot each grow a private `Note`. Feature-first will let them, unless `shared/` and review stop it.

If the same entity is saved by two endpoints, do not start here.

The dependency rule does not change if you pick a different track. [Domain](domain.md) is the same note either way.
