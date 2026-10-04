---
title: The place control
description: The Flutter use case calls one repository method. The page does not re-check capacity.
tags: [clean-architecture, tutorial, flutter]
---

The server use case owns the rule. The Flutter use case names the intent and calls the port.

`lib/application/shelf/place_book_on_shelf_use_case.dart`:

```dart
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// The screen's name for the server workflow. Capacity is decided on the server.
class PlaceBookOnShelfUseCase {
  const PlaceBookOnShelfUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({required String bookId, required String shelfId}) {
    return _books.placeOnShelf(bookId: bookId, shelfId: shelfId);
  }
}
```

It takes `BookRepository` only. It does not take `ShelfRepository`. If it counted books on the client, the capacity rule would exist twice, and a full shelf could still be accepted by a stale list.

Add `placeOnShelf` to `BookRepository` now. The shelf endpoint exists, so `client.shelf.place` compiles.

```dart
/// Calls the server use case that coordinates books and shelves.
Future<Book> placeOnShelf({required String bookId, required String shelfId});
```

`ServerpodBookRepository.placeOnShelf` calls `client.shelf.place` and maps `ApiConflictException` to `Conflict` through `throwDomain`. `UuidValue` comes from `package:shelf_client`.

```dart
@override
Future<Book> placeOnShelf({
  required String bookId,
  required String shelfId,
}) async {
  try {
    final dto = await _client.shelf.place(
      PlaceBookInput(
        bookId: UuidValue.fromString(bookId),
        shelfId: UuidValue.fromString(shelfId),
      ),
    );
    return _mappers.toBook(dto);
  } catch (error) {
    _mappers.throwDomain(error);
  }
}
```

Add this provider. It watches `bookRepositoryProvider`.

```dart
final placeBookOnShelfUseCaseProvider = Provider<PlaceBookOnShelfUseCase>((
  ref,
) {
  return PlaceBookOnShelfUseCase(ref.watch(bookRepositoryProvider));
});
```

Add `place` to `ShelvesNotifier`. It catches `ValidationFailure`, `NotFound`, and `Conflict` and returns the message. It does not invent a local `placeOnShelf`.

```dart
Future<String?> place({
  required String bookId,
  required String shelfId,
}) async {
  try {
    await ref
        .read(placeBookOnShelfUseCaseProvider)
        .execute(bookId: bookId, shelfId: shelfId);
    return null;
  } on ValidationFailure catch (error) {
    return error.message;
  } on NotFound catch (error) {
    return error.message;
  } on Conflict catch (error) {
    return error.message;
  }
}
```

On `ShelvesPage`, add `String? _bookId` and `String? _shelfId`, watch `booksProvider`, and insert `_PlaceRow` between the save button and the list. On success the page invalidates `booksProvider` so the next list comes from the server, with the new `shelfId`.

```dart
const SizedBox(height: 16),
_PlaceRow(
  books: books.asData?.value ?? const [],
  shelves: shelves.asData?.value ?? const [],
  bookId: _bookId,
  shelfId: _shelfId,
  onBook: (id) => setState(() => _bookId = id),
  onShelf: (id) => setState(() => _shelfId = id),
  onPlace: () async {
    final bookId = _bookId;
    final shelfId = _shelfId;
    if (bookId == null || shelfId == null) return;
    final message = await ref
        .read(shelvesProvider.notifier)
        .place(bookId: bookId, shelfId: shelfId);
    if (!mounted) return;
    setState(() => _error = message);
    if (message == null) {
      ref.invalidate(booksProvider);
    }
  },
),
```

`_PlaceRow` lists books whose `shelfId` is null and every shelf. Keys: `place-book`, `place-shelf`, `place-book-on-shelf`.

```dart
class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.books,
    required this.shelves,
    required this.bookId,
    required this.shelfId,
    required this.onBook,
    required this.onShelf,
    required this.onPlace,
  });

  final List<Book> books;
  final List<Shelf> shelves;
  final String? bookId;
  final String? shelfId;
  final ValueChanged<String?> onBook;
  final ValueChanged<String?> onShelf;
  final VoidCallback onPlace;

  @override
  Widget build(BuildContext context) {
    final available = books.where((book) => book.shelfId == null).toList();
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            key: const Key('place-book'),
            isExpanded: true,
            hint: const Text('Book'),
            value: bookId,
            items: [
              for (final book in available)
                DropdownMenuItem(value: book.id, child: Text(book.title)),
            ],
            onChanged: onBook,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<String>(
            key: const Key('place-shelf'),
            isExpanded: true,
            hint: const Text('Shelf'),
            value: shelfId,
            items: [
              for (final shelf in shelves)
                DropdownMenuItem(value: shelf.id, child: Text(shelf.name)),
            ],
            onChanged: onShelf,
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          key: const Key('place-book-on-shelf'),
          onPressed: onPlace,
          child: const Text('Place'),
        ),
      ],
    );
  }
}
```

Add `placeOnShelf` to `FakeBookRepository`. It applies `Book.placeOnShelf` in memory.

```dart
@override
Future<Book> placeOnShelf({
  required String bookId,
  required String shelfId,
}) async {
  final book = books[bookId];
  if (book == null) {
    throw StateError('missing book');
  }
  final placed = book.placeOnShelf(shelfId);
  books[bookId] = placed;
  return placed;
}
```

`test/widget/place_book_test.dart` overrides both repository providers with fakes, saves one book and one shelf into the fakes before `pumpWidget`, selects them, taps Place, and expects `books.books['book-1']!.shelfId` to be `'shelf-1'`. That test proves the control calls the use case. The full-shelf rule stays covered by the server unit test and the endpoint test.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('place stores the book on the chosen shelf', (tester) async {
    final books = FakeBookRepository();
    final shelves = FakeShelfRepository();
    final created = DateTime.utc(2026, 10, 3);
    await books.save(
      Book.create(
        id: 'book-1',
        title: 'The Dispossessed',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ),
    );
    await shelves.save(
      Shelf.create(
        id: 'shelf-1',
        name: 'Fiction',
        capacity: 2,
        createdAt: created,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(shelves),
        ],
        child: const MaterialApp(home: ShelvesPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-book')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('The Dispossessed').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-shelf')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fiction').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-book-on-shelf')));
    await tester.pumpAndSettle();

    expect(books.books['book-1']!.shelfId, 'shelf-1');
  });
}
```

```bash
flutter test
```

Run the app against the server. Save two books and a shelf of capacity 1. Place the first book. Place the second. The page shows `Shelf is full`.

Next: [server instrumentation](../server/talaria.md).
