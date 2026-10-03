class SaveNoteInput {
  const SaveNoteInput({required this.title, required this.body});

  final String title;
  final String body;
}

class NoteDto {
  const NoteDto({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
}

class NoteListResponse {
  const NoteListResponse({required this.notes});

  final List<NoteDto> notes;
}
