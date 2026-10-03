/// The requested entity does not exist. The endpoint maps this to a 404.
class NotFound implements Exception {
  const NotFound(this.message);

  final String message;

  @override
  String toString() => message;
}
