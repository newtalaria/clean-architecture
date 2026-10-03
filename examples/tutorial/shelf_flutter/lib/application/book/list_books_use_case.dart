import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

class ListBooksUseCase {
  const ListBooksUseCase(this._books);

  final BookRepository _books;

  Future<List<Book>> execute() => _books.list();
}
