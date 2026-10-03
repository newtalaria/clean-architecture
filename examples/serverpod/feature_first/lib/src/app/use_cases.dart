import '../features/notes/application/list_notes_use_case.dart';
import '../features/notes/application/ports/clock.dart';
import '../features/notes/application/ports/id_generator.dart';
import '../features/notes/application/save_note_use_case.dart';
import '../features/notes/infra/note_repository_impl.dart';
import 'repositories.dart';

/// Composition root for use cases. The only type that constructs a repository impl.
class UseCases {
  UseCases(
    NoteStore store, {
    Clock? clock,
    IdGenerator? ids,
  }) : _repositories = Repositories(store),
       _clock = clock ?? const SystemClock(),
       _ids = ids ?? SequentialIdGenerator();

  final Repositories _repositories;
  final Clock _clock;
  final IdGenerator _ids;

  SaveNoteUseCase saveNote() => SaveNoteUseCase(
    _repositories.noteRepository(),
    clock: _clock,
    ids: _ids,
  );

  ListNotesUseCase listNotes() =>
      ListNotesUseCase(_repositories.noteRepository());
}
