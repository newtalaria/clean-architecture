import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:shelf_server/src/domain/shelf/shelf_repository.dart';

class FakeShelfRepository implements ShelfRepository {
  final shelves = <String, Shelf>{};

  @override
  Future<Shelf> save(Shelf shelf) async {
    shelves[shelf.id] = shelf;
    return shelf;
  }

  @override
  Future<Shelf?> findById(String id) async => shelves[id];

  @override
  Future<List<Shelf>> list() async {
    final rows = shelves.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows;
  }
}
