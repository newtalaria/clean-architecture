---
title: The place control
description: The place control sits on the open shelf. The page does not re-check capacity.
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

Add the same method to `test/fakes/fake_book_repository.dart`, and import `package:shelf_flutter/domain/shared/not_found.dart`. A missing id is `NotFound`. The widget test places a book that is already in the map.

```dart
import 'package:shelf_flutter/domain/shared/not_found.dart';
```

```dart
  @override
  Future<Book> placeOnShelf({
    required String bookId,
    required String shelfId,
  }) async {
    final book = books[bookId];
    if (book == null) {
      throw const NotFound('Book not found');
    }
    final placed = book.placeOnShelf(shelfId);
    books[bookId] = placed;
    return placed;
  }
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

Replace `lib/presentation/features/shelves/shelf_page.dart`. The shelf is already chosen, so the control is one dropdown of books that are not on a shelf. Keys: `place-book` and `place-book-on-shelf`. A full shelf says `Shelf is full` and hides the control. On success the page invalidates `booksProvider`.

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_notifier.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';
import 'package:shelf_flutter/ui/book_tile.dart';
import 'package:shelf_flutter/ui/shelf_frame.dart';

class ShelfPage extends ConsumerStatefulWidget {
  const ShelfPage({super.key, required this.shelfId});

  final String shelfId;

  @override
  ConsumerState<ShelfPage> createState() => _ShelfPageState();
}

class _ShelfPageState extends ConsumerState<ShelfPage> {
  String? _bookId;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final shelves = ref.watch(shelvesProvider);
    final books = ref.watch(booksProvider);
    return ShelfFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShelfNav(section: ShelfSection.shelves),
          const SizedBox(height: 20),
          Expanded(child: _body(shelves, books)),
        ],
      ),
    );
  }

  Widget _body(AsyncValue<List<Shelf>> shelves, AsyncValue<List<Book>> books) {
    final failed =
        (shelves.hasError && !shelves.hasValue) ||
        (books.hasError && !books.hasValue);
    if (failed) {
      return const ShelfFailure(message: 'Could not load this shelf.');
    }
    if (!shelves.hasValue || !books.hasValue) return const ShelfLoading();

    final shelf = _findShelf(shelves.requireValue, widget.shelfId);
    if (shelf == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _BackHeader(title: 'Shelf'),
          const Expanded(
            child: ShelfEmpty(
              message: 'Shelf not found',
              hint: 'Go back to the list of shelves.',
            ),
          ),
        ],
      );
    }

    final onShelf = [
      for (final book in books.requireValue)
        if (book.shelfId == shelf.id) book,
    ];
    final full = onShelf.length >= shelf.capacity;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackHeader(
          title: shelf.name,
          detail: '${onShelf.length} of ${shelf.capacity} books',
        ),
        const SizedBox(height: 16),
        if (full)
          Text('Shelf is full', style: theme.textTheme.bodyMedium)
        else
          _PlaceBook(
            books: books.requireValue,
            bookId: _bookId,
            error: _error,
            onBook: (id) => setState(() => _bookId = id),
            onPlace: () async {
              final bookId = _bookId;
              if (bookId == null) return;
              final message = await ref
                  .read(shelvesProvider.notifier)
                  .place(bookId: bookId, shelfId: shelf.id);
              if (!mounted) return;
              setState(() {
                _error = message;
                if (message == null) _bookId = null;
              });
              if (message == null) ref.invalidate(booksProvider);
            },
          ),
        const SizedBox(height: 16),
        Expanded(
          child: onShelf.isEmpty
              ? const ShelfEmpty(
                  message: 'Nothing on this shelf yet',
                  hint: 'Place a book that is not on a shelf.',
                )
              : ListView(
                  children: [
                    for (final book in onShelf)
                      BookTile(
                        title: book.title,
                        authorName: book.authorName,
                        status: book.status.name,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _BackHeader extends StatelessWidget {
  const _BackHeader({required this.title, this.detail});

  final String title;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          key: const Key('shelf-back'),
          tooltip: 'Shelves',
          onPressed: () => context.beamToNamed(RoutePaths.shelves),
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (detail != null)
                Text(detail!, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlaceBook extends StatelessWidget {
  const _PlaceBook({
    required this.books,
    required this.bookId,
    required this.error,
    required this.onBook,
    required this.onPlace,
  });

  final List<Book> books;
  final String? bookId;
  final String? error;
  final ValueChanged<String?> onBook;
  final VoidCallback onPlace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final available = [
      for (final book in books)
        if (book.shelfId == null) book,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Place a book', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      key: const Key('place-book'),
                      isExpanded: true,
                      hint: const Text('Book'),
                      value: bookId,
                      items: [
                        for (final book in available)
                          DropdownMenuItem(
                            value: book.id,
                            child: Text(book.title),
                          ),
                      ],
                      onChanged: onBook,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              key: const Key('place-book-on-shelf'),
              onPressed: bookId == null ? null : onPlace,
              child: const Text('Place'),
            ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: TextStyle(color: theme.colorScheme.error)),
        ],
      ],
    );
  }
}

Shelf? _findShelf(List<Shelf> shelves, String id) {
  for (final shelf in shelves) {
    if (shelf.id == id) return shelf;
  }
  return null;
}
```

`test/widget/place_book_test.dart` opens that shelf, selects the book, taps Place, and expects `books.books['book-1']!.shelfId` to be `'shelf-1'`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelf_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('place stores the book on this shelf', (tester) async {
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
        child: const MaterialApp(home: ShelfPage(shelfId: 'shelf-1')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-book')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('The Dispossessed').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-book-on-shelf')));
    await tester.pumpAndSettle();

    expect(books.books['book-1']!.shelfId, 'shelf-1');
  });
}
```

Add this test to `test/widget/shelf_page_test.dart`. A shelf of capacity 1 that already holds a book hides the dropdown.

```dart
testWidgets('a full shelf hides the place control', (tester) async {
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
    ).placeOnShelf('shelf-1'),
  );
  await shelves.save(
    Shelf.create(
      id: 'shelf-1',
      name: 'Fiction',
      capacity: 1,
      createdAt: created,
    ),
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        bookRepositoryProvider.overrideWithValue(books),
        shelfRepositoryProvider.overrideWithValue(shelves),
      ],
      child: const MaterialApp(home: ShelfPage(shelfId: 'shelf-1')),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('Shelf is full'), findsOneWidget);
  expect(find.byKey(const Key('place-book')), findsNothing);
});
```

```bash
flutter test
```

Run the app against the server. Save two books and a shelf of capacity 1. Open the shelf. Place the first book. Place the second. The page shows `Shelf is full`.

Next: [favourite a book](../server/favorite.md).
