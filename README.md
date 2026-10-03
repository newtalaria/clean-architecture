# Clean architecture

A short book on structuring an application so business rules stay independent of the framework, the database, and the screen. Two courses build the same notes app three times. A skills pack copies the rules onto a new project.

The book is published at [newtalaria.com/docs/clean-architecture](https://www.newtalaria.com/docs/clean-architecture).

Chapters are edited in `docs/` in this repository. The marketing site reads that tree and serves it at `/docs/clean-architecture/**`.

## Layout

```
docs/                 book, courses, and the skills guide
examples/serverpod/   layer-first, feature-first, and hybrid notes API
examples/flutter/     the same three layouts as a notes client
skills/               rules and skills to copy onto a project
```

The dependency rule is the same in every layout. Inner code never imports outer code. The folder that owns a feature is the only thing that changes.

| Layout | What owns a feature |
| ------ | ------------------- |
| Layer-first | The feature name repeats inside each layer: `domain/notes`, `application/notes`, and so on |
| Feature-first | One folder holds every layer: `features/notes/domain`, `application`, `infrastructure`, `presentation` |
| Hybrid | Domain, application, and persistence stay horizontal. Screens or endpoints are sliced by feature |

## Book

- [Principles](docs/principles/README.md) — the dependency rule, entities, use cases, ports, and boundaries
- [Layers](docs/layers/README.md) — what each layer owns, one request through the stack, and how to test it

The Serverpod course, the Flutter course, and the skills pack are added in this same repository after the book.
