import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// The screen's name for the server workflow. Capacity is decided on the server.
class PlaceBookOnShelfUseCase {
  const PlaceBookOnShelfUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({required String bookId, required String shelfId}) {
    return _books.placeOnShelf(bookId: bookId, shelfId: shelfId);
  }
}
