import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/book_title.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:test/test.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  test('create trims the title and the author', () {
    final book = Book.create(
      id: 'b1',
      title: '  The Dispossessed  ',
      authorName: '  Ursula K. Le Guin ',
      status: ReadingStatus.unread,
      createdAt: created,
    );
    expect(book.title, 'The Dispossessed');
    expect(book.authorName, 'Ursula K. Le Guin');
    expect(book.shelfId, isNull);
  });

  test('a blank title is rejected', () {
    expect(
      () => Book.create(
        id: 'b1',
        title: '   ',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: created,
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('a title past the limit is rejected', () {
    expect(
      () => BookTitle.parse('a' * (BookTitle.maxLength + 1)),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('a book can be placed once', () {
    final book = Book.create(
      id: 'b1',
      title: 'The Dispossessed',
      authorName: 'Le Guin',
      status: ReadingStatus.reading,
      createdAt: created,
    );
    final placed = book.placeOnShelf('shelf-1');
    expect(placed.shelfId, 'shelf-1');
    expect(() => placed.placeOnShelf('shelf-2'), throwsA(isA<Conflict>()));
  });
}
