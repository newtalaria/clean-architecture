import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/application/book/list_books_use_case.dart';
import 'package:shelf_server/src/application/book/save_book_use_case.dart';
import 'package:shelf_server/src/application/ports/clock.dart';
import 'package:shelf_server/src/application/ports/id_generator.dart';
import 'package:shelf_server/src/application/shelf/list_shelves_use_case.dart';
import 'package:shelf_server/src/application/shelf/place_book_on_shelf_use_case.dart';
import 'package:shelf_server/src/application/shelf/save_shelf_use_case.dart';

import 'repositories.dart';

/// Factories only. The use case classes stay under application/.
class UseCases {
  const UseCases(this._repositories);

  final Repositories _repositories;

  SaveBookUseCase saveBook(Session session) {
    return SaveBookUseCase(
      _repositories.books(session),
      clock: const SystemClock(),
      ids: const UuidIdGenerator(),
    );
  }

  ListBooksUseCase listBooks(Session session) {
    return ListBooksUseCase(_repositories.books(session));
  }

  SaveShelfUseCase saveShelf(Session session) {
    return SaveShelfUseCase(
      _repositories.shelves(session),
      clock: const SystemClock(),
      ids: const UuidIdGenerator(),
    );
  }

  ListShelvesUseCase listShelves(Session session) {
    return ListShelvesUseCase(_repositories.shelves(session));
  }

  PlaceBookOnShelfUseCase placeBook(Session session) {
    return PlaceBookOnShelfUseCase(
      _repositories.shelves(session),
      _repositories.books(session),
    );
  }
}
