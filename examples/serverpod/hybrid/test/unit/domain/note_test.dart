import 'package:notes_hybrid/src/domain/shared/exceptions/validation_failure.dart';
import 'package:notes_hybrid/src/domain/notes/entities/note.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.utc(2026, 10, 3);

  test('blank title is rejected', () {
    expect(
      () => Note.create(id: '1', title: '   ', body: 'body', now: now),
      throwsA(isA<ValidationFailure>()),
    );
  });

  test('title is trimmed', () {
    final note = Note.create(id: '1', title: ' Market ', body: 'body', now: now);
    expect(note.title, 'Market');
    expect(note.createdAt, now);
  });
}
