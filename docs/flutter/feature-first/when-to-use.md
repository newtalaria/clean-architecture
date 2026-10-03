---
title: When to use it
description: When this layout matches the way the app changes.
tags: [clean-architecture, flutter]
---

Choose feature-first when features are deleted, extracted, or owned by separate people, and the shared domain is small. The notes client is small enough that the extra `shared/` file looks fussy. It is there so the next feature has a place to put a failure type that is not notes.

Choose [hybrid](../hybrid/README.md) when the domain is the stable part and the screens change. Choose [layer-first](../layer-first/README.md) when you want every feature to repeat inside the same four folders.

Next: [Domain](domain.md).
