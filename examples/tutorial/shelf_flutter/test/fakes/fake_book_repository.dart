import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

class FakeBookRepository implements BookRepository {
  final books = <String, Book>{};

  @override
  Future<Book> save(Book book) async {
    books[book.id] = book;
    return book;
  }

  @override
  Future<List<Book>> list() async {
    final rows = books.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }

  @override
  Future<Book> placeOnShelf({
    required String bookId,
    required String shelfId,
  }) async {
    final book = books[bookId];
    if (book == null) {
      throw StateError('missing book');
    }
    final placed = book.placeOnShelf(shelfId);
    books[bookId] = placed;
    return placed;
  }
}
