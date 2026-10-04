import 'package:shelf_flutter/application/book/save_book_command.dart';
import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';

/// Validates with [Book.create], then stores through the port.
///
/// The id used for validation is replaced by the id the server returns.
class SaveBookUseCase {
  const SaveBookUseCase(this._books, {required this.clock, required this.ids});

  final BookRepository _books;
  final Clock clock;
  final IdGenerator ids;

  Future<Book> execute(SaveBookCommand command) {
    final draft = Book.create(
      id: ids.newId(),
      title: command.title,
      authorName: command.authorName,
      status: command.status,
      createdAt: clock.now(),
    );
    return _books.save(draft);
  }
}
