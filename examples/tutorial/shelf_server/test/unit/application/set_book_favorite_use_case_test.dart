import 'package:shelf_server/src/application/book/set_book_favorite_use_case.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/not_found.dart';
import 'package:test/test.dart';

import '../../fakes/fake_book_repository.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  test('setFavorite persists the flag and keeps the shelf', () async {
    final books = FakeBookRepository();
    final book = Book.create(
      id: 'b1',
      title: 'The Dispossessed',
      authorName: 'Le Guin',
      status: ReadingStatus.unread,
      createdAt: created,
    ).placeOnShelf('shelf-1');
    await books.save(book);

    final updated = await SetBookFavoriteUseCase(books).execute(
      bookId: 'b1',
      favorite: true,
    );

    expect(updated.favorite, isTrue);
    expect(updated.shelfId, 'shelf-1');
    expect(books.books['b1']!.favorite, isTrue);
  });

  test('a missing book is not found', () {
    expect(
      () => SetBookFavoriteUseCase(FakeBookRepository()).execute(
        bookId: 'missing',
        favorite: true,
      ),
      throwsA(isA<NotFound>()),
    );
  });
}
