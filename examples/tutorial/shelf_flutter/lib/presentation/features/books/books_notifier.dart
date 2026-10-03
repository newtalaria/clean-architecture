import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/application/book/save_book_command.dart';
import 'package:shelf_flutter/domain/book/book.dart';
import 'package:shelf_flutter/domain/book/reading_status.dart';
import 'package:shelf_flutter/domain/shared/validation_failure.dart';

class BooksNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() {
    return ref.watch(listBooksUseCaseProvider).execute();
  }

  /// Returns a message when the domain rejects the book. Otherwise null.
  Future<String?> save({
    required String title,
    required String authorName,
  }) async {
    try {
      await ref
          .read(saveBookUseCaseProvider)
          .execute(
            SaveBookCommand(
              title: title,
              authorName: authorName,
              status: ReadingStatus.unread,
            ),
          );
      state = AsyncData(await ref.read(listBooksUseCaseProvider).execute());
      return null;
    } on ValidationFailure catch (error) {
      return error.message;
    }
  }
}

final booksProvider = AsyncNotifierProvider<BooksNotifier, List<Book>>(
  BooksNotifier.new,
);
