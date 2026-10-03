import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/data/protocol_mappers.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

class ServerpodBookRepository implements BookRepository {
  ServerpodBookRepository(this._client, {ProtocolMappers? mappers})
    : _mappers = mappers ?? const ProtocolMappers();

  final Client _client;
  final ProtocolMappers _mappers;

  @override
  Future<Book> save(Book book) async {
    try {
      final dto = await _client.book.save(_mappers.toSaveBookInput(book));
      return _mappers.toBook(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }

  @override
  Future<List<Book>> list() async {
    final response = await _client.book.list();
    return response.books.map(_mappers.toBook).toList();
  }

  @override
  Future<Book> placeOnShelf({
    required String bookId,
    required String shelfId,
  }) async {
    try {
      final dto = await _client.shelf.place(
        PlaceBookInput(
          bookId: UuidValue.fromString(bookId),
          shelfId: UuidValue.fromString(shelfId),
        ),
      );
      return _mappers.toBook(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }
}
