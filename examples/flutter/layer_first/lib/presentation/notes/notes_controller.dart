import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_flutter_layer_first/domain/shared/validation_failure.dart';
import 'package:notes_flutter_layer_first/domain/notes/note.dart';
import 'package:notes_flutter_layer_first/app/providers.dart';

class NotesNotifier extends AsyncNotifier<List<Note>> {
  @override
  Future<List<Note>> build() {
    return ref.watch(listNotesUseCaseProvider).execute();
  }

  /// Returns a message when the domain rejects the title. Otherwise null.
  Future<String?> save(String title, String body) async {
    try {
      await ref.read(saveNoteUseCaseProvider).execute(title: title, body: body);
      final notes = await ref.read(listNotesUseCaseProvider).execute();
      state = AsyncData(notes);
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    }
  }
}

final notesProvider = AsyncNotifierProvider<NotesNotifier, List<Note>>(
  NotesNotifier.new,
);
