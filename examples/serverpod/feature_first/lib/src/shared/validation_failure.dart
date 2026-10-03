/// A business rule the caller can fix. Presentation maps this to a client error.
class ValidationFailure implements Exception {
  const ValidationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
