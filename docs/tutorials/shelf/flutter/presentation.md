---
title: Books screen
description: A hand-written AsyncNotifier, a page, a tile with no Riverpod, and a Beamer location.
tags: [clean-architecture, tutorial, flutter]
---

The screen is three files plus a tile. The tile is the part you can reuse without a `ProviderScope`.

## The tile

Create `lib/ui/book_tile.dart`. It imports Flutter only. The status arrives as a `String` so this file does not need the domain enum. The page passes `book.status.name`.

```dart
import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
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

`test/widget/book_tile_test.dart` pumps the tile inside a `MaterialApp` whose home is a `Scaffold`. `ListTile` throws `No Material widget found` when the home is only the tile. The test does not wrap the tile in `ProviderScope`. If that test needs a scope, the tile has started to read a provider.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/ui/book_tile.dart';

void main() {
  testWidgets('renders without a provider scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BookTile(
            title: 'The Dispossessed',
            authorName: 'Le Guin',
            status: 'unread',
          ),
        ),
      ),
    );
    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('Le Guin · unread'), findsOneWidget);
  });
}
```

## The notifier

Create `lib/presentation/features/books/books_notifier.dart`. `BooksNotifier` extends `AsyncNotifier<List<Book>>`. `build` calls `listBooksUseCaseProvider`. `save` calls `saveBookUseCaseProvider`, then replaces `state` with a fresh list. It catches `ValidationFailure` and returns `error.message`. It does not catch `ApiValidationException`. It does not import `data/`.

`lib/presentation/features/books/books_notifier.dart`:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/application/book/save_book_command.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

class BooksNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() {
    return ref.watch(listBooksUseCaseProvider).execute();
  }

  /// Returns a message when the domain rejects the book. Otherwise null.
  Future<String?> save({
    required String title,
    required String authorName,
  }) async {
    try {
      await ref
          .read(saveBookUseCaseProvider)
          .execute(
            SaveBookCommand(
              title: title,
              authorName: authorName,
              status: ReadingStatus.unread,
            ),
          );
      state = AsyncData(await ref.read(listBooksUseCaseProvider).execute());
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    }
  }
}

final booksProvider = AsyncNotifierProvider<BooksNotifier, List<Book>>(
  BooksNotifier.new,
);
```

## The page

`BooksPage` is a `ConsumerStatefulWidget`. Two `TextEditingController`s hold the form. The save button calls `ref.read(booksProvider.notifier).save(...)`. Local `setState` is enough for the error string under the form. The list itself is `ref.watch(booksProvider)`.

Keys `book-title`, `book-author`, and `save-book` exist so the widget test can find the fields without matching on decoration text.

Empty, loading, and error are the three branches of `books.when`. An empty shelf says `No books yet`.

`lib/presentation/features/books/books_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/ui/book_tile.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  final _title = TextEditingController();
  final _author = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShelfNav(),
            TextField(
              key: const Key('book-title'),
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              key: const Key('book-author'),
              controller: _author,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            if (_error != null) Text(_error!),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('save-book'),
              onPressed: () async {
                final message = await ref
                    .read(booksProvider.notifier)
                    .save(title: _title.text, authorName: _author.text);
                if (!mounted) return;
                setState(() => _error = message);
                if (message == null) {
                  _title.clear();
                  _author.clear();
                }
              },
              child: const Text('Save book'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: books.when(
                data: (items) {
                  if (items.isEmpty) return const Text('No books yet');
                  return ListView(
                    children: [
                      for (final book in items)
                        BookTile(
                          title: book.title,
                          authorName: book.authorName,
                          status: book.status.name,
                        ),
                    ],
                  );
                },
                loading: () => const Text('Loading'),
                error: (error, _) => Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

`lib/presentation/app/shelf_nav.dart` calls `context.beamToNamed`. Navigation stays in presentation. The tile does not know the routes.

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class ShelfNav extends StatelessWidget {
  const ShelfNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => context.beamToNamed(RoutePaths.books),
          child: const Text('Books'),
        ),
        TextButton(
          onPressed: () => context.beamToNamed(RoutePaths.shelves),
          child: const Text('Shelves'),
        ),
      ],
    );
  }
}
```

`test/fakes/fake_book_repository.dart` implements the two methods that exist on `BookRepository` in this chapter. The place-control page adds `placeOnShelf`.

```dart
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

