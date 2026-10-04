---
title: Favourite on Flutter
description: Favourites lists marked books. The heart calls one use case and reloads the list.
tags: [clean-architecture, tutorial, flutter]
---

The client domain is written again. Add the same flag the server domain has, then call the endpoint you just generated.

## Domain

On the Flutter `Book`, add `this.favorite = false` and `final bool favorite`. `placeOnShelf` copies `favorite: favorite`. Add `setFavorite` with the same copy the server uses. `Book.create` still leaves the flag false.

`dart_mappable` reads the constructor. From `shelf_flutter`:

```bash
dart run build_runner build
```

Add `expect(book.favorite, isFalse)` and `expect(book.setFavorite(true).favorite, isTrue)` to the existing create test.

## The port

Add this to `BookRepository`:

```dart
Future<Book> setFavorite({required String bookId, required bool favorite});
```

`ProtocolMappers.toBook` sets `favorite: dto.favorite`.

`ServerpodBookRepository.setFavorite` calls `client.book.setFavorite` with `SetBookFavoriteInput` and maps failures through `throwDomain`, the same way `placeOnShelf` does.

```dart
@override
Future<Book> setFavorite({
  required String bookId,
  required bool favorite,
}) async {
  try {
    final dto = await _client.book.setFavorite(
      SetBookFavoriteInput(
        bookId: UuidValue.fromString(bookId),
        favorite: favorite,
      ),
    );
    return _mappers.toBook(dto);
  } catch (error) {
    _mappers.throwDomain(error);
  }
}
```

`lib/application/book/set_book_favorite_use_case.dart`:

```dart
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// The screen's name for marking a book as a favourite.
class SetBookFavoriteUseCase {
  const SetBookFavoriteUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({required String bookId, required bool favorite}) {
    return _books.setFavorite(bookId: bookId, favorite: favorite);
  }
}
```

In `app/providers.dart`:

```dart
final setBookFavoriteUseCaseProvider = Provider<SetBookFavoriteUseCase>((ref) {
  return SetBookFavoriteUseCase(ref.watch(bookRepositoryProvider));
});
```

`BooksNotifier.setFavorite` calls that use case, replaces `state` with a fresh list, and returns `NotFound.message`. It does not catch `ApiNotFoundException`.

```dart
/// Returns a message when the book does not exist. Otherwise null.
Future<String?> setFavorite({
  required String bookId,
  required bool favorite,
}) async {
  try {
    await ref
        .read(setBookFavoriteUseCaseProvider)
        .execute(bookId: bookId, favorite: favorite);
    state = AsyncData(await ref.read(listBooksUseCaseProvider).execute());
    return null;
  } on NotFound catch (error) {
    return error.message;
  }
}
```

Add `setFavorite` to `test/fakes/fake_book_repository.dart`. The `NotFound` import is already there from `placeOnShelf`. A missing id throws `NotFound`. Otherwise the fake stores `book.setFavorite(favorite)`.

```dart
  @override
  Future<Book> setFavorite({
    required String bookId,
    required bool favorite,
  }) async {
    final book = books[bookId];
    if (book == null) {
      throw const NotFound('Book not found');
    }
    final updated = book.setFavorite(favorite);
    books[bookId] = updated;
    return updated;
  }
```

## The heart

The tile already draws the heart when `onFavorite` is set. On `_BooksPageState`, add `String? _error;`. At the start of `build`, take the theme. After `ShelfSectionHeader`, and before the 16-pixel gap, show the message. `_list` already receives `shelves` from the shelves chapter. Pass the flag and the callback. The key is `favorite-$title`, which the widget test taps.

```dart
    final theme = Theme.of(context);
```

```dart
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
```

Replace the `BookTile` inside `_list`:

```dart
          BookTile(
            title: book.title,
            authorName: book.authorName,
            status: book.status.name,
            shelfName: _shelfName(shelves, book.shelfId),
            favorite: book.favorite,
            onFavorite: () async {
              final message = await ref
                  .read(booksProvider.notifier)
                  .setFavorite(bookId: book.id, favorite: !book.favorite);
              if (!mounted) return;
              setState(() => _error = message);
            },
          ),
```

On `ShelfPage`, the row does not repeat the shelf name. Pass `favorite` and the same callback. The page needs a `String? _error` field if the list-only page did not keep one. The place control already has `_error`. Use that field for the heart as well.

```dart
BookTile(
  title: book.title,
  authorName: book.authorName,
  status: book.status.name,
  favorite: book.favorite,
  onFavorite: () async {
    final message = await ref
        .read(booksProvider.notifier)
        .setFavorite(bookId: book.id, favorite: !book.favorite);
    if (!mounted) return;
    setState(() => _error = message);
  },
),
```

Add this to `test/widget/books_page_test.dart`. It opens Add book, saves a book through the dialog, taps the heart, and expects the fake to hold `favorite: true` and the filled icon on screen. Override `shelfRepositoryProvider` as well. The library watches shelves.

