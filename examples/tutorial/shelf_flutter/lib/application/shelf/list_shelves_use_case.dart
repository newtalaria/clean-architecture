import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class ListShelvesUseCase {
  const ListShelvesUseCase(this._shelves);

  final ShelfRepository _shelves;

  Future<List<Shelf>> execute() => _shelves.list();
}
