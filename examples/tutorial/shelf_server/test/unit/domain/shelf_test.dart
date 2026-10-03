import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:shelf_server/src/domain/shelf/entities/shelf.dart';
import 'package:test/test.dart';

void main() {
  final created = DateTime.utc(2026, 10, 3);

  Shelf build({int capacity = 2}) {
    return Shelf.create(
      id: 's1',
      name: '  Fiction  ',
      capacity: capacity,
      createdAt: created,
    );
  }

  test('create trims the name', () {
    expect(build().name, 'Fiction');
  });

  test('capacity outside 1 to 500 is rejected', () {
    expect(
      () => Shelf.create(
        id: 's1',
        name: 'Fiction',
        capacity: 0,
        createdAt: created,
      ),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('a full shelf refuses another book', () {
    final shelf = build(capacity: 1);
    shelf.ensureRoomForAnother(0);
    expect(() => shelf.ensureRoomForAnother(1), throwsA(isA<Conflict>()));
  });
}
