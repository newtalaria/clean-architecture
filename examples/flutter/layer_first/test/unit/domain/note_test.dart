import 'package:flutter_test/flutter_test.dart';
import 'package:notes_flutter_layer_first/domain/shared/validation_failure.dart';
import 'package:notes_flutter_layer_first/domain/notes/note.dart';

void main() {
  test('trims a title', () {
    final note = Note.create(
      id: 'note-1',
      title: ' Market ',
      body: ' Oat milk ',
      createdAt: DateTime.utc(2026, 10, 3),
    );
    expect(note.title, 'Market');
    expect(note.body, 'Oat milk');
  });

  test('rejects a blank title', () {
    expect(
      () => Note.create(
        id: 'note-1',
        title: '   ',
        body: 'Oat milk',
        createdAt: DateTime.utc(2026, 10, 3),
      ),
      throwsA(
        isA<ValidationFailure>().having(
          (error) => error.message,
          'message',
          'Title is required',
        ),
      ),
    );
  });
}
