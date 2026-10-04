import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/presentation/features/favourites/favourites_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('shows only books marked as favourites', (tester) async {
    final books = FakeBookRepository();
    final created = DateTime.utc(2026, 10, 3);
    await books.save(
      Book.create(
        id: 'book-1',
        title: 'The Dispossessed',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ).setFavorite(true),
    );
    await books.save(
      Book.create(
        id: 'book-2',
        title: 'The Left Hand of Darkness',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created.add(const Duration(seconds: 1)),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(FakeShelfRepository()),
        ],
        child: const MaterialApp(home: FavouritesPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('The Left Hand of Darkness'), findsNothing);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
