import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('place stores the book on the chosen shelf', (tester) async {
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
      ),
    );
    await shelves.save(
      Shelf.create(
        id: 'shelf-1',
        name: 'Fiction',
        capacity: 2,
        createdAt: created,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(shelves),
        ],
        child: const MaterialApp(home: ShelvesPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-book')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('The Dispossessed').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-shelf')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fiction').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('place-book-on-shelf')));
    await tester.pumpAndSettle();

    expect(books.books['book-1']!.shelfId, 'shelf-1');
  });
}
