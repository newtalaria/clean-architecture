import 'package:flutter/material.dart';

/// Centers the screen on a reading width. Pages put their column in [child].
class ShelfFrame extends StatelessWidget {
  const ShelfFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Page title, an optional count, and the action that opens a dialog.
class ShelfSectionHeader extends StatelessWidget {
  const ShelfSectionHeader({
    super.key,
    required this.title,
    this.detail,
    this.action,
  });

  final String title;
  final String? detail;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              if (detail != null) ...[
                const SizedBox(height: 2),
                Text(detail!, style: theme.textTheme.bodySmall),
              ],
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

/// Empty list copy. [message] is the line the widget tests look for.
class ShelfEmpty extends StatelessWidget {
  const ShelfEmpty({super.key, required this.message, required this.hint});

  final String message;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 28,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 10),
          Text(message, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            hint,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Quiet wait. Pages use this instead of the word "Loading".
class ShelfLoading extends StatelessWidget {
  const ShelfLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// One sentence when a list cannot be loaded.
class ShelfFailure extends StatelessWidget {
  const ShelfFailure({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
