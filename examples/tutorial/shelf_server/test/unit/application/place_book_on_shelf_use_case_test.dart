import 'package:shelf_server/src/application/shelf/place_book_on_shelf_use_case.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/not_found.dart';
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:test/test.dart';

import '../../fakes/fake_book_repository.dart';
import '../../fakes/fake_shelf_repository.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  Book book({String? shelfId}) {
    final createdBook = Book.create(
      id: 'book-1',
      title: 'The Dispossessed',
      authorName: 'Le Guin',
      status: ReadingStatus.unread,
      createdAt: created,
    );
    return shelfId == null ? createdBook : createdBook.placeOnShelf(shelfId);
  }

  Shelf shelf({int capacity = 2}) {
    return Shelf.create(
      id: 'shelf-1',
      name: 'Fiction',
      capacity: capacity,
      createdAt: created,
    );
  }

  Future<PlaceBookOnShelfUseCase> useCase({
    Book? existingBook,
    Shelf? existingShelf,
    List<Book> others = const [],
  }) async {
    final books = FakeBookRepository();
    final shelves = FakeShelfRepository();
    if (existingBook != null) await books.save(existingBook);
    for (final other in others) {
      await books.save(other);
    }
    if (existingShelf != null) await shelves.save(existingShelf);
    return PlaceBookOnShelfUseCase(shelves, books);
  }

  test('places a book when the shelf has room', () async {
    final place = await useCase(
      existingBook: book(),
      existingShelf: shelf(),
    );
    final placed = await place.execute(bookId: 'book-1', shelfId: 'shelf-1');
    expect(placed.shelfId, 'shelf-1');
  });

  test('a missing shelf is not found', () async {
    final place = await useCase(existingBook: book());
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<NotFound>()),
    );
  });

  test('a missing book is not found', () async {
    final place = await useCase(existingShelf: shelf());
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<NotFound>()),
    );
  });

  test('a full shelf is a conflict', () async {
    final other = Book.create(
      id: 'book-2',
      title: 'The Left Hand of Darkness',
      authorName: 'Le Guin',
      status: ReadingStatus.read,
      createdAt: created,
    ).placeOnShelf('shelf-1');
    final place = await useCase(
      existingBook: book(),
      existingShelf: shelf(capacity: 1),
      others: [other],
    );
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<Conflict>()),
    );
  });

  test('a book already on a shelf is a conflict', () async {
    final place = await useCase(
      existingBook: book(shelfId: 'shelf-9'),
      existingShelf: shelf(),
    );
    expect(
      () => place.execute(bookId: 'book-1', shelfId: 'shelf-1'),
      throwsA(isA<Conflict>()),
    );
  });
}
