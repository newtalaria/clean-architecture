import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(title), subtitle: Text(body));
  }
}
