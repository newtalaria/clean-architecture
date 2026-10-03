import '../features/notes/infra/note_repository_impl.dart';

class Repositories {
  Repositories(this.store);

  final NoteStore store;

  NoteRepositoryImpl noteRepository() => NoteRepositoryImpl(store);
}
