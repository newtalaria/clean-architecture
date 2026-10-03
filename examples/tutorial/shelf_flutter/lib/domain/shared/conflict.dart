/// The request fights the current state.
class Conflict implements Exception {
  const Conflict(this.message);

  final String message;

  @override
  String toString() => message;
}
