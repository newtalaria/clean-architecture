import 'package:uuid/uuid.dart';

abstract interface class IdGenerator {
  String newId();
}

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const _uuid = Uuid();

  @override
  String newId() => _uuid.v4();
}
