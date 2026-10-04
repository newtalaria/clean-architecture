import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_notifier.dart';
import 'package:shelf_flutter/ui/book_tile.dart';
import 'package:shelf_flutter/ui/shelf_frame.dart';

class BooksPage extends ConsumerStatefulWidget {
  const BooksPage({super.key});

  @override
  ConsumerState<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends ConsumerState<BooksPage> {
  String? _error;

  Future<void> _addBook() {
    return showDialog<void>(
      context: context,
      builder: (context) => const _AddBookDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = ref.watch(booksProvider);
    final shelves = ref.watch(shelvesProvider).asData?.value ?? const <Shelf>[];
    final theme = Theme.of(context);
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

String _countLabel(int count) => count == 1 ? '1 book' : '$count books';

String? _shelfName(List<Shelf> shelves, String? shelfId) {
  if (shelfId == null) return null;
  for (final shelf in shelves) {
    if (shelf.id == shelfId) return shelf.name;
  }
  return null;
}

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
