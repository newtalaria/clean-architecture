import '../../shared/exceptions/conflict.dart';
import '../../shared/exceptions/validation_failure.dart';
import '../value_objects/book_title.dart';
import '../value_objects/reading_status.dart';

/// A book on the shelf. [create] is the only constructor that checks rules.
class Book {
  const Book({
    required this.id,
    required this.title,
    required this.authorName,
    required this.status,
    required this.createdAt,
    this.shelfId,
  });

  final String id;
  final String title;
  final String authorName;
  final ReadingStatus status;
  final DateTime createdAt;

  /// Set once [placeOnShelf] succeeds. Null means the book is not on a shelf.
  final String? shelfId;

  static const _authorMax = 200;

  factory Book.create({
    required String id,
    required String title,
    required String authorName,
    required ReadingStatus status,
    required DateTime createdAt,
  }) {
    return Book(
      id: id,
      title: BookTitle.parse(title).value,
      authorName: _author(authorName),
      status: status,
      createdAt: createdAt.toUtc(),
    );
  }

  /// Returns the same book sitting on [shelfId]. A book has one shelf.
  Book placeOnShelf(String shelfId) {
    if (this.shelfId != null) {
      throw const Conflict('Book is already on a shelf');
    }
    return Book(
      id: id,
      title: title,
      authorName: authorName,
      status: status,
      createdAt: createdAt,
      shelfId: shelfId,
    );
  }

  static String _author(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Author is required');
    }
    if (trimmed.length > _authorMax) {
      throw const ValidationFailure('Author is too long');
    }
    return trimmed;
  }
}
