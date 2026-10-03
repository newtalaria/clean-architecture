import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/domain/book/book_repository.dart';
import 'package:shelf_server/src/domain/shelf/shelf_repository.dart';
import 'package:shelf_server/src/infra/book/book_repository_impl.dart';
import 'package:shelf_server/src/infra/shelf/shelf_repository_impl.dart';

/// The only place that constructs repository implementations.
class Repositories {
  const Repositories();

  BookRepository books(Session session) => BookRepositoryImpl(session);

  ShelfRepository shelves(Session session) => ShelfRepositoryImpl(session);
}
