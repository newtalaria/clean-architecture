import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';
import '../../domain/shared/exceptions/not_found.dart';

/// Marks a book as a favourite or clears the flag. The shelf is unchanged.
class SetBookFavoriteUseCase {
  const SetBookFavoriteUseCase(this._books);

  final BookRepository _books;

  Future<Book> execute({
    required String bookId,
    required bool favorite,
  }) async {
    final book = await _books.findById(bookId);
    if (book == null) {
      throw const NotFound('Book not found');
    }
    return _books.save(book.setFavorite(favorite));
  }
}
