import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_command.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

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
    final draft = Shelf.create(
      id: ids.newId(),
      name: command.name,
      capacity: command.capacity,
      createdAt: clock.now(),
    );
    return _shelves.save(draft);
  }
}
