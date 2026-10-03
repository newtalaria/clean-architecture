---
title: Flutter domain
description: Write Book again. The client cannot import the server domain. Entities use dart_mappable.
tags: [clean-architecture, tutorial, flutter]
---

`Book` on the server is not visible to this package. If the Flutter domain imported `package:shelf_server`, the client would depend on Postgres, `Session`, and the server composition root. You write the entity a second time. The rules are the same: `BookTitle.parse`, a trimmed author, `ReadingStatus`, and `placeOnShelf` throwing `Conflict` when `shelfId` is already set.

Two things change.

The files live in `lib/domain/book/`, not `lib/src/domain/book/`. Imports are `package:shelf_flutter/...`.

`Book` and `ReadingStatus` and `Shelf` carry `dart_mappable` annotations, matching a dashboard that serializes domain values in tests and logs without using the protocol types. The annotation does not make the entity a wire DTO. `BookDto` stays in `data/`.

`reading_status.dart`:

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'reading_status.mapper.dart';

@MappableEnum()
enum ReadingStatus { unread, reading, read }
```

`book.dart` starts with:

```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'book.mapper.dart';

@MappableClass()
class Book with BookMappable {
  const Book({
    required this.id,
    required this.title,
    required this.authorName,
    required this.status,
    required this.createdAt,
    this.shelfId,
  });
  // create, placeOnShelf, and the author check match the server entity.
}
```

Copy `BookTitle`, `ValidationFailure`, `NotFound`, `Conflict`, and `BookRepository` from the server. The client repository adds one method the server port does not have:

```dart
abstract interface class BookRepository {
  Future<Book> save(Book book);
  Future<List<Book>> list();

  /// Calls the server use case that coordinates books and shelves.
  Future<Book> placeOnShelf({required String bookId, required String shelfId});
}
```

That method is on the port because the screen's intent returns a book, and the server already decided the capacity rule. The Flutter use case does not load a shelf and a book and count rows. It calls this method. The data layer sends `PlaceBookInput`. You will see that split again in [Place a book on a shelf](../server/place-book.md) and [the place control](place-book.md).

Generate the mapper parts:

```bash
cd shelf_flutter
dart run build_runner build
```

Commit the generated `*.mapper.dart` files. Do not hand-edit them.

`test/unit/book_test.dart` repeats the trim and the blank-title cases. `flutter test test/unit/book_test.dart` does not need a running server.

Next: [the client use cases](application.md).
