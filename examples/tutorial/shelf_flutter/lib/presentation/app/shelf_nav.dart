import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class ShelfNav extends StatelessWidget {
  const ShelfNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => context.beamToNamed(RoutePaths.books),
          child: const Text('Books'),
        ),
        TextButton(
          onPressed: () => context.beamToNamed(RoutePaths.shelves),
          child: const Text('Shelves'),
        ),
      ],
    );
  }
}
