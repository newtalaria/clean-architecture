import '../domain/note.dart';
import '../domain/note_repository.dart';
import 'note_mapper.dart';
import 'note_row.dart';

/// Request-scoped store. Stands in for a Serverpod `Session`: constructed per
/// request in the composition root, never cached on a singleton.
class NoteStore {
  final Map<String, NoteRow> rows = {};
}

class NoteRepositoryImpl implements NoteRepository {
  NoteRepositoryImpl(this._store, {NoteMapper? mapper})
    : _mapper = mapper ?? const NoteMapper();

  final NoteStore _store;
  final NoteMapper _mapper;

  @override
  Future<Note> save(Note note) async {
    final row = _mapper.toRow(note);
    _store.rows[row.id] = row;
    return _mapper.toNote(row);
  }

  @override
  Future<List<Note>> findAll() async {
    final rows = _store.rows.values.toList()
      ..sort((a, b) => a.createdAtMicros.compareTo(b.createdAtMicros));
    return rows.map(_mapper.toNote).toList();
  }
}
