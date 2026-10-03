import 'package:dart_mappable/dart_mappable.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf_name.dart';

part 'shelf.mapper.dart';

@MappableClass()
class Shelf with ShelfMappable {
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

  void ensureRoomForAnother(int booksAlreadyOnShelf) {
    if (booksAlreadyOnShelf >= capacity) {
      throw const Conflict('Shelf is full');
    }
  }
}
