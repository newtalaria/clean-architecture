import 'package:notes_flutter_hybrid/domain/notes/note.dart';
import 'package:notes_flutter_hybrid/domain/notes/note_repository.dart';

class ListNotesUseCase {
  ListNotesUseCase(this._notes);

  final NoteRepository _notes;

  Future<List<Note>> execute() => _notes.findAll();
}
