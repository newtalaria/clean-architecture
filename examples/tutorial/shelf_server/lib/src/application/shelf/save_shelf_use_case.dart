import '../../domain/shelf/entities/shelf.dart';
import '../../domain/shelf/shelf_repository.dart';
import '../ports/clock.dart';
import '../ports/id_generator.dart';
import 'save_shelf_command.dart';

class SaveShelfUseCase {
  const SaveShelfUseCase(
    this._shelves, {
    required this.clock,
    required this.ids,
  });

  final ShelfRepository _shelves;
  final Clock clock;
  final IdGenerator ids;

  Future<Shelf> execute(SaveShelfCommand command) {
    final shelf = Shelf.create(
      id: ids.newId(),
      name: command.name,
      capacity: command.capacity,
      createdAt: clock.now(),
    );
    return _shelves.save(shelf);
  }
}
