---
title: When to use it
description: Choose layer-first when the domain is shared and workflows cross features.
tags: [clean-architecture, serverpod, layer-first]
---

Choose layer-first when the domain is shared and a workflow can touch more than one feature. A Serverpod API that groups several aggregates in one use case wants every port findable under `domain/` and every workflow under `application/`.

Choose it over [feature-first](../feature-first/when-to-use.md) when you want a lint or a review to enforce the dependency rule by folder, and when you accept touching several directories for one feature.

Choose it over [hybrid](../hybrid/when-to-use.md) when the endpoint layer should follow the same horizontal rule as the domain, including a shared wire-mapper file. Hybrid keeps that inner rule and lets presentation split by feature. Layer-first does not make that exception.

If most of the work is a new endpoint on a stable domain, hybrid will feel lighter. If two features must not grow two copies of `Note`, layer-first keeps the entity in one `domain/notes`.

The dependency rule does not change if you pick a different track. [Domain](domain.md) is the same note either way.
