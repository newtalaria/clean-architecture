import 'package:shelf_flutter/domain/book/book.dart';

/// What the screen needs stored about books. The data layer talks to Serverpod.
abstract interface class BookRepository {
  Future<Book> save(Book book);

  Future<List<Book>> list();

  /// Calls the server use case that coordinates books and shelves.
  Future<Book> placeOnShelf({required String bookId, required String shelfId});

  Future<Book> setFavorite({required String bookId, required bool favorite});
}
