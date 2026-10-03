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
