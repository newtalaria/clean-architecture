import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

/// Book wire mapping lives next to the book endpoint, not in a shared file.
class BookWireMappers {
  const BookWireMappers();

  BookDto toDto(Book book) {
    return BookDto(
      id: uuidFromString(book.id),
      title: book.title,
      authorName: book.authorName,
      status: ReadingStatusWire.values.byName(book.status.name),
      shelfId: book.shelfId == null ? null : uuidFromString(book.shelfId!),
      createdAt: book.createdAt,
      favorite: book.favorite,
    );
  }

  ReadingStatus fromStatus(ReadingStatusWire wire) {
    return ReadingStatus.values.byName(wire.name);
  }
}
