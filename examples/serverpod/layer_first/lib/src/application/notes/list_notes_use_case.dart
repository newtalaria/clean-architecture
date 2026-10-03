import '../../domain/notes/entities/note.dart';
import '../../domain/notes/note_repository.dart';

class ListNotesUseCase {
  const ListNotesUseCase(this._notes);

  final NoteRepository _notes;

  Future<List<Note>> execute() => _notes.findAll();
}