class FakeBookRepository implements BookRepository {
  final books = <String, Book>{};

  @override
  Future<Book> save(Book book) async {
    books[book.id] = book;
    return book;
  }

  @override
  Future<List<Book>> list() async {
    final rows = books.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }
}
```

`test/widget/books_page_test.dart` overrides `bookRepositoryProvider` with `FakeBookRepository`, enters a title and an author, taps save, and expects the title on screen. That test does not start Serverpod. `shelfRepositoryProvider` does not exist yet, so this chapter does not override it.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/presentation/features/books/books_page.dart';

import '../fakes/fake_book_repository.dart';

void main() {
  testWidgets('saving a book shows it in the list', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(FakeBookRepository()),
        ],
        child: const MaterialApp(home: BooksPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('book-title')), 'The Dispossessed');
    await tester.enterText(find.byKey(const Key('book-author')), 'Le Guin');
    await tester.tap(find.byKey(const Key('save-book')));
    await tester.pumpAndSettle();

    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('No books yet'), findsNothing);
  });
}
```

## The route

Create `lib/presentation/router/route_paths.dart`:

```dart
abstract final class RoutePaths {
  static const books = '/books';
  static const shelves = '/shelves';
}
```

`BooksLocation` is a `BeamLocation` whose `pathPatterns` are `[RoutePaths.books]`. `buildPages` returns one `BeamPage` whose child is a `ScreenReporter` around `BooksPage`. `ScreenReporter` calls `ShelfMonitoring.setScreen` in `initState`. Write this stub as `lib/bootstrap/talaria_monitoring.dart`. An empty key must not call `TalariaFlutter.init`. The instrumentation chapter replaces this file.

```dart
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

/// Empty-key path. The instrumentation chapter replaces this file.
/// An empty key must not call TalariaFlutter.init.
class ShelfMonitoring {
  ShelfMonitoring._();

  static const apiKey = String.fromEnvironment('TALARIA_API_KEY');

  static bool shouldInit(String key) => key.trim().isNotEmpty;

  static void setScreen(String path, {String? title}) {}

  static http.Client httpClient() => http.Client();

  static Future<void> bootstrap(Future<void> Function() startApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    return startApp();
  }
}
```

`lib/presentation/router/books_location.dart`:

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/bootstrap/talaria_monitoring.dart';
import 'package:shelf_flutter/presentation/features/books/books_page.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class BooksLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [RoutePaths.books];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('books'),
        title: 'Books',
        child: ScreenReporter(
          path: RoutePaths.books,
          title: 'Books',
          child: BooksPage(),
        ),
      ),
    ];
  }
}

class ScreenReporter extends StatefulWidget {
  const ScreenReporter({
    super.key,
    required this.path,
    required this.child,
    this.title,
  });

  final String path;
  final String? title;
  final Widget child;

  @override
  State<ScreenReporter> createState() => _ScreenReporterState();
}

class _ScreenReporterState extends State<ScreenReporter> {
  @override
  void initState() {
    super.initState();
    ShelfMonitoring.setScreen(widget.path, title: widget.title);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
```

`ShelfApp` builds a `BeamerDelegate` with `initialPath: RoutePaths.books`. `locationBuilder` is `BeamerLocationBuilder(...).call`. Passing the builder instance without `.call` is an implicit call tear-off on Dart 3.13. Add `ShelvesLocation` when that page exists. Until then, the list is only `BooksLocation()`.

`lib/shelf_app.dart`:

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:talaria_flutter/talaria_flutter.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class ShelfApp extends StatefulWidget {
  const ShelfApp({super.key});

  @override
  State<ShelfApp> createState() => _ShelfAppState();
}

class _ShelfAppState extends State<ShelfApp> {
  late final BeamerDelegate _router = BeamerDelegate(
    initialPath: RoutePaths.books,
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [BooksLocation()],
    ).call,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shelf',
      routerDelegate: _router,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: _router),
      builder: (context, child) {
        return TalariaScreenCapture(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
```

The `MaterialApp.router` builder wraps the child in `TalariaScreenCapture`. That widget stays idle until a client exists and screen capture is enabled, so a widget test that pumps `ShelfApp` with an empty `TALARIA_API_KEY` does not leave a timer running.

Next: [run the app](run.md).
