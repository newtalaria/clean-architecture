import '../../shared/exceptions/conflict.dart';
import '../../shared/exceptions/validation_failure.dart';
import '../value_objects/shelf_name.dart';

/// A named place with a finite number of books.
class Shelf {
  const Shelf({
    required this.id,
    required this.name,
    required this.capacity,
    required this.createdAt,
  });

  final String id;
  final String name;
  final int capacity;
  final DateTime createdAt;

  static const maxCapacity = 500;

  factory Shelf.create({
    required String id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) {
    if (capacity < 1 || capacity > maxCapacity) {
      throw const ValidationFailure('Capacity must be from 1 to 500');
    }
    return Shelf(
      id: id,
      name: ShelfName.parse(name).value,
      capacity: capacity,
      createdAt: createdAt.toUtc(),
    );
  }

  /// Throws [Conflict] when another book would exceed [capacity].
  void ensureRoomForAnother(int booksAlreadyOnShelf) {
    if (booksAlreadyOnShelf >= capacity) {
      throw const Conflict('Shelf is full');
    }
  }
}
