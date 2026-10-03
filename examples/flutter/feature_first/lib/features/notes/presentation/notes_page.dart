import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_flutter_feature_first/features/notes/presentation/notes_controller.dart';
import 'package:notes_flutter_feature_first/features/notes/presentation/note_tile.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const Key('note-title'),
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              key: const Key('note-body'),
              controller: _body,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
            if (_error != null) Text(_error!),
            const SizedBox(height: 8),
            FilledButton(
              key: const Key('save-note'),
              onPressed: () async {
                final message = await ref
                    .read(notesProvider.notifier)
                    .save(_title.text, _body.text);
                if (!mounted) return;
                setState(() => _error = message);
                if (message == null) {
                  _title.clear();
                  _body.clear();
                }
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: notes.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Text('No notes yet');
                  }
                  return ListView(
                    children: [
                      for (final note in items)
                        NoteTile(title: note.title, body: note.body),
                    ],
                  );
                },
                loading: () => const Text('Loading'),
                error: (error, stackTrace) => Text(error.toString()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
