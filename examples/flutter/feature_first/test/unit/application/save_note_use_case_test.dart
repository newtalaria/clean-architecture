import 'package:flutter_test/flutter_test.dart';
import 'package:notes_flutter_feature_first/features/notes/application/clock.dart';
import 'package:notes_flutter_feature_first/features/notes/application/id_generator.dart';
import 'package:notes_flutter_feature_first/features/notes/application/list_notes_use_case.dart';
import 'package:notes_flutter_feature_first/features/notes/application/save_note_use_case.dart';
import 'package:notes_flutter_feature_first/features/notes/data/note_repository_impl.dart';
import 'package:notes_flutter_feature_first/features/notes/domain/note.dart';
import 'package:notes_flutter_feature_first/features/notes/domain/note_repository.dart';
import 'package:notes_flutter_feature_first/shared/validation_failure.dart';

class FakeNoteRepository implements NoteRepository {
  final saved = <Note>[];

  @override
  Future<void> save(Note note) async {
    saved.add(note);
  }

  @override
  Future<List<Note>> findAll() async => List<Note>.of(saved);
}

class FixedClock implements Clock {
  FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

class FixedIds implements IdGenerator {
  @override
  String next() => 'note-1';
}

void main() {
  final createdAt = DateTime.utc(2026, 10, 3);

  test('saves a trimmed note through a fake repository', () async {
    final notes = FakeNoteRepository();
    final useCase = SaveNoteUseCase(
      notes,
      clock: FixedClock(createdAt),
      ids: FixedIds(),
    );

    final note = await useCase.execute(title: ' Market ', body: ' Oat ');

    expect(note.id, 'note-1');
    expect(note.title, 'Market');
    expect(notes.saved, [note]);
  });

  test('a blank title does not save', () async {
    final notes = FakeNoteRepository();
    final useCase = SaveNoteUseCase(
      notes,
      clock: FixedClock(createdAt),
      ids: FixedIds(),
    );

    expect(
      () => useCase.execute(title: ' ', body: 'Oat'),
      throwsA(isA<ValidationFailure>()),
    );
    expect(notes.saved, isEmpty);
  });

  test('save then list crosses the row boundary', () async {
    final store = NoteStore();
    final repo = NoteRepositoryImpl(store);
    await SaveNoteUseCase(
      repo,
      clock: FixedClock(createdAt),
      ids: FixedIds(),
    ).execute(title: 'Market', body: 'Oat milk');

    final listed = await ListNotesUseCase(repo).execute();

    expect(listed.single.title, 'Market');
    expect(store.rows.single.createdAtMicros, createdAt.microsecondsSinceEpoch);
  });
}
