import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_notifier.dart';
import 'package:shelf_flutter/ui/shelf_tile.dart';

class ShelvesPage extends ConsumerStatefulWidget {
  const ShelvesPage({super.key});

  @override
  ConsumerState<ShelvesPage> createState() => _ShelvesPageState();
}

class _ShelvesPageState extends ConsumerState<ShelvesPage> {
  final _name = TextEditingController();
  final _capacity = TextEditingController(text: '10');
  String? _error;
  String? _bookId;
  String? _shelfId;

  @override
  void dispose() {
    _name.dispose();
    _capacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shelves = ref.watch(shelvesProvider);
    final books = ref.watch(booksProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ShelfNav(),
            TextField(
              key: const Key('shelf-name'),
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              key: const Key('shelf-capacity'),
              controller: _capacity,
              decoration: const InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
            if (_error != null) Text(_error!),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('save-shelf'),
              onPressed: () async {
                final capacity = int.tryParse(_capacity.text.trim()) ?? 0;
                final message = await ref
                    .read(shelvesProvider.notifier)
                    .save(name: _name.text, capacity: capacity);
                if (!mounted) return;
                setState(() => _error = message);
                if (message == null) _name.clear();
              },
              child: const Text('Save shelf'),
            ),
            const SizedBox(height: 16),
            _PlaceRow(
              books: books.asData?.value ?? const [],
              shelves: shelves.asData?.value ?? const [],
              bookId: _bookId,
              shelfId: _shelfId,
              onBook: (id) => setState(() => _bookId = id),
              onShelf: (id) => setState(() => _shelfId = id),
              onPlace: () async {
                final bookId = _bookId;
                final shelfId = _shelfId;
                if (bookId == null || shelfId == null) return;
                final message = await ref
                    .read(shelvesProvider.notifier)
                    .place(bookId: bookId, shelfId: shelfId);
                if (!mounted) return;
                setState(() => _error = message);
                if (message == null) {
                  ref.invalidate(booksProvider);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: shelves.when(
                data: (items) {
                  if (items.isEmpty) return const Text('No shelves yet');
                  return ListView(
                    children: [
                      for (final shelf in items)
                        ShelfTile(name: shelf.name, capacity: shelf.capacity),
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

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.books,
    required this.shelves,
    required this.bookId,
    required this.shelfId,
    required this.onBook,
    required this.onShelf,
    required this.onPlace,
  });

  final List<Book> books;
  final List<Shelf> shelves;
  final String? bookId;
  final String? shelfId;
  final ValueChanged<String?> onBook;
  final ValueChanged<String?> onShelf;
  final VoidCallback onPlace;

  @override
  Widget build(BuildContext context) {
    final available = books.where((book) => book.shelfId == null).toList();
    return Row(
      children: [
        Expanded(
          child: DropdownButton<String>(
            key: const Key('place-book'),
            isExpanded: true,
            hint: const Text('Book'),
            value: bookId,
            items: [
              for (final book in available)
                DropdownMenuItem(value: book.id, child: Text(book.title)),
            ],
            onChanged: onBook,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<String>(
            key: const Key('place-shelf'),
            isExpanded: true,
            hint: const Text('Shelf'),
            value: shelfId,
            items: [
              for (final shelf in shelves)
                DropdownMenuItem(value: shelf.id, child: Text(shelf.name)),
            ],
            onChanged: onShelf,
          ),
        ),
        const SizedBox(width: 8),
        FilledButton(
          key: const Key('place-book-on-shelf'),
          onPressed: onPlace,
          child: const Text('Place'),
        ),
      ],
    );
  }
}
