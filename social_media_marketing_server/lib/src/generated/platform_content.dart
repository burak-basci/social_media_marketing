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
import 'package:serverpod/serverpod.dart' as _i1;

abstract class PlatformContent
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  PlatformContent._({
    this.id,
    required this.platform,
    this.content,
    required this.status,
    this.errorMessage,
    this.characterCount,
    this.generatedAt,
  });

  factory PlatformContent({
    int? id,
    required String platform,
    String? content,
    required String status,
    String? errorMessage,
    int? characterCount,
    DateTime? generatedAt,
  }) = _PlatformContentImpl;

  factory PlatformContent.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlatformContent(
      id: jsonSerialization['id'] as int?,
      platform: jsonSerialization['platform'] as String,
      content: jsonSerialization['content'] as String?,
      status: jsonSerialization['status'] as String,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      characterCount: jsonSerialization['characterCount'] as int?,
      generatedAt: jsonSerialization['generatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['generatedAt'],
            ),
    );
  }

  static final t = PlatformContentTable();

  static const db = PlatformContentRepository._();

  @override
  int? id;

  String platform;

  String? content;

  String status;

  String? errorMessage;

  int? characterCount;

  DateTime? generatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [PlatformContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlatformContent copyWith({
    int? id,
    String? platform,
    String? content,
    String? status,
    String? errorMessage,
    int? characterCount,
    DateTime? generatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlatformContent',
      if (id != null) 'id': id,
      'platform': platform,
      if (content != null) 'content': content,
      'status': status,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (characterCount != null) 'characterCount': characterCount,
      if (generatedAt != null) 'generatedAt': generatedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlatformContent',
      if (id != null) 'id': id,
      'platform': platform,
      if (content != null) 'content': content,
      'status': status,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (characterCount != null) 'characterCount': characterCount,
      if (generatedAt != null) 'generatedAt': generatedAt?.toJson(),
    };
  }

  static PlatformContentInclude include() {
    return PlatformContentInclude._();
  }

  static PlatformContentIncludeList includeList({
    _i1.WhereExpressionBuilder<PlatformContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlatformContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlatformContentTable>? orderByList,
    PlatformContentInclude? include,
  }) {
    return PlatformContentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlatformContent.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PlatformContent.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PlatformContentImpl extends PlatformContent {
  _PlatformContentImpl({
    int? id,
    required String platform,
    String? content,
    required String status,
    String? errorMessage,
    int? characterCount,
    DateTime? generatedAt,
  }) : super._(
         id: id,
         platform: platform,
         content: content,
         status: status,
         errorMessage: errorMessage,
         characterCount: characterCount,
         generatedAt: generatedAt,
       );

  /// Returns a shallow copy of this [PlatformContent]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlatformContent copyWith({
    Object? id = _Undefined,
    String? platform,
    Object? content = _Undefined,
    String? status,
    Object? errorMessage = _Undefined,
    Object? characterCount = _Undefined,
    Object? generatedAt = _Undefined,
  }) {
    return PlatformContent(
      id: id is int? ? id : this.id,
      platform: platform ?? this.platform,
      content: content is String? ? content : this.content,
      status: status ?? this.status,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      characterCount: characterCount is int?
          ? characterCount
          : this.characterCount,
      generatedAt: generatedAt is DateTime? ? generatedAt : this.generatedAt,
    );
  }
}

class PlatformContentUpdateTable extends _i1.UpdateTable<PlatformContentTable> {
  PlatformContentUpdateTable(super.table);

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> content(String? value) => _i1.ColumnValue(
    table.content,
    value,
  );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<String, String> errorMessage(String? value) =>
      _i1.ColumnValue(
        table.errorMessage,
        value,
      );

  _i1.ColumnValue<int, int> characterCount(int? value) => _i1.ColumnValue(
    table.characterCount,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> generatedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.generatedAt,
        value,
      );
}

class PlatformContentTable extends _i1.Table<int?> {
  PlatformContentTable({super.tableRelation})
    : super(tableName: 'platform_contents') {
    updateTable = PlatformContentUpdateTable(this);
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
    characterCount = _i1.ColumnInt(
      'characterCount',
      this,
    );
    generatedAt = _i1.ColumnDateTime(
      'generatedAt',
      this,
    );
  }

  late final PlatformContentUpdateTable updateTable;

  late final _i1.ColumnString platform;

  late final _i1.ColumnString content;

  late final _i1.ColumnString status;

  late final _i1.ColumnString errorMessage;

  late final _i1.ColumnInt characterCount;

  late final _i1.ColumnDateTime generatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    platform,
    content,
    status,
    errorMessage,
    characterCount,
    generatedAt,
  ];
}

class PlatformContentInclude extends _i1.IncludeObject {
  PlatformContentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PlatformContent.t;
}

class PlatformContentIncludeList extends _i1.IncludeList {
  PlatformContentIncludeList._({
    _i1.WhereExpressionBuilder<PlatformContentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PlatformContent.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PlatformContent.t;
}

class PlatformContentRepository {
  const PlatformContentRepository._();

  /// Returns a list of [PlatformContent]s matching the given query parameters.
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
  Future<List<PlatformContent>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlatformContentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlatformContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlatformContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PlatformContent>(
      where: where?.call(PlatformContent.t),
      orderBy: orderBy?.call(PlatformContent.t),
      orderByList: orderByList?.call(PlatformContent.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PlatformContent] matching the given query parameters.
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
  Future<PlatformContent?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlatformContentTable>? where,
    int? offset,
    _i1.OrderByBuilder<PlatformContentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PlatformContentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PlatformContent>(
      where: where?.call(PlatformContent.t),
      orderBy: orderBy?.call(PlatformContent.t),
      orderByList: orderByList?.call(PlatformContent.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PlatformContent] by its [id] or null if no such row exists.
  Future<PlatformContent?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PlatformContent>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PlatformContent]s in the list and returns the inserted rows.
  ///
  /// The returned [PlatformContent]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PlatformContent>> insert(
    _i1.Session session,
    List<PlatformContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PlatformContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PlatformContent] and returns the inserted row.
  ///
  /// The returned [PlatformContent] will have its `id` field set.
  Future<PlatformContent> insertRow(
    _i1.Session session,
    PlatformContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PlatformContent>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PlatformContent]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PlatformContent>> update(
    _i1.Session session,
    List<PlatformContent> rows, {
    _i1.ColumnSelections<PlatformContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PlatformContent>(
      rows,
      columns: columns?.call(PlatformContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlatformContent]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PlatformContent> updateRow(
    _i1.Session session,
    PlatformContent row, {
    _i1.ColumnSelections<PlatformContentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PlatformContent>(
      row,
      columns: columns?.call(PlatformContent.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PlatformContent] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PlatformContent?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PlatformContentUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PlatformContent>(
      id,
      columnValues: columnValues(PlatformContent.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PlatformContent]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PlatformContent>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PlatformContentUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<PlatformContentTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PlatformContentTable>? orderBy,
    _i1.OrderByListBuilder<PlatformContentTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PlatformContent>(
      columnValues: columnValues(PlatformContent.t.updateTable),
      where: where(PlatformContent.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PlatformContent.t),
      orderByList: orderByList?.call(PlatformContent.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PlatformContent]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PlatformContent>> delete(
    _i1.Session session,
    List<PlatformContent> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PlatformContent>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PlatformContent].
  Future<PlatformContent> deleteRow(
    _i1.Session session,
    PlatformContent row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PlatformContent>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PlatformContent>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PlatformContentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PlatformContent>(
      where: where(PlatformContent.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PlatformContentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PlatformContent>(
      where: where?.call(PlatformContent.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
