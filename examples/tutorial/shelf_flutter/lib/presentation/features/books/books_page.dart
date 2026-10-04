import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final theme = Theme.of(context);
    return ShelfFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShelfNav(section: ShelfSection.books),
          const SizedBox(height: 20),
          ShelfPanel(
            title: 'Add a book',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Library', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          Expanded(
            child: books.when(
              data: (items) {
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
                );
              },
              loading: () => const Text('Loading'),
              error: (error, _) => Text(error.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
