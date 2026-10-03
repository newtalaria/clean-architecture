import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class FakeShelfRepository implements ShelfRepository {
  final shelves = <String, Shelf>{};

  @override
  Future<Shelf> save(Shelf shelf) async {
    shelves[shelf.id] = shelf;
    return shelf;
  }

  @override
  Future<List<Shelf>> list() async => shelves.values.toList();
}
