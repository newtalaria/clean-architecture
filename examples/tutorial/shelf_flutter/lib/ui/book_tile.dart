import 'package:flutter/material.dart';

/// Presentational. This file does not import Riverpod.
///
/// [onFavorite] is null until the favourite chapter wires the heart.
class BookTile extends StatelessWidget {
  const BookTile({
    super.key,
    required this.title,
    required this.authorName,
    required this.status,
    this.favorite = false,
    this.onFavorite,
  });

  final String title;
  final String authorName;
  final String status;
  final bool favorite;
  final VoidCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '$authorName · $status',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (onFavorite != null)
                IconButton(
                  key: Key('favorite-$title'),
                  tooltip: favorite ? 'Remove favourite' : 'Favourite',
                  onPressed: onFavorite,
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite
                        ? theme.colorScheme.primary
                        : theme.textTheme.bodySmall?.color,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
