import 'package:notes_flutter_feature_first/features/notes/domain/note.dart';

/// Port. Returns notes, not rows.
abstract interface class NoteRepository {
  Future<void> save(Note note);

  Future<List<Note>> findAll();
}
