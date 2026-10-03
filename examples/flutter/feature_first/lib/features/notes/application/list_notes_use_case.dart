import 'package:notes_flutter_feature_first/features/notes/domain/note.dart';
import 'package:notes_flutter_feature_first/features/notes/domain/note_repository.dart';

class ListNotesUseCase {
  ListNotesUseCase(this._notes);

  final NoteRepository _notes;

  Future<List<Note>> execute() => _notes.findAll();
}
