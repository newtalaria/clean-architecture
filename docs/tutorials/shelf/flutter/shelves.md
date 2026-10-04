---
title: Shelves on Flutter
description: A shelf list you can open. The place control is the next chapter.
tags: [clean-architecture, tutorial, flutter]
---

The shelf screen follows the book screen. This page adds a capacity field and a tile. Leave the place row out until the server use case exists. A button that calls `client.shelf.place` from the page would skip the use case provider.

`ShelvesNotifier.save` parses nothing itself. The page parses the capacity field with `int.tryParse` and passes `0` when the text is not a number. `Shelf.create` rejects `0`, the use case throws `ValidationFailure`, and the notifier returns `Capacity must be from 1 to 500`. Parsing in the page is presentation. The legal range is the entity.

## Domain

`lib/domain/shelf/shelf_name.dart`:

```dart
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

class ShelfName {
  const ShelfName._(this.value);

  final String value;

  static const maxLength = 80;

  static ShelfName parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Name is required');
    }
    if (trimmed.length > maxLength) {
      throw const ValidationFailure('Name is too long');
    }
    return ShelfName._(trimmed);
  }
}
```

`lib/domain/shelf/shelf.dart`:

```dart
import 'package:dart_mappable/dart_mappable.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf_name.dart';

part 'shelf.mapper.dart';

@MappableClass()
class Shelf with ShelfMappable {
  const Shelf({
    required this.id,
    required this.name,
    required this.capacity,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int capacity;
  final DateTime createdAt;

  static const maxCapacity = 500;

  factory Shelf.create({
    required String id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) {
    if (capacity < 1 || capacity > maxCapacity) {
      throw const ValidationFailure('Capacity must be from 1 to 500');
    }
    return Shelf(
      id: id,
      name: ShelfName.parse(name).value,
      capacity: capacity,
      createdAt: createdAt.toUtc(),
    );
  }

  void ensureRoomForAnother(int booksAlreadyOnShelf) {
    if (booksAlreadyOnShelf >= capacity) {
      throw const Conflict('Shelf is full');
    }
  }
}
```

`lib/domain/shelf/shelf_repository.dart`:

```dart
import 'package:shelf_flutter/domain/shelf/shelf.dart';

abstract interface class ShelfRepository {
  Future<Shelf> save(Shelf shelf);

  Future<List<Shelf>> list();
}
```

Generate the mapper part:

```bash
dart run build_runner build
```

## Application

`lib/application/shelf/save_shelf_command.dart`:

```dart
class SaveShelfCommand {
  const SaveShelfCommand({required this.name, required this.capacity});

  final String name;
  final int capacity;
}
```

`lib/application/shelf/save_shelf_use_case.dart`:

```dart
import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_command.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class SaveShelfUseCase {
  const SaveShelfUseCase(
    this._shelves, {
    required this.clock,
    required this.ids,
  });

  final ShelfRepository _shelves;
  final Clock clock;
  final IdGenerator ids;

  Future<Shelf> execute(SaveShelfCommand command) {
    final draft = Shelf.create(
      id: ids.newId(),
      name: command.name,
      capacity: command.capacity,
      createdAt: clock.now(),
    );
    return _shelves.save(draft);
  }
}
```

`lib/application/shelf/list_shelves_use_case.dart`:

```dart
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class ListShelvesUseCase {
  const ListShelvesUseCase(this._shelves);

  final ShelfRepository _shelves;

  Future<List<Shelf>> execute() => _shelves.list();
}
```

Do not add `PlaceBookOnShelfUseCase` in this chapter. That class is the place-control page.

## Data

Add these two methods to `ProtocolMappers`:

```dart
Shelf toShelf(ShelfDto dto) {
  return Shelf(
    id: dto.id.toString(),
    name: dto.name,
    capacity: dto.capacity,
    createdAt: dto.createdAt,
  );
}

SaveShelfInput toSaveShelfInput(Shelf shelf) {
  return SaveShelfInput(name: shelf.name, capacity: shelf.capacity);
}
```

`lib/data/serverpod_shelf_repository.dart`:

