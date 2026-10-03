---
title: Books screen
description: A hand-written AsyncNotifier, a page, a tile with no Riverpod, and a Beamer location.
tags: [clean-architecture, tutorial, flutter]
---

The screen is three files plus a tile. The tile is the part you can reuse without a `ProviderScope`.

## The tile

Create `lib/ui/book_tile.dart`. It imports Flutter only. The status arrives as a `String` so this file does not need the domain enum. The page passes `book.status.name`.

```dart
class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.title,
    required this.authorName,
    required this.status,
  });

  final String title;
  final String authorName;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('$authorName · $status'),
    );
  }
}
```

`test/widget/book_tile_test.dart` pumps the tile inside a `MaterialApp` and does not wrap it in `ProviderScope`. If that test needs a scope, the tile has started to read a provider.

## The notifier

Create `lib/presentation/features/books/books_notifier.dart`. `BooksNotifier` extends `AsyncNotifier<List<Book>>`. `build` calls `listBooksUseCaseProvider`. `save` calls `saveBookUseCaseProvider`, then replaces `state` with a fresh list. It catches `ValidationFailure` and returns `error.message`. It does not catch `ApiValidationException`. It does not import `data/`.

```dart
final booksProvider = AsyncNotifierProvider<BooksNotifier, List<Book>>(
  BooksNotifier.new,
);
```

## The page

`BooksPage` is a `ConsumerStatefulWidget`. Two `TextEditingController`s hold the form. The save button calls `ref.read(booksProvider.notifier).save(...)`. Local `setState` is enough for the error string under the form. The list itself is `ref.watch(booksProvider)`.

Keys `book-title`, `book-author`, and `save-book` exist so the widget test can find the fields without matching on decoration text.

Empty, loading, and error are the three branches of `books.when`. An empty shelf says `No books yet`.

`test/widget/books_page_test.dart` overrides `bookRepositoryProvider` with `FakeBookRepository`, enters a title and an author, taps save, and expects the title on screen. That test does not start Serverpod.

## The route

Create `lib/presentation/router/route_paths.dart`:

```dart
abstract final class RoutePaths {
  static const books = '/books';
  static const shelves = '/shelves';
}
```

`BooksLocation` is a `BeamLocation` whose `pathPatterns` are `[RoutePaths.books]`. `buildPages` returns one `BeamPage` whose child is a `ScreenReporter` around `BooksPage`. `ScreenReporter` calls `ShelfMonitoring.setScreen` in `initState`. You can leave that call in place now. Until the Talaria chapter, `setScreen` returns immediately when no client exists.

`ShelfApp` builds a `BeamerDelegate` with `initialPath: RoutePaths.books` and `beamLocations: [BooksLocation(), ShelvesLocation()]`. Add `ShelvesLocation` when that page exists. Until then, register only `BooksLocation`.

The `MaterialApp.router` builder wraps the child in `TalariaScreenCapture`. That widget is a no-op until `TalariaFlutter.init` has run.

A small `ShelfNav` in `presentation/app/shelf_nav.dart` calls `context.beamToNamed(RoutePaths.books)` and `context.beamToNamed(RoutePaths.shelves)`. Navigation stays in presentation. The tile does not know the routes.

Next: [run the app](run.md).
