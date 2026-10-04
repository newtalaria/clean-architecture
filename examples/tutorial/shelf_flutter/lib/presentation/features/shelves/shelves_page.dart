import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/app/shelf_nav.dart';
import 'package:shelf_flutter/presentation/features/books/books_notifier.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_notifier.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';
import 'package:shelf_flutter/ui/shelf_frame.dart';
import 'package:shelf_flutter/ui/shelf_tile.dart';

class ShelvesPage extends ConsumerWidget {
  const ShelvesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shelves = ref.watch(shelvesProvider);
    final books = ref.watch(booksProvider);
    final count = shelves.asData?.value.length;
    return ShelfFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ShelfNav(section: ShelfSection.shelves),
          const SizedBox(height: 28),
          ShelfSectionHeader(
            title: 'Shelves',
            detail: count == null
                ? null
                : (count == 1 ? '1 shelf' : '$count shelves'),
            action: FilledButton(
              key: const Key('new-shelf'),
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => const _NewShelfDialog(),
                );
              },
              child: const Text('New shelf'),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(child: _list(context, shelves, books)),
        ],
      ),
    );
  }

  Widget _list(
    BuildContext context,
    AsyncValue<List<Shelf>> shelves,
    AsyncValue<List<Book>> books,
  ) {
    final failed =
        (shelves.hasError && !shelves.hasValue) ||
        (books.hasError && !books.hasValue);
    if (failed) {
      return const ShelfFailure(message: 'Could not load the shelves.');
    }
    if (!shelves.hasValue || !books.hasValue) return const ShelfLoading();
    final items = shelves.requireValue;
    if (items.isEmpty) {
      return const ShelfEmpty(
        message: 'No shelves yet',
        hint: 'Give a shelf a name and how many books it holds.',
      );
    }
    final library = books.requireValue;
    return ListView(
      children: [
        for (final shelf in items)
          ShelfTile(
            name: shelf.name,
            capacity: shelf.capacity,
            held: _held(library, shelf.id),
            onTap: () => context.beamToNamed(RoutePaths.shelf(shelf.id)),
          ),
      ],
    );
  }
}

class _NewShelfDialog extends ConsumerStatefulWidget {
  const _NewShelfDialog();

  @override
  ConsumerState<_NewShelfDialog> createState() => _NewShelfDialogState();
}

class _NewShelfDialogState extends ConsumerState<_NewShelfDialog> {
  final _name = TextEditingController();
  final _capacity = TextEditingController(text: '10');
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _capacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      scrollable: true,
      title: const Text('New shelf'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('shelf-name'),
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              key: const Key('shelf-capacity'),
              controller: _capacity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capacity'),
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
          key: const Key('save-shelf'),
          onPressed: () async {
            final parsed = int.tryParse(_capacity.text.trim()) ?? 0;
            final message = await ref
                .read(shelvesProvider.notifier)
                .save(name: _name.text, capacity: parsed);
            if (!context.mounted) return;
            if (message == null) {
              Navigator.of(context).pop();
            } else {
              setState(() => _error = message);
            }
          },
          child: const Text('Save shelf'),
        ),
      ],
    );
  }
}

int _held(List<Book> books, String shelfId) {
  var count = 0;
  for (final book in books) {
    if (book.shelfId == shelfId) count++;
  }
  return count;
}
