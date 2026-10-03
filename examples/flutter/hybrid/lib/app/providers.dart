import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'package:notes_flutter_hybrid/application/notes/clock.dart';
import 'package:notes_flutter_hybrid/application/notes/id_generator.dart';
import 'package:notes_flutter_hybrid/application/notes/list_notes_use_case.dart';
import 'package:notes_flutter_hybrid/application/notes/save_note_use_case.dart';
import 'package:notes_flutter_hybrid/data/notes/note_repository_impl.dart';
import 'package:notes_flutter_hybrid/domain/notes/note_repository.dart';

/// The only place that constructs [NoteRepositoryImpl].
final noteStoreProvider = Provider<NoteStore>((ref) => NoteStore());

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(ref.watch(noteStoreProvider));
});

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => SequentialIdGenerator(),
);

final saveNoteUseCaseProvider = Provider<SaveNoteUseCase>((ref) {
  return SaveNoteUseCase(
    ref.watch(noteRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final listNotesUseCaseProvider = Provider<ListNotesUseCase>((ref) {
  return ListNotesUseCase(ref.watch(noteRepositoryProvider));
});

/// Overridden in main with Talaria.wrapHttpClient when a key is set.
final notesHttpClientProvider = Provider<http.Client>((ref) => http.Client());
