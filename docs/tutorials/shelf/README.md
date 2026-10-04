---
title: Shelf
description: A long tutorial. Build a hybrid Serverpod API and a hybrid Flutter client, one file at a time, then instrument both.
tags: [clean-architecture, tutorial, serverpod, flutter]
---

This is the long tutorial. You build one app, Shelf, in the order you would type it. A shelf holds books. You can save a book, save a shelf, place a book on a shelf, and mark a book as a favourite. Placing a book is one use case that needs both features. Favouriting a book needs only the book repository.

Both sides are hybrid.

On the server, `domain/`, `application/`, and `infra/` are horizontal. The name `book` repeats inside each. `presentation/book/` holds the endpoint, the spy wire types, and `wire_mappers.dart` together. There is no shared `presentation/mappers/wire_mappers.dart`. `app/` is the only place that constructs a repository implementation. A use case never moves into the presentation folder just because the endpoint lives there.

On Flutter, `domain/`, `application/`, and `data/` are horizontal. Screens live in `presentation/features/`. `ui/` does not import Riverpod. Providers in `app/providers.dart` are the composition root. Riverpod 3 is written by hand. Routing is Beamer.

Feature-first is the wrong tree for this server. A workflow that touches two aggregates has no home: it is not only `features/book` and not only `features/shelf`. Layer-first keeps that home, and it is what a large existing server may already use. The part that does not earn its cost on a new project is one shared wire-mapper file that every feature appends to. Hybrid keeps the inner layers shared and puts each mapper next to its endpoint.

The running code is [`examples/tutorial`](https://github.com/newtalaria/clean-architecture/blob/main/examples/tutorial/README.md).

## What you are building

Shelf is a reading shelf for one person on one machine. There are no accounts. Every chapter is about a layer boundary.

A book has a title, an author, a reading status (`unread`, `reading`, or `read`), and a favourite flag. A shelf has a name and a capacity from 1 to 500. A book sits on at most one shelf. A shelf refuses another book when it is full. A favourite does not move the book. You open a shelf, or Favourites, and see those books.

You finish books on the server, then on Flutter, so you can save a book in the app before shelves exist. Shelves repeat the same path in shorter chapters. Placing a book is the chapter that uses both repositories.

## Technologies

| Piece | Choice |
| --- | --- |
| Language | Dart, everywhere a type is not a Postgres row or an API contract |
| Server | Serverpod 4 |
| Database | PostgreSQL, through the Serverpod ORM |
| Persistence models | `infra/models/*.spy.yaml`, `serverOnly: true` |
| API models | `presentation/**/*.spy.yml` |
| Server tests | `package:test`, fakes for use cases, `withServerpod` for the endpoint |
| Client | Flutter |
| Client state | Riverpod 3, hand-written providers, no `riverpod_annotation` |
| Client models | `dart_mappable` on the domain entities |
| Router | Beamer |
| Instrumentation | `talaria_serverpod`, then `talaria_flutter` |

Spy files exist only where Serverpod has to generate a table or a client type. Entities, value objects, repository interfaces, use cases, commands, and both kinds of mapper are Dart. Domain and application never import `lib/src/generated/` or `package:shelf_client`.

The API in this sample listens on port **8280**. Insights is 8281, the web server is 8282, and Postgres is 8290. The test database is 9290. Those ports stay off 8080 and 8090.

## The server map

```text
lib/src/domain/book/
lib/src/domain/shelf/
lib/src/domain/shared/exceptions/
lib/src/application/book/
lib/src/application/shelf/
lib/src/application/ports/
lib/src/infra/models/          stored_book.spy.yaml, stored_shelf.spy.yaml
lib/src/infra/book/
lib/src/infra/shelf/
lib/src/presentation/book/     endpoint, spy wire types, wire_mappers.dart
lib/src/presentation/shelf/
lib/src/app/                   repositories.dart, use_cases.dart, di.dart
lib/src/bootstrap/talaria_monitoring.dart
```

## The Flutter map

```text
lib/domain/book/
lib/domain/shelf/
lib/application/book/
lib/application/shelf/
lib/data/                     Serverpod repositories and ProtocolMappers
lib/presentation/features/books/
lib/presentation/features/shelves/
lib/presentation/features/favourites/
lib/presentation/router/      Beamer
lib/ui/                       tiles, shelf_theme.dart, shelf_frame.dart, no Riverpod
lib/app/providers.dart
lib/bootstrap/talaria_monitoring.dart
```

The Flutter domain is written again. The client package cannot import the server's domain. The rules are the same. The ids are not: the server assigns the id that the client stores.

## Read it in this order

**Server, books, until it runs**

1. [Project](server/project.md)
2. [Failures](server/failures.md)
3. [Book title](server/book-title.md)
4. [Reading status](server/reading-status.md)
5. [Book](server/book.md)
6. [Book repository](server/book-repository.md)
7. [Ports](server/ports.md)
8. [Save a book](server/save-book.md)
9. [List books](server/list-books.md)
10. [Book tests](server/book-tests.md)
11. [Stored book](server/stored-book.md)
12. [Book mapper](server/book-mapper.md)
13. [Book repository implementation](server/book-repository-impl.md)
14. [Book wire types](server/book-wire.md)
15. [Book endpoint](server/book-endpoint.md)
16. [Composition root](server/composition.md)
17. [Integration test](server/integration.md)

**Flutter, books, so you can demo**

18. [Flutter project](flutter/project.md)
19. [Flutter domain](flutter/domain.md)
20. [Flutter application](flutter/application.md)
21. [Data](flutter/data.md)
22. [Providers](flutter/providers.md)
23. [Books screen](flutter/presentation.md)
24. [Run the app](flutter/run.md)

**Shelves, then both features**

25. [Shelves on the server](server/shelves.md)
26. [Shelves on Flutter](flutter/shelves.md)
27. [Place a book on a shelf](server/place-book.md)
28. [The place control](flutter/place-book.md)
29. [Favourite a book](server/favorite.md)
30. [Favourite on Flutter](flutter/favorite.md)

**Talaria, after the app runs**

31. [Server instrumentation](server/talaria.md)
32. [Flutter instrumentation](flutter/talaria.md)
33. [Where to go next](close.md)

The short courses are still there if you want to diff the three layouts on a notes API. This tutorial is the one to follow when you are starting a Serverpod project.
