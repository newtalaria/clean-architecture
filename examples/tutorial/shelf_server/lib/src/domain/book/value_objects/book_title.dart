import '../../shared/exceptions/validation_failure.dart';

/// A book title the shelf will store. Construct it only through [parse].
class BookTitle {
  const BookTitle._(this.value);

  final String value;

  static const maxLength = 200;

  static BookTitle parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Title is required');
    }
    if (trimmed.length > maxLength) {
      throw const ValidationFailure('Title is too long');
    }
    return BookTitle._(trimmed);
  }
}
