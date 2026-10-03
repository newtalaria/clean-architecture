import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/app/di.dart';
import 'package:shelf_server/src/application/shelf/save_shelf_command.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/presentation/book/wire_mappers.dart';
import 'package:shelf_server/src/presentation/shared/endpoint_support.dart';
import 'package:shelf_server/src/presentation/shelf/wire_mappers.dart';

class ShelfEndpoint extends Endpoint {
  final _useCases = AppDi.instance.useCases;
  final _mappers = const ShelfWireMappers();
  final _books = const BookWireMappers();

  Future<ShelfDto> save(Session session, SaveShelfInput input) {
    return runUseCase(() async {
      final shelf = await _useCases
          .saveShelf(session)
          .execute(
            SaveShelfCommand(name: input.name, capacity: input.capacity),
          );
      return _mappers.toDto(shelf);
    });
  }

  Future<ShelfListResponse> list(Session session) {
    return runUseCase(() async {
      final shelves = await _useCases.listShelves(session).execute();
      return ShelfListResponse(shelves: shelves.map(_mappers.toDto).toList());
    });
  }

  /// Returns the book wire type. The shelf feature borrows the book mapper.
  Future<BookDto> place(Session session, PlaceBookInput input) {
    return runUseCase(() async {
      final book = await _useCases
          .placeBook(session)
          .execute(
            bookId: input.bookId.toString(),
            shelfId: input.shelfId.toString(),
          );
      return _books.toDto(book);
    });
  }
}