```dart
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/data/protocol_mappers.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class ServerpodShelfRepository implements ShelfRepository {
  ServerpodShelfRepository(this._client, {ProtocolMappers? mappers})
    : _mappers = mappers ?? const ProtocolMappers();

  final Client _client;
  final ProtocolMappers _mappers;

  @override
  Future<Shelf> save(Shelf shelf) async {
    try {
      final dto = await _client.shelf.save(_mappers.toSaveShelfInput(shelf));
      return _mappers.toShelf(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }

  @override
  Future<List<Shelf>> list() async {
    final response = await _client.shelf.list();
    return response.shelves.map(_mappers.toShelf).toList();
  }
}
```

## Providers

Add these to `lib/app/providers.dart`. `placeBookOnShelfUseCaseProvider` waits for the next chapter.

```dart
final shelfRepositoryProvider = Provider<ShelfRepository>((ref) {
  return ServerpodShelfRepository(ref.watch(clientProvider));
});

final saveShelfUseCaseProvider = Provider<SaveShelfUseCase>((ref) {
  return SaveShelfUseCase(
    ref.watch(shelfRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final listShelvesUseCaseProvider = Provider<ListShelvesUseCase>((ref) {
  return ListShelvesUseCase(ref.watch(shelfRepositoryProvider));
});
```

## Presentation

`lib/ui/shelf_tile.dart` is a button. The subtitle is how many books it holds, `0 of 10` when it is empty. `onTap` is optional so the tile test can pump the tile alone. The chevron and the bar are decoration. This file does not import Riverpod.

```dart
import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
class ShelfTile extends StatelessWidget {
  const ShelfTile({
    super.key,
    required this.name,
    required this.capacity,
    required this.held,
    this.onTap,
  });

  final String name;
  final int capacity;
  final int held;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fraction = capacity <= 0 ? 0.0 : (held / capacity).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: theme.colorScheme.outline),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.bookmarks_outlined,
                  size: 20,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        '$held of $capacity',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      _OccupancyBar(fraction: fraction),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OccupancyBar extends StatelessWidget {
  const _OccupancyBar({required this.fraction});

  final double fraction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 3,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: theme.colorScheme.outline),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: ColoredBox(color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
```

`test/widget/shelf_tile_test.dart` pumps the tile inside a `MaterialApp` whose home is a `Scaffold`. It does not wrap the tile in `ProviderScope`.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/ui/shelf_tile.dart';

void main() {
  testWidgets('renders without a provider scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ShelfTile(name: 'Fiction', capacity: 10, held: 0)),
      ),
    );
    expect(find.text('Fiction'), findsOneWidget);
    expect(find.text('0 of 10'), findsOneWidget);
  });
}
```

`lib/presentation/features/shelves/shelves_notifier.dart` has `save` only. The place method is the next chapter.

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_command.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';

class ShelvesNotifier extends AsyncNotifier<List<Shelf>> {
  @override
  Future<List<Shelf>> build() {
    return ref.watch(listShelvesUseCaseProvider).execute();
  }

  Future<String?> save({required String name, required int capacity}) async {
    try {
      await ref
          .read(saveShelfUseCaseProvider)
          .execute(SaveShelfCommand(name: name, capacity: capacity));
      state = AsyncData(await ref.read(listShelvesUseCaseProvider).execute());
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    }
  }
}

final shelvesProvider = AsyncNotifierProvider<ShelvesNotifier, List<Shelf>>(
  ShelvesNotifier.new,
);
```

`lib/presentation/features/shelves/shelves_page.dart` is the list. New shelf is a dialog. Keys `shelf-name`, `shelf-capacity`, and `save-shelf` stay on the dialog. The button that opens it is `new-shelf`. A tile calls `context.beamToNamed(RoutePaths.shelf(shelf.id))`. This page does not place a book.

```dart
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
```

Add these two members to `RoutePaths`:

```dart
static const shelfPattern = '/shelves/:shelfId';

static String shelf(String id) => '/shelves/$id';
```

`lib/presentation/features/shelves/shelf_page.dart` lists the books whose `shelfId` matches. It does not place a book. An unknown id says `Shelf not found`.

