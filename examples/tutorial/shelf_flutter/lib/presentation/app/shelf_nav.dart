import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

enum ShelfSection { books, shelves }

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
          label: 'Books',
          selected: section == ShelfSection.books,
          onPressed: () => context.beamToNamed(RoutePaths.books),
        ),
        const SizedBox(width: 4),
        _NavButton(
          label: 'Shelves',
          selected: section == ShelfSection.shelves,
          onPressed: () => context.beamToNamed(RoutePaths.shelves),
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
        backgroundColor: selected
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}
