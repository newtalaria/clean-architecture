import '../../shared/exceptions/validation_failure.dart';

/// A shelf name. Construct it only through [parse].
class ShelfName {
  const ShelfName._(this.value);

  final String value;

  static const maxLength = 80;

  static ShelfName parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Name is required');
    }
    if (trimmed.length > maxLength) {
      throw const ValidationFailure('Name is too long');
    }
    return ShelfName._(trimmed);
  }
}
