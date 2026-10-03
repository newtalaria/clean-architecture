import 'package:notes_flutter_layer_first/data/notes/note_row.dart';
import 'package:notes_flutter_layer_first/domain/notes/note.dart';
import 'package:notes_flutter_layer_first/domain/notes/note_repository.dart';

/// In-memory stand-in for the client that would talk to the notes API.
class NoteStore {
  final List<NoteRow> rows = [];
}

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._store);

  final NoteStore _store;

  @override
  Future<void> save(Note note) async {
    _store.rows.add(NoteRow.fromNote(note));
  }

  @override
  Future<List<Note>> findAll() async {
    return [for (final row in _store.rows) row.toNote()];
  }
}
