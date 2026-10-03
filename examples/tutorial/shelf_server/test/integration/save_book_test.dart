import 'package:shelf_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the book endpoint', (sessionBuilder, endpoints) {
    test('save persists a book and list returns it', () async {
      final saved = await endpoints.book.save(
        sessionBuilder,
        SaveBookInput(
          title: ' The Dispossessed ',
          authorName: ' Ursula K. Le Guin ',
          status: ReadingStatusWire.unread,
        ),
      );

      expect(saved.title, 'The Dispossessed');
      expect(saved.authorName, 'Ursula K. Le Guin');
      expect(saved.status, ReadingStatusWire.unread);
      expect(saved.shelfId, isNull);

      final listed = await endpoints.book.list(sessionBuilder);
      expect(listed.books, hasLength(1));
      expect(listed.books.single.id, saved.id);
    });

    test('a blank title is a validation exception and writes nothing', () async {
      expect(
        () => endpoints.book.save(
          sessionBuilder,
          SaveBookInput(
            title: ' ',
            authorName: 'Le Guin',
            status: ReadingStatusWire.unread,
          ),
        ),
        throwsA(isA<ApiValidationException>()),
      );
      final listed = await endpoints.book.list(sessionBuilder);
      expect(listed.books, isEmpty);
    });
  });

  withServerpod('Given a shelf and a book', (sessionBuilder, endpoints) {
    test('place puts the book on the shelf', () async {
      final book = await endpoints.book.save(
        sessionBuilder,
        SaveBookInput(
          title: 'The Dispossessed',
          authorName: 'Le Guin',
          status: ReadingStatusWire.reading,
        ),
      );
      final shelf = await endpoints.shelf.save(
        sessionBuilder,
        SaveShelfInput(name: 'Fiction', capacity: 2),
      );

      final placed = await endpoints.shelf.place(
        sessionBuilder,
        PlaceBookInput(bookId: book.id, shelfId: shelf.id),
      );

      expect(placed.shelfId, shelf.id);
    });

    test('a full shelf is a conflict', () async {
      final shelf = await endpoints.shelf.save(
        sessionBuilder,
        SaveShelfInput(name: 'Fiction', capacity: 1),
      );
      final first = await endpoints.book.save(
        sessionBuilder,
        SaveBookInput(
          title: 'The Dispossessed',
          authorName: 'Le Guin',
          status: ReadingStatusWire.unread,
        ),
      );
      final second = await endpoints.book.save(
        sessionBuilder,
        SaveBookInput(
          title: 'The Left Hand of Darkness',
          authorName: 'Le Guin',
          status: ReadingStatusWire.unread,
        ),
      );
      await endpoints.shelf.place(
        sessionBuilder,
        PlaceBookInput(bookId: first.id, shelfId: shelf.id),
      );

      expect(
        () => endpoints.shelf.place(
          sessionBuilder,
          PlaceBookInput(bookId: second.id, shelfId: shelf.id),
        ),
        throwsA(isA<ApiConflictException>()),
      );
    });
  });
}