```dart
  testWidgets('favourite toggles the heart', (tester) async {
    final books = FakeBookRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(FakeShelfRepository()),
        ],
        child: const MaterialApp(home: BooksPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-book')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('book-title')),
      'The Dispossessed',
    );
    await tester.enterText(find.byKey(const Key('book-author')), 'Le Guin');
    await tester.tap(find.byKey(const Key('save-book')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byKey(const Key('favorite-The Dispossessed')));
    await tester.pumpAndSettle();

    expect(books.books.values.single.favorite, isTrue);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
```

## Favourites

Add `favourites` to `RoutePaths`.

```dart
static const favourites = '/favourites';
```

Replace `lib/presentation/app/shelf_nav.dart`. The third label is Favourites. A shelf page still highlights Shelves.

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

enum ShelfSection { books, shelves, favourites }

class ShelfNav extends StatelessWidget {
  const ShelfNav({super.key, required this.section});

  final ShelfSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text('Shelf', style: theme.textTheme.titleLarge),
        const Spacer(),
        _NavButton(
          label: 'Library',
          selected: section == ShelfSection.books,
          onPressed: () => context.beamToNamed(RoutePaths.books),
        ),
        _NavButton(
          label: 'Shelves',
          selected: section == ShelfSection.shelves,
          onPressed: () => context.beamToNamed(RoutePaths.shelves),
        ),
        _NavButton(
          label: 'Favourites',
          selected: section == ShelfSection.favourites,
          onPressed: () => context.beamToNamed(RoutePaths.favourites),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(),
        textStyle: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: selected ? 18 : 0,
            color: selected ? theme.colorScheme.onSurface : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
```

`lib/presentation/features/favourites/favourites_page.dart` is the same rows, filtered to `favorite`. Empty copy is `No favourites yet`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_notifier.dart';
import 'package:shelf_flutter/ui/book_tile.dart';
import 'package:shelf_flutter/ui/shelf_frame.dart';

class FavouritesPage extends ConsumerStatefulWidget {
  const FavouritesPage({super.key});

  @override
  ConsumerState<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends ConsumerState<FavouritesPage> {
  String? _error;

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    final shelves = ref.watch(shelvesProvider).asData?.value ?? const <Shelf>[];
    final theme = Theme.of(context);
    final marked = books.asData?.value.where((book) => book.favorite).length;
    return ShelfFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShelfNav(section: ShelfSection.favourites),
          const SizedBox(height: 28),
          ShelfSectionHeader(
            title: 'Favourites',
            detail: marked == null
                ? null
                : (marked == 1 ? '1 book' : '$marked books'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
          ],
          const SizedBox(height: 16),
          Expanded(child: _list(books, shelves)),
        ],
      ),
    );
  }

  Widget _list(AsyncValue<List<Book>> books, List<Shelf> shelves) {
    if (books.hasError && !books.hasValue) {
      return const ShelfFailure(message: 'Could not load favourites.');
    }
    if (!books.hasValue) return const ShelfLoading();
    final items = [
      for (final book in books.requireValue)
        if (book.favorite) book,
    ];
    if (items.isEmpty) {
      return const ShelfEmpty(
        message: 'No favourites yet',
        hint: 'Mark a book from the library.',
      );
    }
    return ListView(
      children: [
        for (final book in items)
          BookTile(
            title: book.title,
            authorName: book.authorName,
            status: book.status.name,
            shelfName: _shelfName(shelves, book.shelfId),
            favorite: book.favorite,
            onFavorite: () async {
              final message = await ref
                  .read(booksProvider.notifier)
                  .setFavorite(bookId: book.id, favorite: !book.favorite);
              if (!mounted) return;
              setState(() => _error = message);
            },
          ),
      ],
    );
  }
}

String? _shelfName(List<Shelf> shelves, String? shelfId) {
  if (shelfId == null) return null;
  for (final shelf in shelves) {
    if (shelf.id == shelfId) return shelf.name;
  }
  return null;
}
```

`lib/presentation/router/favourites_location.dart`:

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/presentation/features/favourites/favourites_page.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class FavouritesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [RoutePaths.favourites];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('favourites'),
        title: 'Favourites',
        child: ScreenReporter(
          path: RoutePaths.favourites,
          title: 'Favourites',
          child: FavouritesPage(),
        ),
      ),
    ];
  }
}
```

In `ShelfApp`, add `FavouritesLocation()` after `ShelvesLocation()`.

`test/widget/favourites_page_test.dart` shows the marked book and hides the other.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/presentation/features/favourites/favourites_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('shows only books marked as favourites', (tester) async {
    final books = FakeBookRepository();
    final created = DateTime.utc(2026, 10, 3);
    await books.save(
      Book.create(
        id: 'book-1',
        title: 'The Dispossessed',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ).setFavorite(true),
    );
    await books.save(
      Book.create(
        id: 'book-2',
        title: 'The Left Hand of Darkness',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created.add(const Duration(seconds: 1)),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(FakeShelfRepository()),
        ],
        child: const MaterialApp(home: FavouritesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('The Left Hand of Darkness'), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
```

```bash
flutter test```bash
flutter test
```

Next: [server instrumentation](../server/talaria.md).
