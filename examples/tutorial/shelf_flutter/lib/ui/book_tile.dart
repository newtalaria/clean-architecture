import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.title,
    required this.authorName,
    required this.status,
  });

  final String title;
  final String authorName;
  final String status;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('$authorName · $status'),
    );
  }
}
