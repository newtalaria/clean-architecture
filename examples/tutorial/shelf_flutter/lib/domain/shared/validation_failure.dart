/// A business rule rejected the input.
class ValidationFailure implements Exception {
  const ValidationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
