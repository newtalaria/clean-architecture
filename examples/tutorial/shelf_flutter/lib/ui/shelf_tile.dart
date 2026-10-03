import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
class ShelfTile extends StatelessWidget {
  const ShelfTile({
    super.key,
    required this.name,
    required this.capacity,
  });

  final String name;
  final int capacity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text('Capacity $capacity'),
    );
  }
}
