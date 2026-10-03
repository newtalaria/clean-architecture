import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/application/shelf/save_shelf_command.dart';
import 'package:shelf_flutter/domain/shared/conflict.dart';
import 'package:shelf_flutter/domain/shared/not_found.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';

class ShelvesNotifier extends AsyncNotifier<List<Shelf>> {
  @override
  Future<List<Shelf>> build() {
    return ref.watch(listShelvesUseCaseProvider).execute();
  }

  Future<String?> save({required String name, required int capacity}) async {
    try {
      await ref
          .read(saveShelfUseCaseProvider)
          .execute(SaveShelfCommand(name: name, capacity: capacity));
      state = AsyncData(await ref.read(listShelvesUseCaseProvider).execute());
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    }
  }

  Future<String?> place({
    required String bookId,
    required String shelfId,
  }) async {
    try {
      await ref
          .read(placeBookOnShelfUseCaseProvider)
          .execute(bookId: bookId, shelfId: shelfId);
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    } on NotFound catch (error) {
      return error.message;
    } on Conflict catch (error) {
      return error.message;
    }
  }
}

final shelvesProvider = AsyncNotifierProvider<ShelvesNotifier, List<Shelf>>(
  ShelvesNotifier.new,
);
