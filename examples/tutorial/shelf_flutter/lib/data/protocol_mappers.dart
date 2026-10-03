import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/not_found.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';

/// Protocol types in, domain types out. This file is the wire boundary.
class ProtocolMappers {
  const ProtocolMappers();

  Book toBook(BookDto dto) {
    return Book(
      id: dto.id.toString(),
      title: dto.title,
      authorName: dto.authorName,
      status: ReadingStatus.values.byName(dto.status.name),
      shelfId: dto.shelfId?.toString(),
      createdAt: dto.createdAt,
    );
  }

  SaveBookInput toSaveBookInput(Book book) {
    return SaveBookInput(
      title: book.title,
      authorName: book.authorName,
      status: ReadingStatusWire.values.byName(book.status.name),
    );
  }

  Shelf toShelf(ShelfDto dto) {
    return Shelf(
      id: dto.id.toString(),
      name: dto.name,
      capacity: dto.capacity,
      createdAt: dto.createdAt,
    );
  }

  SaveShelfInput toSaveShelfInput(Shelf shelf) {
    return SaveShelfInput(name: shelf.name, capacity: shelf.capacity);
  }

  Never throwDomain(Object error) {
    if (error is ApiValidationException) {
      throw ValidationFailure(error.message);
    }
    if (error is ApiNotFoundException) {
      throw NotFound(error.message);
    }
    if (error is ApiConflictException) {
      throw Conflict(error.message);
    }
    throw error;
  }
}
