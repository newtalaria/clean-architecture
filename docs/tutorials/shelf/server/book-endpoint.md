---
title: Book endpoint
description: A thin endpoint. Map the input, call one use case, map the book or the failure.
tags: [clean-architecture, tutorial, serverpod]
---

The endpoint is the edge. Each method does three things: map wire input to a command, call one use case, map the result to a wire type. Failures are mapped by `runUseCase`, not by a try/catch copied into every method.

Create `lib/src/presentation/shared/endpoint_support.dart`:

```dart
import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/not_found.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:shelf_server/src/generated/protocol.dart';

/// Maps domain failures to the spy exceptions the client can catch.
Future<T> runUseCase<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on ValidationFailure catch (error) {
    throw ApiValidationException(message: error.message);
  } on NotFound catch (error) {
    throw ApiNotFoundException(message: error.message);
  } on Conflict catch (error) {
    throw ApiConflictException(message: error.message);
  }
}
```

Create `lib/src/presentation/book/book_endpoint.dart`. The class name ends in `Endpoint`. Serverpod strips that suffix, so the client calls `client.book`.

```dart
import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/app/di.dart';
import 'package:shelf_server/src/application/book/save_book_command.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/presentation/book/wire_mappers.dart';
import 'package:shelf_server/src/presentation/shared/endpoint_support.dart';

/// Thin edge. Auth, mapping, one use case, mapping back.
class BookEndpoint extends Endpoint {
  final _useCases = AppDi.instance.useCases;
  final _mappers = const BookWireMappers();

  Future<BookDto> save(Session session, SaveBookInput input) {
    return runUseCase(() async {
      final book = await _useCases
          .saveBook(session)
          .execute(
            SaveBookCommand(
              title: input.title,
              authorName: input.authorName,
              status: _mappers.fromStatus(input.status),
            ),
          );
      return _mappers.toDto(book);
    });
  }

  Future<BookListResponse> list(Session session) {
    return runUseCase(() async {
      final books = await _useCases.listBooks(session).execute();
      return BookListResponse(books: books.map(_mappers.toDto).toList());
    });
  }
}
```

`AppDi` does not exist yet. The next chapter creates it. Do not run `serverpod generate` on this page. The endpoint imports `di.dart`, so the analyzer reports that URI as missing until the composition root exists.

The endpoint holds `UseCases`, not `BookRepositoryImpl`. `Session` is passed into the factory so the repository can be built for this request. It is not passed into `execute`.

Next: [the composition root](composition.md).
