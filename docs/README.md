---
title: Clean architecture
description: Structure an application in layers, then instrument it. The dependency rule stays the same in every layout.
tags: [clean-architecture, book]
---

An application is easier to change when the rules of the business do not import the database, the framework, or the screen. This book is that structure. The courses that follow build one notes app three times, then instrument it.

The dependency rule is the whole method. Source dependencies point inward. Outer code may call inner code. Inner code never imports outer code. Folder ownership is the only thing that changes between layouts. [Principles](principles/README.md) states the rule. [Layers](layers/README.md) says what each ring owns.

## Read the book

- [Principles](principles/README.md) — dependency rule, entities, use cases, ports and adapters, boundaries, and the three layouts
- [Layers](layers/README.md) — domain, application, infrastructure, presentation, composition root
- [One request](layers/request.md) — save a note, from the wire payload to the stored row
- [Testing by layer](layers/testing.md) — what to fake, and what to run against a real store

The running example is a notes application. A note has an identity, a title, and a body. Saving one is enough to show every boundary. The same domain shows up again in each course, so the trees can be compared.

## Coming next

These live in this same book, after the principles.

- **Serverpod** — one small notes API, built layer-first, feature-first, and hybrid. A late chapter instruments the API.
- **Flutter** — the same notes client, built hybrid, layer-first, and feature-first. Each app instruments the composition root and the screen edge.
- **Skills** — rules you copy onto a new project for the layout you chose.

Until those chapters land, the book is the part you can apply in any language.
