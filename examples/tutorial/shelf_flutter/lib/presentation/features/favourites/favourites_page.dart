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
