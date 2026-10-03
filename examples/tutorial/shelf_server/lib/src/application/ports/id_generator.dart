import 'package:uuid/uuid.dart';

/// Identity source for new entities. Tests pass a sequence.
abstract interface class IdGenerator {
  String newId();
}

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const _uuid = Uuid();

  @override
  String newId() => _uuid.v4();
}
