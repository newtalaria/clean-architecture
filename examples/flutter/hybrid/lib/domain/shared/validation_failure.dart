/// A rule the domain rejected. Presentation maps this to an inline message.
class ValidationFailure implements Exception {
  const ValidationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
