/// A business rule rejected the input. The endpoint maps this to a 400.
class ValidationFailure implements Exception {
  const ValidationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
