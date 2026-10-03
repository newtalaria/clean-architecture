import '../../domain/book/book_repository.dart';
import '../../domain/book/entities/book.dart';
import '../ports/clock.dart';
import '../ports/id_generator.dart';
import 'save_book_command.dart';

/// One intent: create a book. The entity checks the title and the author.
class SaveBookUseCase {
  const SaveBookUseCase(
    this._books, {
    required this.clock,
    required this.ids,
  });

  final BookRepository _books;
  final Clock clock;
  final IdGenerator ids;

  Future<Book> execute(SaveBookCommand command) {
    final book = Book.create(
      id: ids.newId(),
      title: command.title,
      authorName: command.authorName,
      status: command.status,
      createdAt: clock.now(),
    );
    return _books.save(book);
  }
}
