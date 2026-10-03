import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/domain/book/value_objects/reading_status.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

/// Maps a domain [Book] to the Postgres row and back.
class BookMapper {
  const BookMapper();

  Book toDomain(StoredBook row) {
    return Book(
      id: uuidToString(row.id!),
      title: row.title,
      authorName: row.authorName,
      status: ReadingStatus.values.byName(row.status),
      shelfId: row.shelfId == null ? null : uuidToString(row.shelfId!),
      createdAt: row.createdAt,
    );
  }

  StoredBook toRow(Book book) {
    return StoredBook(
      id: uuidFromString(book.id),
      title: book.title,
      authorName: book.authorName,
      status: book.status.name,
      shelfId: book.shelfId == null ? null : uuidFromString(book.shelfId!),
      createdAt: book.createdAt,
    );
  }
}
