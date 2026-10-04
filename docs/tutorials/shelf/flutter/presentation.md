---
title: Books screen
description: A hand-written AsyncNotifier, a page, a tile with no Riverpod, and a Beamer location.
tags: [clean-architecture, tutorial, flutter]
---

The screen is three files plus a tile. The tile is the part you can reuse without a `ProviderScope`.

## The tile

Create `lib/ui/book_tile.dart`. It imports Flutter only. The status arrives as a `String` so this file does not need the domain enum. The page passes `book.status.name`. The author is its own line. The status is a chip: Unread, Reading, or Read. `bookStatusLabel` maps the wire value.

The tile takes an optional `shelfName` and an optional `onFavorite`. Leave both unset in this chapter. The shelves chapter passes the shelf name on the library row. The favourite chapter passes the heart, and the heart is drawn only when that callback is set.

```dart
import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
///
/// [onFavorite] is null until the favourite chapter wires the heart.
/// [shelfName] is null on a shelf page, where the name is already the title.
class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.title,
    required this.authorName,
    required this.status,
    this.shelfName,
    this.favorite = false,
    this.onFavorite,
  });

  final String title;
  final String authorName;
  final String status;
  final String? shelfName;
  final bool favorite;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 4, 12),
          child: Row(
            children: [
              Container(
                width: 3,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    if (shelfName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        shelfName!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(label: bookStatusLabel(status)),
              if (onFavorite != null)
                IconButton(
                  key: Key('favorite-$title'),
                  tooltip: favorite ? 'Remove favourite' : 'Favourite',
                  visualDensity: VisualDensity.compact,
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodySmall?.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The wire value is `unread`, `reading`, or `read`. The chip reads as a word.
String bookStatusLabel(String status) {
  return switch (status) {
    'reading' => 'Reading',
    'read' => 'Read',
    _ => 'Unread',
  };
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(label, style: theme.textTheme.bodySmall),
      ),
    );
  }
}
```

`test/widget/book_tile_test.dart``test/widget/book_tile_test.dart` pumps the tile inside a `MaterialApp` whose home is a `Scaffold`, so `Theme.of` resolves. The test does not wrap the tile in `ProviderScope`. If that test needs a scope, the tile has started to read a provider. It does not pass `onFavorite`, so the heart is absent.

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
    expect(find.text('Le Guin'), findsOneWidget);
    expect(find.text('Unread'), findsOneWidget);
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

`BooksPage` is a `ConsumerStatefulWidget`. Add book opens a dialog. The dialog keeps the keys `book-title`, `book-author`, and `save-book`. The button that opens it is `add-book`. The list itself is `ref.watch(booksProvider)`.

Empty, loading, and failure are three widgets. An empty library says `No books yet`. A failed load says `Could not load the library.`

Create `lib/ui/shelf_theme.dart`:

```dart
import 'package:flutter/material.dart';

/// Warm paper, ink, and one copper accent. Screens share this theme.
ThemeData shelfTheme() {
  const ink = Color(0xFF141210);
  const paper = Color(0xFFF7F4EF);
  const card = Color(0xFFFFFCF8);
  const line = Color(0xFFE7E0D6);
  const accent = Color(0xFF8C3A2F);
  const muted = Color(0xFF6F655C);

  final scheme = ColorScheme.light(
    primary: accent,
    onPrimary: Colors.white,
    secondary: const Color(0xFF3D5A4C),
    surface: card,
    onSurface: ink,
    error: const Color(0xFF9B2C2C),
    outline: line,
  );

  final outline = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: line),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: paper,
    dividerColor: line,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: line),
      ),
      titleTextStyle: const TextStyle(
        color: ink,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: paper,
      labelStyle: const TextStyle(color: muted),
      border: outline,
      enabledBorder: outline,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accent, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: ink,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
      ),
      titleMedium: TextStyle(
        color: ink,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      bodyMedium: TextStyle(color: ink, fontSize: 14, height: 1.35),
      bodySmall: TextStyle(color: muted, fontSize: 13),
    ),
  );
}
```

