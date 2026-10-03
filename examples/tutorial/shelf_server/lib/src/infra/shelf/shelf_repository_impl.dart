import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/domain/shelf/shelf_repository.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';
import 'package:shelf_server/src/infra/shelf/shelf_mapper.dart';

class ShelfRepositoryImpl implements ShelfRepository {
  const ShelfRepositoryImpl(this._session, {ShelfMapper? mapper})
    : _mapper = mapper ?? const ShelfMapper();

  final Session _session;
  final ShelfMapper _mapper;

  @override
  Future<Shelf> save(Shelf shelf) async {
    final row = _mapper.toRow(shelf);
    final existing = await StoredShelf.db.findById(_session, row.id!);
    final stored = existing == null
        ? await StoredShelf.db.insertRow(_session, row)
        : await StoredShelf.db.updateRow(_session, row);
    return _mapper.toDomain(stored);
  }

  @override
  Future<Shelf?> findById(String id) async {
    final row = await StoredShelf.db.findById(_session, uuidFromString(id));
    return row == null ? null : _mapper.toDomain(row);
  }

  @override
  Future<List<Shelf>> list() async {
    final rows = await StoredShelf.db.find(_session);
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows.map(_mapper.toDomain).toList();
  }
}
