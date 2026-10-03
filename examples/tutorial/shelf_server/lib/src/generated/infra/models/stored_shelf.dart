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

/// Persistence row for a shelf. Not the domain entity.
abstract class StoredShelf
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  StoredShelf._({
    this.id,
    required this.name,
    required this.capacity,
    required this.createdAt,
  });

  factory StoredShelf({
    _is.UuidValue? id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) = _StoredShelfImpl;

  factory StoredShelf.fromJson(Map<String, dynamic> jsonSerialization) {
    return StoredShelf(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      capacity: jsonSerialization['capacity'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = StoredShelfTable();

  static const db = StoredShelfRepository._();

  @override
  _is.UuidValue? id;

  String name;

  int capacity;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [StoredShelf]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StoredShelf copyWith({
    _is.UuidValue? id,
    String? name,
    int? capacity,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StoredShelf',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      'capacity': capacity,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static StoredShelfInclude include() {
    return StoredShelfInclude._();
  }

  static StoredShelfIncludeList includeList({
    _is.WhereExpressionBuilder<StoredShelfTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoredShelfTable>? orderBy,
    _is.OrderByListBuilder<StoredShelfTable>? orderByList,
    StoredShelfInclude? include,
  }) {
    return StoredShelfIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StoredShelf.t),
      orderByList: orderByList?.call(StoredShelf.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StoredShelfImpl extends StoredShelf {
  _StoredShelfImpl({
    _is.UuidValue? id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         capacity: capacity,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [StoredShelf]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StoredShelf copyWith({
    Object? id = _Undefined,
    String? name,
    int? capacity,
    DateTime? createdAt,
  }) {
    return StoredShelf(
      id: id is _is.UuidValue? ? id : this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class StoredShelfUpdateTable extends _is.UpdateTable<StoredShelfTable> {
  StoredShelfUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> capacity(int value) => _is.ColumnValue(
    table.capacity,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class StoredShelfTable extends _is.Table<_is.UuidValue?> {
  StoredShelfTable({super.tableRelation}) : super(tableName: 'stored_shelf') {
    updateTable = StoredShelfUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    capacity = _is.ColumnInt(
      'capacity',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final StoredShelfUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt capacity;

  late final _is.ColumnDateTime createdAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    capacity,
    createdAt,
  ];
}

class StoredShelfInclude extends _is.IncludeObject {
  StoredShelfInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => StoredShelf.t;
}

class StoredShelfIncludeList extends _is.IncludeList {
  StoredShelfIncludeList._({
    _is.WhereExpressionBuilder<StoredShelfTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StoredShelf.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => StoredShelf.t;
}

class StoredShelfRepository {
  const StoredShelfRepository._();

  /// Returns a list of [StoredShelf]s matching the given query parameters.
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
  Future<List<StoredShelf>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoredShelfTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoredShelfTable>? orderBy,
    _is.OrderByListBuilder<StoredShelfTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StoredShelf>(
      where: where?.call(StoredShelf.t),
      orderBy: orderBy?.call(StoredShelf.t),
      orderByList: orderByList?.call(StoredShelf.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StoredShelf] matching the given query parameters.
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
  Future<StoredShelf?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoredShelfTable>? where,
    int? offset,
    _is.OrderByBuilder<StoredShelfTable>? orderBy,
    _is.OrderByListBuilder<StoredShelfTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StoredShelf>(
      where: where?.call(StoredShelf.t),
      orderBy: orderBy?.call(StoredShelf.t),
      orderByList: orderByList?.call(StoredShelf.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StoredShelf] by its [id] or null if no such row exists.
  Future<StoredShelf?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StoredShelf>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StoredShelf]s in the list and returns the inserted rows.
  ///
  /// The returned [StoredShelf]s will have their `id` fields set.
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
  Future<List<StoredShelf>> insert(
    _is.DatabaseSession session,
    List<StoredShelf> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StoredShelf>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StoredShelf] and returns the inserted row.
  ///
  /// The returned [StoredShelf] will have its `id` field set.
  Future<StoredShelf> insertRow(
    _is.DatabaseSession session,
    StoredShelf row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StoredShelf>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StoredShelf]s in the list and returns the resulting rows.
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
  /// The returned [StoredShelf]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredShelf>> upsert(
    _is.DatabaseSession session,
    List<StoredShelf> rows, {
    required _is.ColumnSelections<StoredShelfTable> conflictColumns,
    _is.ColumnSelections<StoredShelfTable>? updateColumns,
    _is.WhereExpressionBuilder<StoredShelfTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StoredShelf>(
      rows,
      conflictColumns: conflictColumns(StoredShelf.t),
      updateColumns: updateColumns?.call(StoredShelf.t),
      updateWhere: updateWhere?.call(StoredShelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StoredShelf] and returns the resulting row.
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
  /// The returned [StoredShelf] will have its `id` field set.
  Future<StoredShelf?> upsertRow(
    _is.DatabaseSession session,
    StoredShelf row, {
    required _is.ColumnSelections<StoredShelfTable> conflictColumns,
    _is.ColumnSelections<StoredShelfTable>? updateColumns,
    _is.WhereExpressionBuilder<StoredShelfTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StoredShelf>(
      row,
      conflictColumns: conflictColumns(StoredShelf.t),
      updateColumns: updateColumns?.call(StoredShelf.t),
      updateWhere: updateWhere?.call(StoredShelf.t),
      transaction: transaction,
    );
  }

  /// Updates all [StoredShelf]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredShelf>> update(
    _is.DatabaseSession session,
    List<StoredShelf> rows, {
    _is.ColumnSelections<StoredShelfTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StoredShelf>(
      rows,
      columns: columns?.call(StoredShelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StoredShelf]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StoredShelf> updateRow(
    _is.DatabaseSession session,
    StoredShelf row, {
    _is.ColumnSelections<StoredShelfTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StoredShelf>(
      row,
      columns: columns?.call(StoredShelf.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StoredShelf] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StoredShelf?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<StoredShelfUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StoredShelf>(
      id,
      columnValues: columnValues(StoredShelf.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StoredShelf]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoredShelf>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StoredShelfUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StoredShelfTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoredShelfTable>? orderBy,
    _is.OrderByListBuilder<StoredShelfTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StoredShelf>(
      columnValues: columnValues(StoredShelf.t.updateTable),
      where: where(StoredShelf.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StoredShelf.t),
      orderByList: orderByList?.call(StoredShelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StoredShelf]s in the list and returns the deleted rows.
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
  Future<List<StoredShelf>> delete(
    _is.DatabaseSession session,
    List<StoredShelf> rows, {
    _is.OrderByBuilder<StoredShelfTable>? orderBy,
    _is.OrderByListBuilder<StoredShelfTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StoredShelf>(
      rows,
      orderBy: orderBy?.call(StoredShelf.t),
      orderByList: orderByList?.call(StoredShelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StoredShelf].
  Future<StoredShelf> deleteRow(
    _is.DatabaseSession session,
    StoredShelf row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StoredShelf>(
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
  Future<List<StoredShelf>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StoredShelfTable> where,
    _is.OrderByBuilder<StoredShelfTable>? orderBy,
    _is.OrderByListBuilder<StoredShelfTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StoredShelf>(
      where: where(StoredShelf.t),
      orderBy: orderBy?.call(StoredShelf.t),
      orderByList: orderByList?.call(StoredShelf.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoredShelfTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StoredShelf>(
      where: where?.call(StoredShelf.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StoredShelf] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StoredShelfTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StoredShelf>(
      where: where(StoredShelf.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
