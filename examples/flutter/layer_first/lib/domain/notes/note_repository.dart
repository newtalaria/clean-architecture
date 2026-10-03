import 'package:notes_flutter_layer_first/domain/notes/note.dart';

/// Port. Returns notes, not rows.
abstract interface class NoteRepository {
  Future<void> save(Note note);

  Future<List<Note>> findAll();
}
