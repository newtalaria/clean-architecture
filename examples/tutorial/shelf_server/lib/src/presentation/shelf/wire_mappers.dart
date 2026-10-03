import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

class ShelfWireMappers {
  const ShelfWireMappers();

  ShelfDto toDto(Shelf shelf) {
    return ShelfDto(
      id: uuidFromString(shelf.id),
      name: shelf.name,
      capacity: shelf.capacity,
      createdAt: shelf.createdAt,
    );
  }
}
