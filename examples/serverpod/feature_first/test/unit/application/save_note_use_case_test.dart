import 'package:notes_feature_first/src/features/notes/domain/note.dart';
import 'package:notes_feature_first/src/features/notes/domain/note_repository.dart';
import 'package:notes_feature_first/src/features/notes/application/save_note_use_case.dart';
import 'package:notes_feature_first/src/features/notes/application/ports/clock.dart';
import 'package:notes_feature_first/src/features/notes/application/ports/id_generator.dart';
import 'package:notes_feature_first/src/shared/validation_failure.dart';
import 'package:test/test.dart';

class FakeNoteRepository implements NoteRepository {
  final List<Note> saved = [];

  @override
  Future<Note> save(Note note) async {
    saved.add(note);
    return note;
  }

  @override
  Future<List<Note>> findAll() async => List.of(saved);
}

class FixedClock implements Clock {
  FixedClock(this.instant);
  final DateTime instant;
  @override
  DateTime now() => instant;
}

class FixedIds implements IdGenerator {
  @override
  String newId() => 'note-1';
}

void main() {
  final now = DateTime.utc(2026, 10, 3);

  SaveNoteUseCase useCase(FakeNoteRepository notes) => SaveNoteUseCase(
    notes,
    clock: FixedClock(now),
    ids: FixedIds(),
  );

  test('saves a valid note', () async {
    final notes = FakeNoteRepository();
    final result = await useCase(notes).execute(title: 'Market', body: 'Buy oat milk');
    expect(notes.saved, [result]);
    expect(result.id, 'note-1');
    expect(result.createdAt, now);
  });

  test('does not save a blank title', () async {
    final notes = FakeNoteRepository();
    expect(
      () => useCase(notes).execute(title: ' ', body: 'body'),
      throwsA(isA<ValidationFailure>()),
    );
    expect(notes.saved, isEmpty);
  });
}
