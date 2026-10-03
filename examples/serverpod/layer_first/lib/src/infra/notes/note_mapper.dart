import '../../domain/notes/entities/note.dart';
import 'note_row.dart';

class NoteMapper {
  const NoteMapper();

  NoteRow toRow(Note note) => NoteRow(
    id: note.id,
    title: note.title,
    body: note.body,
    createdAtMicros: note.createdAt.toUtc().microsecondsSinceEpoch,
  );

  Note toNote(NoteRow row) => Note(
    id: row.id,
    title: row.title,
    body: row.body,
    createdAt: DateTime.fromMicrosecondsSinceEpoch(
      row.createdAtMicros,
      isUtc: true,
    ),
  );
}
