---
title: Composition root
description: app/repositories.dart and app/use_cases.dart are the only files that construct BookRepositoryImpl.
tags: [clean-architecture, tutorial, serverpod]
---

The composition root wires concrete types. It does not validate a title and it does not decide whether a shelf is full.

Create `lib/src/app/repositories.dart`:

```dart
import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/domain/book/book_repository.dart';
import 'package:shelf_server/src/domain/shelf/shelf_repository.dart';
import 'package:shelf_server/src/infra/book/book_repository_impl.dart';
import 'package:shelf_server/src/infra/shelf/shelf_repository_impl.dart';

/// The only place that constructs repository implementations.
class Repositories {
  const Repositories();

  BookRepository books(Session session) => BookRepositoryImpl(session);

  ShelfRepository shelves(Session session) => ShelfRepositoryImpl(session);
}
```

If you are still on the book slice and have not written the shelf classes, leave `shelves` out until that chapter. The finished file has both. The method returns the interface type. Callers in `use_cases.dart` never mention `BookRepositoryImpl`.

Create `lib/src/app/use_cases.dart`. Each method builds one use case for one session:

```dart
SaveBookUseCase saveBook(Session session) {
  return SaveBookUseCase(
    _repositories.books(session),
    clock: const SystemClock(),
    ids: const UuidIdGenerator(),
  );
}

ListBooksUseCase listBooks(Session session) {
  return ListBooksUseCase(_repositories.books(session));
}
```

The shelf factories are the same shape: `saveShelf`, `listShelves`, and later `placeBook`. `placeBook` is the factory that passes two ports:

```dart
PlaceBookOnShelfUseCase placeBook(Session session) {
  return PlaceBookOnShelfUseCase(
    _repositories.shelves(session),
    _repositories.books(session),
  );
}
```

That factory is still wiring. The rule that a shelf can be full lives in the use case, which you write in [Place a book on a shelf](place-book.md).

Create `lib/src/app/di.dart`:

```dart
import 'repositories.dart';
import 'use_cases.dart';

/// Process-wide wiring. Repositories are still built per session inside [UseCases].
class AppDi {
  AppDi._() : useCases = const UseCases(Repositories());

  static final instance = AppDi._();

  final UseCases useCases;
}
```

`AppDi.instance` is a singleton. `BookRepositoryImpl` is not. Every `saveBook(session)` call builds a new repository around that session. An endpoint that wrote `BookRepositoryImpl(session)` would skip this file. Do not do that.

`dart analyze lib` should be clean once the shelf types exist. Until then, keep the shelf lines out and analyze the book slice.

Next: [the integration test](integration.md).
