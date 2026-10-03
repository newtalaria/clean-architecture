import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/application/book/list_books_use_case.dart';
import 'package:shelf_flutter/application/book/save_book_use_case.dart';
import 'package:shelf_flutter/application/ports/clock.dart';
import 'package:shelf_flutter/application/ports/id_generator.dart';
import 'package:shelf_flutter/application/shelf/list_shelves_use_case.dart';
import 'package:shelf_flutter/application/shelf/place_book_on_shelf_use_case.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_use_case.dart';
import 'package:shelf_flutter/data/serverpod_book_repository.dart';
import 'package:shelf_flutter/data/serverpod_shelf_repository.dart';
import 'package:shelf_flutter/domain/book/book_repository.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

/// Overridden in main with the generated client.
final clientProvider = Provider<Client>((ref) {
  throw StateError('Override clientProvider in main');
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return ServerpodBookRepository(ref.watch(clientProvider));
});

final shelfRepositoryProvider = Provider<ShelfRepository>((ref) {
  return ServerpodShelfRepository(ref.watch(clientProvider));
});

final clockProvider = Provider<Clock>((ref) => const SystemClock());

final idGeneratorProvider = Provider<IdGenerator>(
  (ref) => const UuidIdGenerator(),
);

final saveBookUseCaseProvider = Provider<SaveBookUseCase>((ref) {
  return SaveBookUseCase(
    ref.watch(bookRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final listBooksUseCaseProvider = Provider<ListBooksUseCase>((ref) {
  return ListBooksUseCase(ref.watch(bookRepositoryProvider));
});

final saveShelfUseCaseProvider = Provider<SaveShelfUseCase>((ref) {
  return SaveShelfUseCase(
    ref.watch(shelfRepositoryProvider),
    clock: ref.watch(clockProvider),
    ids: ref.watch(idGeneratorProvider),
  );
});

final listShelvesUseCaseProvider = Provider<ListShelvesUseCase>((ref) {
  return ListShelvesUseCase(ref.watch(shelfRepositoryProvider));
});

final placeBookOnShelfUseCaseProvider = Provider<PlaceBookOnShelfUseCase>((
  ref,
) {
  return PlaceBookOnShelfUseCase(ref.watch(bookRepositoryProvider));
});