`lib/ui/shelf_frame.dart`:`lib/ui/shelf_frame.dart`:

```dart
import 'package:flutter/material.dart';

/// Centers the screen on a reading width. Pages put their column in [child].
class ShelfFrame extends StatelessWidget {
  const ShelfFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Page title, an optional count, and the action that opens a dialog.
class ShelfSectionHeader extends StatelessWidget {
  const ShelfSectionHeader({
    super.key,
    required this.title,
    this.detail,
    this.action,
  });

  final String title;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (detail != null) ...[
                const SizedBox(height: 2),
                Text(detail!, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

/// Empty list copy. [message] is the line the widget tests look for.
class ShelfEmpty extends StatelessWidget {
  const ShelfEmpty({super.key, required this.message, required this.hint});

  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(message, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            hint,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Quiet wait. Pages use this instead of the word "Loading".
class ShelfLoading extends StatelessWidget {
  const ShelfLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// One sentence when a list cannot be loaded.
class ShelfFailure extends StatelessWidget {
  const ShelfFailure({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
```

`lib/presentation/features/books/books_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/ui/book_tile.dart';
import 'package:shelf_flutter/ui/shelf_frame.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  Future<void> _addBook() {
    return showDialog<void>(
      context: context,
      builder: (context) => const _AddBookDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    return ShelfFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShelfNav(section: ShelfSection.books),
          const SizedBox(height: 28),
          ShelfSectionHeader(
            title: 'Library',
            detail: books.asData?.value == null
                ? null
                : _countLabel(books.requireValue.length),
            action: FilledButton(
              key: const Key('add-book'),
              onPressed: _addBook,
              child: const Text('Add book'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _list(books)),
        ],
      ),
    );
  }

  Widget _list(AsyncValue<List<Book>> books) {
    if (books.hasError && !books.hasValue) {
      return const ShelfFailure(message: 'Could not load the library.');
    }
    if (!books.hasValue) return const ShelfLoading();
    final items = books.requireValue;
    if (items.isEmpty) {
      return const ShelfEmpty(
        message: 'No books yet',
        hint: 'Save a title and it will show up here.',
      );
    }
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
  }
}

String _countLabel(int count) => count == 1 ? '1 book' : '$count books';

class _AddBookDialog extends ConsumerStatefulWidget {
  const _AddBookDialog();

  @override
  ConsumerState<_AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends ConsumerState<_AddBookDialog> {
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
    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      title: const Text('Add a book'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('book-title'),
              controller: _title,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const Key('book-author'),
              controller: _author,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(labelText: 'Author'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('save-book'),
          onPressed: () async {
            final message = await ref
                .read(booksProvider.notifier)
                .save(title: _title.text, authorName: _author.text);
            if (!context.mounted) return;
            if (message == null) {
              Navigator.of(context).pop();
            } else {
              setState(() => _error = message);
            }
          },
          child: const Text('Save book'),
        ),
      ],
    );
  }
}
```

`lib/presentation/app/shelf_nav.dart` calls `context.beamToNamed` from the button press. It does not call `Beamer.of` while building, so a widget test can pump the page without a router. Navigation stays in presentation. The tile does not know the routes. Pass `ShelfSection.books` from this page and `ShelfSection.shelves` from the shelves page. The labels are Library and Shelves. The selected label has an underline. Favourites is the favourite chapter.

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

enum ShelfSection { books, shelves }

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

`test/widget/books_page_test.dart` overrides `bookRepositoryProvider` with `FakeBookRepository`, opens Add book, enters a title and an author, taps save, and expects the title on screen. That test does not start Serverpod. `shelfRepositoryProvider` does not exist yet, so this chapter does not override it.

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

    await tester.tap(find.byKey(const Key('add-book')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('book-title')),
      'The Dispossessed',
    );
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
        title: 'Library',
        child: ScreenReporter(
          path: RoutePaths.books,
          title: 'Library',
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
import 'package:shelf_flutter/ui/shelf_theme.dart';

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
      theme: shelfTheme(),
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
