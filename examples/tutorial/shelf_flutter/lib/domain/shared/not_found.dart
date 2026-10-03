/// The requested entity does not exist.
class NotFound implements Exception {
  const NotFound(this.message);

  final String message;

  @override
  String toString() => message;
}
