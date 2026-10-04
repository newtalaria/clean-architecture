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

  testWidgets('a full shelf hides the place control', (tester) async {
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
    await shelves.save(
      Shelf.create(
        id: 'shelf-1',
        name: 'Fiction',
        capacity: 1,
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

    expect(find.text('Shelf is full'), findsOneWidget);
    expect(find.byKey(const Key('place-book')), findsNothing);
  });

  testWidgets('an unknown shelf says it was not found', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(FakeBookRepository()),
          shelfRepositoryProvider.overrideWithValue(FakeShelfRepository()),
        ],
        child: const MaterialApp(home: ShelfPage(shelfId: 'missing')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Shelf not found'), findsOneWidget);
  });
}
