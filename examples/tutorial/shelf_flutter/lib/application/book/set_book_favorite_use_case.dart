import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// The screen's name for marking a book as a favourite.
class SetBookFavoriteUseCase {
  const SetBookFavoriteUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({required String bookId, required bool favorite}) {
    return _books.setFavorite(bookId: bookId, favorite: favorite);
  }
}
