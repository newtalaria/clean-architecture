import 'package:notes_hybrid/src/infra/notes/note_repository_impl.dart';
import 'package:notes_hybrid/src/app/use_cases.dart';
import 'package:notes_hybrid/src/presentation/notes/notes_endpoint.dart';
import 'package:notes_hybrid/src/presentation/notes/note_request_failure.dart';
import 'package:notes_hybrid/src/presentation/notes/note_wire.dart';
import 'package:test/test.dart';

void main() {
  test('save persists a row and list returns it', () async {
    final store = NoteStore();
    final endpoint = NotesEndpoint(useCases: UseCases(store));

    final saved = await endpoint.save(
      const SaveNoteInput(title: ' Market ', body: 'Buy oat milk'),
    );
    final listed = await endpoint.list();

    expect(saved.title, 'Market');
    expect(listed.notes, hasLength(1));
    expect(listed.notes.single.id, saved.id);
    expect(store.rows, hasLength(1));
    expect(store.rows.values.single.title, 'Market');
  });

  test('blank title does not write a row', () async {
    final store = NoteStore();
    final endpoint = NotesEndpoint(useCases: UseCases(store));

    expect(
      () => endpoint.save(const SaveNoteInput(title: '', body: 'body')),
      throwsA(isA<NoteRequestFailure>().having((e) => e.status, 'status', 400)),
    );
    expect(store.rows, isEmpty);
  });
}
