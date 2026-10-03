import '../../domain/book/value_objects/reading_status.dart';

/// Input to [SaveBookUseCase]. Plain Dart. Not a spy type.
class SaveBookCommand {
  const SaveBookCommand({
    required this.title,
    required this.authorName,
    required this.status,
  });

  final String title;
  final String authorName;
  final ReadingStatus status;
}
