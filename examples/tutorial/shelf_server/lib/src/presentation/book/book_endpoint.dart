import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/app/di.dart';
import 'package:shelf_server/src/application/book/save_book_command.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/presentation/book/wire_mappers.dart';
import 'package:shelf_server/src/presentation/shared/endpoint_support.dart';

/// Thin edge. Auth, mapping, one use case, mapping back.
class BookEndpoint extends Endpoint {
  final _useCases = AppDi.instance.useCases;
  final _mappers = const BookWireMappers();

  Future<BookDto> save(Session session, SaveBookInput input) {
    return runUseCase(() async {
      final book = await _useCases
          .saveBook(session)
          .execute(
            SaveBookCommand(
              title: input.title,
              authorName: input.authorName,
              status: _mappers.fromStatus(input.status),
            ),
          );
      return _mappers.toDto(book);
    });
  }

  Future<BookDto> setFavorite(Session session, SetBookFavoriteInput input) {
    return runUseCase(() async {
      final book = await _useCases
          .setBookFavorite(session)
          .execute(bookId: input.bookId.toString(), favorite: input.favorite);
      return _mappers.toDto(book);
    });
  }

  Future<BookListResponse> list(Session session) {
    return runUseCase(() async {
      final books = await _useCases.listBooks(session).execute();
      return BookListResponse(books: books.map(_mappers.toDto).toList());
    });
  }
}
