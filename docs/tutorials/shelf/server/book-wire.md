---
title: Book wire types
description: Spy files for the API, and a wire mapper that lives beside the book endpoint.
tags: [clean-architecture, tutorial, serverpod]
---

The client needs types Serverpod can serialize. Those types are YAML under `presentation/book/`, not under `infra/models/`. They are not `serverOnly`. `serverpod generate` copies them into `shelf_client`.

The mapper that converts them is Dart, in the same folder as the endpoint. It is not a shared `presentation/mappers/wire_mappers.dart`. A shared mapper file is where every feature's fields accumulate. On a large server that file becomes the one everyone edits. A new project starts with the mapper next to the feature.

Create `lib/src/presentation/book/reading_status_wire.spy.yml`:

```yaml
enum: ReadingStatusWire
values:
  - unread
  - reading
  - read
```

The `Wire` suffix is the rule. `ReadingStatus` is the domain enum. `ReadingStatusWire` is the protocol enum. They share names so `.values.byName` can map them. They are not the same type, and the domain file does not import this one.

Create `lib/src/presentation/book/input/save_book_input.spy.yml`:

```yaml
class: SaveBookInput
fields:
  title: String
  authorName: String
  status: ReadingStatusWire
```

Create `lib/src/presentation/book/dto/book_dto.spy.yml`:

```yaml
class: BookDto
fields:
  id: UuidValue
  title: String
  authorName: String
  status: ReadingStatusWire
  shelfId: UuidValue?
  createdAt: DateTime
```

Create `lib/src/presentation/book/dto/book_list_response.spy.yml`:

```yaml
class: BookListResponse
fields:
  books: List<BookDto>
```

Inputs are named `*Input`. Responses that are more than one object are named `*Response`. A single book on the wire is `BookDto`.

Also create the three exception types the endpoint will throw. They live in `presentation/shared/` because every feature maps the same domain failures.

`api_validation_exception.spy.yml`:

```yaml
exception: ApiValidationException
fields:
  message: String
```

`api_not_found_exception.spy.yml` and `api_conflict_exception.spy.yml` are the same shape, with classes `ApiNotFoundException` and `ApiConflictException`.

Generate again:

```bash
serverpod generate
```

The generated classes are what `BookWireMappers` constructs. Create `lib/src/presentation/book/wire_mappers.dart`:

```dart
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

/// Book wire mapping lives next to the book endpoint, not in a shared file.
class BookWireMappers {
  const BookWireMappers();

  BookDto toDto(Book book) {
    return BookDto(
      id: uuidFromString(book.id),
      title: book.title,
      authorName: book.authorName,
      status: ReadingStatusWire.values.byName(book.status.name),
      shelfId: book.shelfId == null ? null : uuidFromString(book.shelfId!),
      createdAt: book.createdAt,
    );
  }

  ReadingStatus fromStatus(ReadingStatusWire wire) {
    return ReadingStatus.values.byName(wire.name);
  }
}
```

`uuid_values.dart` is an infrastructure helper. Presentation importing it is a small leak of a UUID function, not of a repository implementation. If you want the rule stricter, copy the two one-line functions into the presentation folder. Shelf keeps one helper so the string and the `UuidValue` cannot drift.

This mapper does not import `BookRepositoryImpl`.

Next: [the endpoint](book-endpoint.md).
