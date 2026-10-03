import 'entities/shelf.dart';

/// What the domain needs stored about shelves. No SQL, no Session.
abstract interface class ShelfRepository {
  Future<Shelf> save(Shelf shelf);

  Future<Shelf?> findById(String id);

  /// Newest first.
  Future<List<Shelf>> list();
}
