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
                        favorite: book.favorite,
                        onFavorite: () async {
                          final message = await ref
                              .read(booksProvider.notifier)
                              .setFavorite(
                                bookId: book.id,
                                favorite: !book.favorite,
                              );
                          if (!mounted) return;
                          setState(() => _error = message);
                        },
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
