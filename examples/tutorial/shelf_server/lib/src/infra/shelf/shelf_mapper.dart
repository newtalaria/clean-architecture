import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

class ShelfMapper {
  const ShelfMapper();

  Shelf toDomain(StoredShelf row) {
    return Shelf(
      id: uuidToString(row.id!),
      name: row.name,
      capacity: row.capacity,
      createdAt: row.createdAt,
    );
  }

  StoredShelf toRow(Shelf shelf) {
    return StoredShelf(
      id: uuidFromString(shelf.id),
      name: shelf.name,
      capacity: shelf.capacity,
      createdAt: shelf.createdAt,
    );
  }
}
