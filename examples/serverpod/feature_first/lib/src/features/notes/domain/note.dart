import '../../../shared/validation_failure.dart';

/// A note the business recognizes. Identity is assigned by the use case.
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;

  /// The only constructor that enforces the title invariant.
  static Note create({
    required String id,
    required String title,
    required String body,
    required DateTime now,
  }) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Title is required');
    }
    return Note(id: id, title: trimmed, body: body, createdAt: now.toUtc());
  }
}
