---
title: Book repository implementation
description: BookRepositoryImpl takes a Session, uses the ORM, and returns domain books.
tags: [clean-architecture, tutorial, serverpod]
---

`BookRepositoryImpl` is the adapter. It is constructed per request because it holds a `Session`. Do not register it as a singleton. The composition root builds one when a use case factory is called.

Create `lib/src/infra/book/book_repository_impl.dart`:

```dart
import 'package:serverpod/serverpod.dart';
import 'package:shelf_server/src/domain/book/book_repository.dart';
import 'package:shelf_server/src/domain/book/entities/book.dart';
import 'package:shelf_server/src/generated/protocol.dart';
import 'package:shelf_server/src/infra/book/book_mapper.dart';
import 'package:shelf_server/src/infra/shared/uuid_values.dart';

/// Session-scoped. Construct one per request in [Repositories], never as a singleton.
class BookRepositoryImpl implements BookRepository {
  const BookRepositoryImpl(this._session, {BookMapper? mapper})
    : _mapper = mapper ?? const BookMapper();

  final Session _session;
  final BookMapper _mapper;

  @override
  Future<Book> save(Book book) async {
    final row = _mapper.toRow(book);
    final existing = await StoredBook.db.findById(_session, row.id!);
    final stored = existing == null
        ? await StoredBook.db.insertRow(_session, row)
        : await StoredBook.db.updateRow(_session, row);
    return _mapper.toDomain(stored);
  }

  @override
  Future<Book?> findById(String id) async {
    final row = await StoredBook.db.findById(_session, uuidFromString(id));
    return row == null ? null : _mapper.toDomain(row);
  }

  @override
  Future<List<Book>> list() async {
    final rows = await StoredBook.db.find(_session);
    rows.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows.map(_mapper.toDomain).toList();
  }

  @override
  Future<int> countOnShelf(String shelfId) {
    return StoredBook.db.count(
      _session,
      where: (t) => t.shelfId.equals(uuidFromString(shelfId)),
    );
  }
}
```

`save` looks up the id and inserts or updates. Placing a book on a shelf is an update of the same row. The use case does not know that.

`list` loads the rows and sorts in Dart. A shelf for one person is a bounded set. The ORM `find` is the query. Sorting after the fetch keeps the contract "newest first" obvious in this file. `countOnShelf` stays in the database because the number is the only thing the caller needs.

Every method returns `Book` or a list of `Book` or an `int`. None of them returns `StoredBook`. If a `StoredBook` appears in an application import, the boundary has leaked.

Next: [the wire types](book-wire.md).
