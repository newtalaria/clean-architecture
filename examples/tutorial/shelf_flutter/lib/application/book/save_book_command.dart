import 'package:shelf_flutter/domain/book/reading_status.dart';

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
