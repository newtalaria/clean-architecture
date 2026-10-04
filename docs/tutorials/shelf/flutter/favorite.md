---
title: Favourite on Flutter
description: The heart is a callback on the tile. The page calls one use case and reloads the list.
tags: [clean-architecture, tutorial, flutter]
---

The client domain is written again. Add the same flag the server domain has, then call the endpoint you just generated.

## Domain

On the Flutter `Book`, add `this.favorite = false` and `final bool favorite`. `placeOnShelf` copies `favorite: favorite`. Add `setFavorite` with the same copy the server uses. `Book.create` still leaves the flag false.

`dart_mappable` reads the constructor. From `shelf_flutter`:

```bash
dart run build_runner build
```

Add `expect(book.favorite, isFalse)` and `expect(book.setFavorite(true).favorite, isTrue)` to the existing create test.

## The port

Add this to `BookRepository`:

```dart
Future<Book> setFavorite({required String bookId, required bool favorite});
```

`ProtocolMappers.toBook` sets `favorite: dto.favorite`.

`ServerpodBookRepository.setFavorite` calls `client.book.setFavorite` with `SetBookFavoriteInput` and maps failures through `throwDomain`, the same way `placeOnShelf` does.

```dart
@override
Future<Book> setFavorite({
  required String bookId,
  required bool favorite,
}) async {
  try {
    final dto = await _client.book.setFavorite(
      SetBookFavoriteInput(
        bookId: UuidValue.fromString(bookId),
        favorite: favorite,
      ),
    );
    return _mappers.toBook(dto);
  } catch (error) {
    _mappers.throwDomain(error);
  }
}
```

`lib/application/book/set_book_favorite_use_case.dart`:

```dart
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// The screen's name for marking a book as a favourite.
class SetBookFavoriteUseCase {
  const SetBookFavoriteUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({required String bookId, required bool favorite}) {
    return _books.setFavorite(bookId: bookId, favorite: favorite);
  }
}
```

In `app/providers.dart`:

```dart
final setBookFavoriteUseCaseProvider = Provider<SetBookFavoriteUseCase>((ref) {
  return SetBookFavoriteUseCase(ref.watch(bookRepositoryProvider));
});
```

`BooksNotifier.setFavorite` calls that use case, replaces `state` with a fresh list, and returns `NotFound.message`. It does not catch `ApiNotFoundException`.

```dart
/// Returns a message when the book does not exist. Otherwise null.
Future<String?> setFavorite({
  required String bookId,
  required bool favorite,
}) async {
  try {
    await ref
        .read(setBookFavoriteUseCaseProvider)
        .execute(bookId: bookId, favorite: favorite);
    state = AsyncData(await ref.read(listBooksUseCaseProvider).execute());
    return null;
  } on NotFound catch (error) {
    return error.message;
  }
}
```

`FakeBookRepository.setFavorite` throws `NotFound` when the id is missing. Otherwise it stores `book.setFavorite(favorite)`.

## The heart

The tile already draws the heart when `onFavorite` is set. On `BooksPage`, pass the flag and the callback. The key is `favorite-$title`, which the widget test taps.

```dart
BookTile(
  title: book.title,
  authorName: book.authorName,
  status: book.status.name,
  favorite: book.favorite,
  onFavorite: () async {
    final message = await ref
        .read(booksProvider.notifier)
        .setFavorite(bookId: book.id, favorite: !book.favorite);
    if (!mounted) return;
    setState(() => _error = message);
  },
),
```

Add this to `test/widget/books_page_test.dart`. It saves a book through the form, taps the heart, and expects the fake to hold `favorite: true` and the filled icon on screen.

```dart
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
```

```bash
flutter test
```

Next: [server instrumentation](../server/talaria.md).
