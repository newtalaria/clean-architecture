import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

void main() {
  test('create trims the title', () {
    final book = Book.create(
      id: 'b1',
      title: '  The Dispossessed ',
      authorName: 'Le Guin',
      status: ReadingStatus.unread,
      createdAt: DateTime.utc(2026, 10, 3),
    );
    expect(book.title, 'The Dispossessed');
    expect(book.favorite, isFalse);
    expect(book.setFavorite(true).favorite, isTrue);
  });

  test('a blank title is rejected', () {
    expect(
      () => Book.create(
        id: 'b1',
        title: ' ',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
        createdAt: DateTime.utc(2026, 10, 3),
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });
}
