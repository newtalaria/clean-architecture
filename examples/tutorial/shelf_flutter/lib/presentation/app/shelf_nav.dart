import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

enum ShelfSection { books, shelves, favourites }

class ShelfNav extends StatelessWidget {
  const ShelfNav({super.key, required this.section});

  final ShelfSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text('Shelf', style: theme.textTheme.titleLarge),
        const Spacer(),
        _NavButton(
          label: 'Library',
          selected: section == ShelfSection.books,
          onPressed: () => context.beamToNamed(RoutePaths.books),
        ),
        _NavButton(
          label: 'Shelves',
          selected: section == ShelfSection.shelves,
          onPressed: () => context.beamToNamed(RoutePaths.shelves),
        ),
        _NavButton(
          label: 'Favourites',
          selected: section == ShelfSection.favourites,
          onPressed: () => context.beamToNamed(RoutePaths.favourites),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface,
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const RoundedRectangleBorder(),
        textStyle: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: selected ? 18 : 0,
            color: selected ? theme.colorScheme.onSurface : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
