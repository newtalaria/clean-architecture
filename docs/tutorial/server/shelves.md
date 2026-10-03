---
title: Shelves on the server
description: The same path as books. A name, a capacity, a row, a mapper, wire types, and a thin endpoint.
tags: [clean-architecture, tutorial, serverpod]
---

A shelf is the second feature. You already know where each file goes. This chapter names what is different.

## Domain

`ShelfName.parse` trims the name, rejects an empty name, and rejects a name longer than 80 characters. `Shelf.create` rejects a capacity outside 1 to 500 with `ValidationFailure('Capacity must be from 1 to 500')`. `ensureRoomForAnother(int booksAlreadyOnShelf)` throws `Conflict('Shelf is full')` when `booksAlreadyOnShelf >= capacity`. It does not look at books. The use case will pass the count.

`ShelfRepository` is `save`, `findById`, and `list`. It does not count books. Counting books is `BookRepository.countOnShelf`.

## Application

`SaveShelfCommand` holds `name` and `capacity`. `SaveShelfUseCase` matches `SaveBookUseCase`: id port, clock, `Shelf.create`, `save`. `ListShelvesUseCase` calls `list`.

Do not put `PlaceBookOnShelfUseCase` in this chapter. That class is the next server chapter, because it is the one that takes both repositories.

## Infrastructure

`lib/src/infra/models/stored_shelf.spy.yaml`:

```yaml
### Persistence row for a shelf. Not the domain entity.
class: StoredShelf
serverOnly: true
table: stored_shelf
fields:
  id: UuidValue?, defaultPersist=random_v7
  name: String
  capacity: int
  createdAt: DateTime
```

`ShelfMapper` maps `UuidValue` and `int`. There is no enum. `ShelfRepositoryImpl` inserts or updates by id and sorts `list` newest first, the same way `BookRepositoryImpl` does.

## Presentation

Spy files under `presentation/shelf/`:

```yaml
class: SaveShelfInput
fields:
  name: String
  capacity: int
```

```yaml
class: ShelfDto
fields:
  id: UuidValue
  name: String
  capacity: int
  createdAt: DateTime
```

```yaml
class: ShelfListResponse
fields:
  shelves: List<ShelfDto>
```

`presentation/shelf/wire_mappers.dart` is `ShelfWireMappers`, a different class from `BookWireMappers`. `ShelfEndpoint.save` and `ShelfEndpoint.list` follow the book endpoint. Register the factories in `app/use_cases.dart` and `app/repositories.dart`.

```bash
serverpod generate
serverpod create-migration
dart test test/unit/domain/shelf_test.dart
```

The domain test covers the trimmed name, a capacity of 0, and a full shelf. The endpoint test for place arrives with the next chapter, in the same `withServerpod` file.

## Flutter, briefly

Repeat the client split. `lib/domain/shelf/shelf.dart` is `@MappableClass()`. `SaveShelfUseCase` validates with `Shelf.create` and then calls the port. `ServerpodShelfRepository` calls `client.shelf.save` and `client.shelf.list`. `ShelvesPage` is a form and a list of `ShelfTile`. `ShelfTile` lives in `ui/` and does not import Riverpod. `ShelvesLocation` reports the screen `/shelves`.

The place dropdowns are not part of this page yet. Add the shelf form and the list, run `dart run build_runner build` if you annotated `Shelf`, and `flutter test`. Then add the control in [the place control](../flutter/place-book.md).

Next: [place a book on a shelf](place-book.md).
