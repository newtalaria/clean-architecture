import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/presentation/features/books/books_page.dart';

import '../fakes/fake_book_repository.dart';
import '../fakes/fake_shelf_repository.dart';

void main() {
  testWidgets('saving a book shows it in the list', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(FakeBookRepository()),
          shelfRepositoryProvider.overrideWithValue(FakeShelfRepository()),
        ],
        child: const MaterialApp(home: BooksPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('book-title')),
      'The Dispossessed',
    );
    await tester.enterText(find.byKey(const Key('book-author')), 'Le Guin');
    await tester.tap(find.byKey(const Key('save-book')));
    await tester.pumpAndSettle();

    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('No books yet'), findsNothing);
  });

  testWidgets('favourite toggles the heart', (tester) async {
    final books = FakeBookRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(books),
          shelfRepositoryProvider.overrideWithValue(FakeShelfRepository()),
        ],
        child: const MaterialApp(home: BooksPage()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('book-title')),
      'The Dispossessed',
    );
    await tester.enterText(find.byKey(const Key('book-author')), 'Le Guin');
    await tester.tap(find.byKey(const Key('save-book')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byKey(const Key('favorite-The Dispossessed')));
    await tester.pumpAndSettle();

    expect(books.books.values.single.favorite, isTrue);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}
