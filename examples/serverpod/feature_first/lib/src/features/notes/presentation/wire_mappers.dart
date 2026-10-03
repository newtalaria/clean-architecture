import '../domain/note.dart';
import 'note_wire.dart';

class WireMappers {
  const WireMappers();

  NoteDto toNoteDto(Note note) => NoteDto(
    id: note.id,
    title: note.title,
    body: note.body,
    createdAt: note.createdAt,
  );
}
