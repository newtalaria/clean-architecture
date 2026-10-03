import 'entities/book.dart';

/// What the domain needs stored about books. No SQL, no Session.
abstract interface class BookRepository {
  Future<Book> save(Book book);

  Future<Book?> findById(String id);

  /// Newest first.
  Future<List<Book>> list();

  Future<int> countOnShelf(String shelfId);
}
