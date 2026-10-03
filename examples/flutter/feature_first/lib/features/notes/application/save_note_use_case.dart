import 'package:notes_flutter_feature_first/features/notes/application/clock.dart';
import 'package:notes_flutter_feature_first/features/notes/application/id_generator.dart';
import 'package:notes_flutter_feature_first/features/notes/domain/note.dart';
import 'package:notes_flutter_feature_first/features/notes/domain/note_repository.dart';

class SaveNoteUseCase {
  SaveNoteUseCase(this._notes, {required Clock clock, required IdGenerator ids})
    : _clock = clock,
      _ids = ids;

  final NoteRepository _notes;
  final Clock _clock;
  final IdGenerator _ids;

  Future<Note> execute({required String title, required String body}) async {
    final note = Note.create(
      id: _ids.next(),
      title: title,
      body: body,
      createdAt: _clock.now(),
    );
    await _notes.save(note);
    return note;
  }
}
