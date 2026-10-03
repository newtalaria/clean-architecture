import '../../domain/shared/exceptions/validation_failure.dart';
import '../../app/use_cases.dart';
import 'note_request_failure.dart';
import 'note_wire.dart';
import 'wire_mappers.dart';

/// Thin edge. In a generated Serverpod server this class extends `Endpoint`
/// and the input types come from `serverpod generate`. The method shape is the
/// same: map wire input, call one use case, map the result or the failure.
class NotesEndpoint {
  NotesEndpoint({required this.useCases, this.mappers = const WireMappers()});

  final UseCases useCases;
  final WireMappers mappers;

  Future<NoteDto> save(SaveNoteInput input) async {
    try {
      final note = await useCases.saveNote().execute(
        title: input.title,
        body: input.body,
      );
      return mappers.toNoteDto(note);
    } on ValidationFailure catch (error) {
      throw NoteRequestFailure(400, error.message);
    }
  }

  Future<NoteListResponse> list() async {
    final notes = await useCases.listNotes().execute();
    return NoteListResponse(notes: notes.map(mappers.toNoteDto).toList());
  }
}
