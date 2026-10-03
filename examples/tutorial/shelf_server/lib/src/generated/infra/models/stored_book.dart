/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Persistence row for a book. Not the domain entity.
abstract class StoredBook
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  StoredBook._({
    this.id,
    required this.title,
    required this.authorName,
    required this.status,
    this.shelfId,
    required this.createdAt,
  });

  factory StoredBook({
    _is.UuidValue? id,
    required String title,
    required String authorName,
    required String status,
    _is.UuidValue? shelfId,
    required DateTime createdAt,
  }) = _StoredBookImpl;

  factory StoredBook.fromJson(Map<String, dynamic> jsonSerialization) {
    return StoredBook(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      authorName: jsonSerialization['authorName'] as String,
      status: jsonSerialization['status'] as String,
      shelfId: jsonSerialization['shelfId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['shelfId']),
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = StoredBookTable();

  static const db = StoredBookRepository._();

  @override
  _is.UuidValue? id;

  String title;

  String authorName;

  String status;

  _is.UuidValue? shelfId;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [StoredBook]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StoredBook copyWith({
    _is.UuidValue? id,
    String? title,
    String? authorName,
    String? status,
    _is.UuidValue? shelfId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StoredBook',
      if (id != null) 'id': id?.toJson(),
      'title': title,
      'authorName': authorName,
      'status': status,
      if (shelfId != null) 'shelfId': shelfId?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static StoredBookInclude include() {
    return StoredBookInclude._();
  }

  static StoredBookIncludeList includeList({
    _is.WhereExpressionBuilder<StoredBookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoredBookTable>? orderBy,
    _is.OrderByListBuilder<StoredBookTable>? orderByList,
    StoredBookInclude? include,
  }) {
    return StoredBookIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StoredBook.t),
      orderByList: orderByList?.call(StoredBook.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StoredBookImpl extends StoredBook {
  _StoredBookImpl({
    _is.UuidValue? id,
    required String title,
    required String authorName,
    required String status,
    _is.UuidValue? shelfId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         authorName: authorName,
         status: status,
         shelfId: shelfId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StoredBook]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StoredBook copyWith({
    Object? id = _Undefined,
    String? title,
    String? authorName,
    String? status,
    Object? shelfId = _Undefined,
    DateTime? createdAt,
  }) {
    return StoredBook(
      id: id is _is.UuidValue? ? id : this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      status: status ?? this.status,
      shelfId: shelfId is _is.UuidValue? ? shelfId : this.shelfId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class StoredBookUpdateTable extends _is.UpdateTable<StoredBookTable> {
  StoredBookUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> authorName(String value) => _is.ColumnValue(
    table.authorName,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> shelfId(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.shelfId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class StoredBookTable extends _is.Table<_is.UuidValue?> {
  StoredBookTable({super.tableRelation}) : super(tableName: 'stored_book') {
    updateTable = StoredBookUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    authorName = _is.ColumnString(
      'authorName',
      this,
    );
    status = _is.ColumnString(
      'status',
      this,
    );
    shelfId = _is.ColumnUuid(
      'shelfId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final StoredBookUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnString authorName;

  late final _is.ColumnString status;

  late final _is.ColumnUuid shelfId;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    title,
    authorName,
    status,
    shelfId,
    createdAt,
  ];
}

class StoredBookInclude extends _is.IncludeObject {
  StoredBookInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => StoredBook.t;
}

class StoredBookIncludeList extends _is.IncludeList {
  StoredBookIncludeList._({
    _is.WhereExpressionBuilder<StoredBookTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StoredBook.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => StoredBook.t;
}

class StoredBookRepository {
  const StoredBookRepository._();

  /// Returns a list of [StoredBook]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<StoredBook>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoredBookTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoredBookTable>? orderBy,
    _is.OrderByListBuilder<StoredBookTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StoredBook>(
      where: where?.call(StoredBook.t),
      orderBy: orderBy?.call(StoredBook.t),
      orderByList: orderByList?.call(StoredBook.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StoredBook] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<StoredBook?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoredBookTable>? where,
    int? offset,
    _is.OrderByBuilder<StoredBookTable>? orderBy,
    _is.OrderByListBuilder<StoredBookTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StoredBook>(
      where: where?.call(StoredBook.t),
      orderBy: orderBy?.call(StoredBook.t),
      orderByList: orderByList?.call(StoredBook.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StoredBook] by its [id] or null if no such row exists.
  Future<StoredBook?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StoredBook>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StoredBook]s in the list and returns the inserted rows.
  ///
  /// The returned [StoredBook]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredBook>> insert(
    _is.DatabaseSession session,
    List<StoredBook> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StoredBook>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StoredBook] and returns the inserted row.
  ///
  /// The returned [StoredBook] will have its `id` field set.
  Future<StoredBook> insertRow(
    _is.DatabaseSession session,
    StoredBook row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StoredBook>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StoredBook]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [StoredBook]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredBook>> upsert(
    _is.DatabaseSession session,
    List<StoredBook> rows, {
    required _is.ColumnSelections<StoredBookTable> conflictColumns,
    _is.ColumnSelections<StoredBookTable>? updateColumns,
    _is.WhereExpressionBuilder<StoredBookTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StoredBook>(
      rows,
      conflictColumns: conflictColumns(StoredBook.t),
      updateColumns: updateColumns?.call(StoredBook.t),
      updateWhere: updateWhere?.call(StoredBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StoredBook] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [StoredBook] will have its `id` field set.
  Future<StoredBook?> upsertRow(
    _is.DatabaseSession session,
    StoredBook row, {
    required _is.ColumnSelections<StoredBookTable> conflictColumns,
    _is.ColumnSelections<StoredBookTable>? updateColumns,
    _is.WhereExpressionBuilder<StoredBookTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StoredBook>(
      row,
      conflictColumns: conflictColumns(StoredBook.t),
      updateColumns: updateColumns?.call(StoredBook.t),
      updateWhere: updateWhere?.call(StoredBook.t),
      transaction: transaction,
    );
  }

  /// Updates all [StoredBook]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredBook>> update(
    _is.DatabaseSession session,
    List<StoredBook> rows, {
    _is.ColumnSelections<StoredBookTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StoredBook>(
      rows,
      columns: columns?.call(StoredBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StoredBook]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StoredBook> updateRow(
    _is.DatabaseSession session,
    StoredBook row, {
    _is.ColumnSelections<StoredBookTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StoredBook>(
      row,
      columns: columns?.call(StoredBook.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StoredBook] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StoredBook?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<StoredBookUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StoredBook>(
      id,
      columnValues: columnValues(StoredBook.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StoredBook]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredBook>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StoredBookUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StoredBookTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoredBookTable>? orderBy,
    _is.OrderByListBuilder<StoredBookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StoredBook>(
      columnValues: columnValues(StoredBook.t.updateTable),
      where: where(StoredBook.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StoredBook.t),
      orderByList: orderByList?.call(StoredBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StoredBook]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredBook>> delete(
    _is.DatabaseSession session,
    List<StoredBook> rows, {
    _is.OrderByBuilder<StoredBookTable>? orderBy,
    _is.OrderByListBuilder<StoredBookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StoredBook>(
      rows,
      orderBy: orderBy?.call(StoredBook.t),
      orderByList: orderByList?.call(StoredBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StoredBook].
  Future<StoredBook> deleteRow(
    _is.DatabaseSession session,
    StoredBook row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StoredBook>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredBook>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StoredBookTable> where,
    _is.OrderByBuilder<StoredBookTable>? orderBy,
    _is.OrderByListBuilder<StoredBookTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StoredBook>(
      where: where(StoredBook.t),
      orderBy: orderBy?.call(StoredBook.t),
      orderByList: orderByList?.call(StoredBook.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoredBookTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StoredBook>(
      where: where?.call(StoredBook.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StoredBook] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StoredBookTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StoredBook>(
      where: where(StoredBook.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
