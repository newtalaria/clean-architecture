/// The request fights the current state. The endpoint maps this to a 409.
class Conflict implements Exception {
  const Conflict(this.message);

  final String message;

  @override
  String toString() => message;
}
