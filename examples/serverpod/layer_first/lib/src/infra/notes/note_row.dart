/// Persistence model. Column-shaped, separate from the domain note.
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
}
