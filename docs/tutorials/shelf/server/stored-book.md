---
title: Stored book
description: The spy file for the Postgres row. serverOnly, an explicit table name, and a shelf id index.
tags: [clean-architecture, tutorial, serverpod]
---

This is the first YAML file. It exists because Serverpod has to generate a table. The class is `StoredBook`, not `Book`. The domain name stays clean. The row is allowed to look like columns.

Create `lib/src/infra/models/stored_book.spy.yaml`:

```yaml
### Persistence row for a book. Not the domain entity.
class: StoredBook
serverOnly: true
table: stored_book
fields:
  id: UuidValue?, defaultPersist=random_v7
  title: String
  authorName: String
  status: String
  shelfId: UuidValue?
  createdAt: DateTime
indexes:
  stored_book_shelf_id_idx:
    fields: shelfId
```

`serverOnly: true` keeps this class out of `shelf_client`. The Flutter app must not import a row type. `table:` is explicit so the name does not drift from the class name.

`status` is a `String`. The domain enum is not a Serverpod type, and a spy enum here would be a persistence enum leaking toward the domain if you mapped by sharing the type. The mapper writes `book.status.name`.

`shelfId` is a nullable UUID with an index, not a Serverpod `relation`. Shelf does not need the ORM to join the shelf row to answer "how many books are on this shelf". `count` with a `where` is the query. A relation is worth adding when you want `onDelete` behavior. This tutorial leaves the book row in place if a shelf is removed, and the use case is the only writer of `shelfId`.

`id` is optional in the YAML because `defaultPersist=random_v7` fills it when a caller forgets. `SaveBookUseCase` does not forget. The mapper always sets `id` from the domain string.

Generate, from `shelf_server`:

```bash
serverpod generate
```

That writes `lib/src/generated/infra/models/stored_book.dart` and updates `protocol.dart`. Do not edit the generated file. If a field is wrong, change the spy file and generate again.

The migration comes after the shelf table exists, so you are not migrating twice in this tutorial. You can create one now if you want the table before the shelf chapter:

```bash
serverpod create-migration
```

Next: [the mapper between Book and StoredBook](book-mapper.md).
