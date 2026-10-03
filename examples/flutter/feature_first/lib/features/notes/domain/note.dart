import 'package:notes_flutter_feature_first/shared/validation_failure.dart';

/// A note the user can save. [Note.create] is the only constructor that checks rules.
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

  factory Note.create({
    required String id,
    required String title,
    required String body,
    required DateTime createdAt,
  }) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('Title is required');
    }
    return Note(
      id: id,
      title: trimmed,
      body: body.trim(),
      createdAt: createdAt,
    );
  }
}
