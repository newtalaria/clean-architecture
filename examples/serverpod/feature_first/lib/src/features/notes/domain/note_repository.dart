import './note.dart';

/// Persistence port. The domain names the capability, not the store.
abstract class NoteRepository {
  Future<Note> save(Note note);
  Future<List<Note>> findAll();
}
