import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';

class ListBooksUseCase {
  const ListBooksUseCase(this._books);

  final BookRepository _books;

  Future<List<Book>> execute() => _books.list();
}
