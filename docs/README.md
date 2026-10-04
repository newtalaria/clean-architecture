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

## Courses

- [Tutorials](tutorials/README.md) — long courses, each in its own folder. [Shelf](tutorials/shelf/README.md) is a hybrid Serverpod API and a hybrid Flutter client, one file at a time, including one use case that uses two features
- [Serverpod](serverpod/README.md) — the same notes API, built layer-first, feature-first, and hybrid, then instrumented with `talaria_serverpod`
- [Flutter](flutter/README.md) — the same notes client, built hybrid, layer-first, and feature-first, then instrumented with `talaria_flutter`
- [Skills](skills/README.md) — copy the dependency rule and the layout you picked onto a new project

The book above applies in any language. The courses are where the folders become Dart. The skills page is how those rules move onto the next app.
