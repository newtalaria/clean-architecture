abstract interface class IdGenerator {
  String next();
}

class SequentialIdGenerator implements IdGenerator {
  int _next = 0;

  @override
  String next() {
    _next += 1;
    return 'note-$_next';
  }
}
