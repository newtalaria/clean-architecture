import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';
import '../../domain/shared/exceptions/not_found.dart';
import '../../domain/shelf/shelf_repository.dart';

/// Places a book on a shelf. Lives with shelves and uses the book port.
///
/// This is the workflow a feature-first folder cannot own: it is not only a
/// shelf change and not only a book change.
class PlaceBookOnShelfUseCase {
  const PlaceBookOnShelfUseCase(this._shelves, this._books);

  final ShelfRepository _shelves;
  final BookRepository _books;

  Future<Book> execute({
    required String bookId,
    required String shelfId,
  }) async {
    final shelf = await _shelves.findById(shelfId);
    if (shelf == null) {
      throw const NotFound('Shelf not found');
    }
    final book = await _books.findById(bookId);
    if (book == null) {
      throw const NotFound('Book not found');
    }
    final alreadyThere = await _books.countOnShelf(shelf.id);
    shelf.ensureRoomForAnother(alreadyThere);
    final placed = book.placeOnShelf(shelf.id);
    return _books.save(placed);
  }
}
