import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/domain/book/book_repository.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/book/book_mapper.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

/// Session-scoped. Construct one per request in [Repositories], never as a singleton.
class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(this._session, {BookMapper? mapper})
    : _mapper = mapper ?? const BookMapper();

  final Session _session;
  final BookMapper _mapper;

  @override
  Future<Book> save(Book book) async {
    final row = _mapper.toRow(book);
    final existing = await StoredBook.db.findById(_session, row.id!);
    final stored = existing == null
        ? await StoredBook.db.insertRow(_session, row)
        : await StoredBook.db.updateRow(_session, row);
    return _mapper.toDomain(stored);
  }

  @override
  Future<Book?> findById(String id) async {
    final row = await StoredBook.db.findById(_session, uuidFromString(id));
    return row == null ? null : _mapper.toDomain(row);
  }

  @override
  Future<List<Book>> list() async {
    final rows = await StoredBook.db.find(_session);
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows.map(_mapper.toDomain).toList();
  }

  @override
  Future<int> countOnShelf(String shelfId) {
    return StoredBook.db.count(
      _session,
      where: (t) => t.shelfId.equals(uuidFromString(shelfId)),
    );
  }
}
