---
title: Providers
description: app/providers.dart is the only file that constructs ServerpodBookRepository.
tags: [clean-architecture, tutorial, flutter]
---

Riverpod providers are the composition root. They are written by hand. There is no `@riverpod` annotation and no `build_runner` step for them. `build_runner` in this app is only for `dart_mappable`.

Create `lib/app/providers.dart`. `clientProvider` throws until `main` overrides it, so a test that forgets the override fails immediately instead of opening a socket:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/application/book/list_books_use_case.dart';
import 'package:shelf_flutter/application/book/save_book_use_case.dart';
import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/data/serverpod_book_repository.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// Overridden in main with the generated client.
final clientProvider = Provider<Client>((ref) {
  throw StateError('Override clientProvider in main');
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return ServerpodBookRepository(ref.watch(clientProvider));
});

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => const UuidIdGenerator(),
);

final saveBookUseCaseProvider = Provider<SaveBookUseCase>((ref) {
  return SaveBookUseCase(
    ref.watch(bookRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final listBooksUseCaseProvider = Provider<ListBooksUseCase>((ref) {
  return ListBooksUseCase(ref.watch(bookRepositoryProvider));
});
```

The provider's type is `BookRepository`, not `ServerpodBookRepository`. A widget test overrides `bookRepositoryProvider` with an in-memory fake and never constructs a `Client`.

Shelf providers (`shelfRepositoryProvider`, `saveShelfUseCaseProvider`, `listShelvesUseCaseProvider`, `placeBookOnShelfUseCaseProvider`) go in this same file when you add those classes. `placeBookOnShelfUseCaseProvider` watches `bookRepositoryProvider`, because the client use case takes the book port. It does not watch a shelf repository. The server is the place that takes both.

Next: [the books screen](presentation.md).
