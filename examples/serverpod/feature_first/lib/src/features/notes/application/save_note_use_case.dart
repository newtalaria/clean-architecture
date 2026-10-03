import '../domain/note.dart';
import '../domain/note_repository.dart';
import './ports/clock.dart';
import './ports/id_generator.dart';

class SaveNoteUseCase {
  const SaveNoteUseCase(
    this._notes, {
    required Clock clock,
    required IdGenerator ids,
  }) : _clock = clock,
       _ids = ids;

  final NoteRepository _notes;
  final Clock _clock;
  final IdGenerator _ids;

  Future<Note> execute({required String title, required String body}) {
    final note = Note.create(
      id: _ids.newId(),
      title: title,
      body: body,
      now: _clock.now(),
    );
    return _notes.save(note);
  }
}
