---
title: Book mapper
description: BookMapper turns a domain book into a StoredBook and back. UuidValue stays in this file.
tags: [clean-architecture, tutorial, serverpod]
---

The domain id is a `String`. The row id is a `UuidValue`. That conversion happens in one helper, then the mapper uses it. The helper is infrastructure. Domain code never imports it.

Create `lib/src/infra/shared/uuid_values.dart`:

```dart
import 'package:serverpod/serverpod.dart';

UuidValue uuidFromString(String id) => UuidValue.fromString(id);

String uuidToString(UuidValue id) => id.toString();
```

Create `lib/src/infra/book/book_mapper.dart`:

```dart
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

/// Maps a domain [Book] to the Postgres row and back.
class BookMapper {
  const BookMapper();

  Book toDomain(StoredBook row) {
    return Book(
      id: uuidToString(row.id!),
      title: row.title,
      authorName: row.authorName,
      status: ReadingStatus.values.byName(row.status),
      shelfId: row.shelfId == null ? null : uuidToString(row.shelfId!),
      createdAt: row.createdAt,
    );
  }

  StoredBook toRow(Book book) {
    return StoredBook(
      id: uuidFromString(book.id),
      title: book.title,
      authorName: book.authorName,
      status: book.status.name,
      shelfId: book.shelfId == null ? null : uuidFromString(book.shelfId!),
      createdAt: book.createdAt,
    );
  }
}
```

`toDomain` calls the generative `Book` constructor, not `Book.create`. The row was checked when it was saved. `row.id!` is safe after an insert or a find: Serverpod returns the persisted id. A row you built yourself for `insertRow` also has an id, because `toRow` set it.

`ReadingStatus.values.byName` is the whole enum mapping. Do not write a switch that can drift from the enum.

This file imports `protocol.dart`. That import is legal in `infra/`. It is not legal in `domain/` or `application/`.

Next: [the repository implementation](book-repository-impl.md).
