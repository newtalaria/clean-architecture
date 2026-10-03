abstract class IdGenerator {
  String newId();
}

/// Stand-in for a UUID generator. Request-scoped via the composition root.
class SequentialIdGenerator implements IdGenerator {
  int _next = 0;

  @override
  String newId() {
    _next += 1;
    return '$_next';
  }
}