```dart
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

class ShelfPage extends ConsumerWidget {
  const ShelfPage({super.key, required this.shelfId});

  final String shelfId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final shelf = _findShelf(shelves.requireValue, shelfId);
    if (shelf == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _BackHeader(title: 'Shelf'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _BackHeader(
          title: shelf.name,
          detail: '${onShelf.length} of ${shelf.capacity} books',
        ),
        const SizedBox(height: 16),
        Expanded(
          child: onShelf.isEmpty
              ? const ShelfEmpty(
                  message: 'Nothing on this shelf yet',
                  hint: 'Placing a book is the next chapter.',
                )
              : ListView(
                  children: [
                    for (final book in onShelf)
                      BookTile(
                        title: book.title,
                        authorName: book.authorName,
                        status: book.status.name,
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

Shelf? _findShelf(List<Shelf> shelves, String id) {
  for (final shelf in shelves) {
    if (shelf.id == id) return shelf;
  }
  return null;
}
```

On `BooksPage`, watch the shelf list and pass the shelf name into the tile. `shelvesProvider` can still be loading. A missing name leaves the line off the row.

```dart
final shelves = ref.watch(shelvesProvider).asData?.value ?? const <Shelf>[];
```

```dart
BookTile(
  title: book.title,
  authorName: book.authorName,
  status: book.status.name,
  shelfName: _shelfName(shelves, book.shelfId),
)
```

```dart
String? _shelfName(List<Shelf> shelves, String? shelfId) {
  if (shelfId == null) return null;
  for (final shelf in shelves) {
    if (shelf.id == shelfId) return shelf.name;
  }
  return null;
}
```

Add the shelf and shelves-notifier imports. In `test/widget/books_page_test.dart`, override `shelfRepositoryProvider` with `FakeShelfRepository()` next to the book repository. The page watches shelves now, and the test still does not start Serverpod.

`lib/presentation/router/shelves_location.dart` stacks the shelf page when the path has a `shelfId`.

```dart
import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelf_page.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_page.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class ShelvesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
    RoutePaths.shelfPattern,
    RoutePaths.shelves,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[
      const BeamPage(
        key: ValueKey('shelves'),
        title: 'Shelves',
        child: ScreenReporter(
          path: RoutePaths.shelves,
          title: 'Shelves',
          child: ShelvesPage(),
        ),
      ),
    ];
    final id = state.pathParameters['shelfId'];
    if (id != null) {
      pages.add(
        BeamPage(
          key: ValueKey('shelf-$id'),
          title: 'Shelf',
          child: ScreenReporter(
            path: RoutePaths.shelf(id),
            title: 'Shelf',
            child: ShelfPage(shelfId: id),
          ),
        ),
      );
    }
    return pages;
  }
}
```

`test/widget/shelf_page_test.dart` pumps `ShelfPage` with one book on the shelf and one that is not. Only the book on the shelf is on screen.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelf_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('shows only the books on this shelf', (tester) async {
    final books = FakeBookRepository();
    final shelves = FakeShelfRepository();
    final created = DateTime.utc(2026, 10, 3);
    await books.save(
      Book.create(
        id: 'book-1',
        title: 'The Dispossessed',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ).placeOnShelf('shelf-1'),
    );
    await books.save(
      Book.create(
        id: 'book-2',
        title: 'The Left Hand of Darkness',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ),
    );
    await shelves.save(
      Shelf.create(
        id: 'shelf-1',
        name: 'Fiction',
        capacity: 10,
        createdAt: created,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(shelves),
        ],
        child: const MaterialApp(home: ShelfPage(shelfId: 'shelf-1')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('The Left Hand of Darkness'), findsNothing);
    expect(find.text('1 of 10 books'), findsOneWidget);
  });
}
```

In `ShelfApp`, add `ShelvesLocation()` to `beamLocations` next to `BooksLocation()`.

`test/fakes/fake_shelf_repository.dart`:

```dart
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class FakeShelfRepository implements ShelfRepository {
  final shelves = <String, Shelf>{};

  @override
  Future<Shelf> save(Shelf shelf) async {
    shelves[shelf.id] = shelf;
    return shelf;
  }

  @override
  Future<List<Shelf>> list() async => shelves.values.toList();
}
```

```bash
flutter test
```

Next: [place a book on a shelf](../server/place-book.md).
