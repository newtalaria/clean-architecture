import 'package:shelf_server/src/application/ports/clock.dart';
import 'package:shelf_server/src/application/ports/id_generator.dart';
import 'package:shelf_server/src/domain/book/book_repository.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';

class FixedClock implements Clock {
  FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

class SequenceIds implements IdGenerator {
  int _n = 0;

  @override
  String newId() {
    _n += 1;
    return '00000000-0000-4000-8000-${_n.toString().padLeft(12, '0')}';
  }
}

class FakeBookRepository implements BookRepository {
  final books = <String, Book>{};

  @override
  Future<Book> save(Book book) async {
    books[book.id] = book;
    return book;
  }

  @override
  Future<Book?> findById(String id) async => books[id];

  @override
  Future<List<Book>> list() async {
    final rows = books.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }

  @override
  Future<int> countOnShelf(String shelfId) async {
    return books.values.where((book) => book.shelfId == shelfId).length;
  }
}
