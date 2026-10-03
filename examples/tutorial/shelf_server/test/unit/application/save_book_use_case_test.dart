import 'package:shelf_server/src/application/book/save_book_command.dart';
import 'package:shelf_server/src/application/book/save_book_use_case.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:test/test.dart';

import '../../fakes/fake_book_repository.dart';

void main() {
  test('saves a book with the injected clock and id', () async {
    final books = FakeBookRepository();
    final ids = SequenceIds();
    final useCase = SaveBookUseCase(
      books,
      clock: FixedClock(DateTime.utc(2026, 10, 3, 12)),
      ids: ids,
    );

    final saved = await useCase.execute(
      const SaveBookCommand(
        title: ' The Dispossessed ',
        authorName: 'Le Guin',
        status: ReadingStatus.unread,
      ),
    );

    expect(saved.id, '00000000-0000-4000-8000-000000000001');
    expect(saved.title, 'The Dispossessed');
    expect(saved.createdAt, DateTime.utc(2026, 10, 3, 12));
    expect(books.books, hasLength(1));
  });

  test('a blank title does not write', () async {
    final books = FakeBookRepository();
    final useCase = SaveBookUseCase(
      books,
      clock: FixedClock(DateTime.utc(2026, 10, 3)),
      ids: SequenceIds(),
    );

    expect(
      () => useCase.execute(
        const SaveBookCommand(
          title: ' ',
          authorName: 'Le Guin',
          status: ReadingStatus.unread,
        ),
      ),
      throwsA(isA<ValidationFailure>()),
    );
    expect(books.books, isEmpty);
  });
}
