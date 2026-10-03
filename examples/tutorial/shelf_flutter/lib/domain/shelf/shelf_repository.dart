import 'package:shelf_flutter/domain/shelf/shelf.dart';

abstract interface class ShelfRepository {
  Future<Shelf> save(Shelf shelf);

  Future<List<Shelf>> list();
}
