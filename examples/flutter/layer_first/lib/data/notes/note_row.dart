import 'package:notes_flutter_layer_first/domain/notes/note.dart';

/// Persistence shape. Micros on the row, [DateTime] on the entity.
class NoteRow {
  const NoteRow({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAtMicros,
  });

  final String id;
  final String title;
  final String body;
  final int createdAtMicros;

  factory NoteRow.fromNote(Note note) {
    return NoteRow(
      id: note.id,
      title: note.title,
      body: note.body,
      createdAtMicros: note.createdAt.microsecondsSinceEpoch,
    );
  }

  Note toNote() {
    return Note(
      id: id,
      title: title,
      body: body,
      createdAt: DateTime.fromMicrosecondsSinceEpoch(createdAtMicros),
    );
  }
}
