---
title: Integration test
description: Call the generated book endpoint through withServerpod. A blank title writes no row.
tags: [clean-architecture, tutorial, serverpod]
---

The unit tests never opened a database. This test does. `withServerpod` starts the test server, applies migrations inside a transaction, and rolls the transaction back after each test. You call the endpoint the way the generated client does: `endpoints.book.save(sessionBuilder, input)`.

Create the migration if you have not:

```bash
serverpod create-migration
```

`config/passwords.yaml` is the file Serverpod 4.0.1 wrote when the project was created. Serverpod 4's test tools can use an embedded Postgres, so you do not have to start `docker compose` for `dart test`. You do start it when you want the development server.

Create `test/integration/save_book_test.dart`:

```dart
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the book endpoint', (sessionBuilder, endpoints) {
    test('save persists a book and list returns it', () async {
      final saved = await endpoints.book.save(
        sessionBuilder,
        SaveBookInput(
          title: ' The Dispossessed ',
          authorName: ' Ursula K. Le Guin ',
          status: ReadingStatusWire.unread,
        ),
      );

      expect(saved.title, 'The Dispossessed');
      expect(saved.authorName, 'Ursula K. Le Guin');
      expect(saved.status, ReadingStatusWire.unread);
      expect(saved.shelfId, isNull);

      final listed = await endpoints.book.list(sessionBuilder);
      expect(listed.books, hasLength(1));
      expect(listed.books.single.id, saved.id);
    });

    test('a blank title is a validation exception and writes nothing', () async {
      expect(
        () => endpoints.book.save(
          sessionBuilder,
          SaveBookInput(
            title: ' ',
            authorName: 'Le Guin',
            status: ReadingStatusWire.unread,
          ),
        ),
        throwsA(isA<ApiValidationException>()),
      );
      final listed = await endpoints.book.list(sessionBuilder);
      expect(listed.books, isEmpty);
    });
  });
}
```

The blank title throws `ApiValidationException`, not `ValidationFailure`. The test is outside the domain. `runUseCase` already translated the failure. The list is empty because `Book.create` threw before `save`.

```bash
dart test
```

To run the server and call it from a client, start Postgres and the server:

```bash
docker compose up --build --detach
dart run bin/main.dart --apply-migrations
```

The API is `http://localhost:8280/`. The next part builds the Flutter app against that URL. You can keep the server running.

Next: [the Flutter project](../flutter/project.md).
