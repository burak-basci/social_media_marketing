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
import 'package:social_media_marketing_server/src/generated/protocol.dart'
    as _i2;

abstract class CampaignGenerationResult
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CampaignGenerationResult._({
    this.id,
    required this.success,
    this.platformContents,
    this.imagePrompt,
    this.postId,
    this.errorMessage,
    this.metadata,
  });

  factory CampaignGenerationResult({
    int? id,
    required bool success,
    Map<String, String>? platformContents,
    String? imagePrompt,
    int? postId,
    String? errorMessage,
    Map<String, double>? metadata,
  }) = _CampaignGenerationResultImpl;

  factory CampaignGenerationResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CampaignGenerationResult(
      id: jsonSerialization['id'] as int?,
      success: jsonSerialization['success'] as bool,
      platformContents: jsonSerialization['platformContents'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['platformContents'],
            ),
      imagePrompt: jsonSerialization['imagePrompt'] as String?,
      postId: jsonSerialization['postId'] as int?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _i2.Protocol().deserialize<Map<String, double>>(
              jsonSerialization['metadata'],
            ),
    );
  }

  static final t = CampaignGenerationResultTable();

  static const db = CampaignGenerationResultRepository._();

  @override
  int? id;

  bool success;

  Map<String, String>? platformContents;

  String? imagePrompt;

  int? postId;

  String? errorMessage;

  Map<String, double>? metadata;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CampaignGenerationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CampaignGenerationResult copyWith({
    int? id,
    bool? success,
    Map<String, String>? platformContents,
    String? imagePrompt,
    int? postId,
    String? errorMessage,
    Map<String, double>? metadata,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampaignGenerationResult',
      if (id != null) 'id': id,
      'success': success,
      if (platformContents != null)
        'platformContents': platformContents?.toJson(),
      if (imagePrompt != null) 'imagePrompt': imagePrompt,
      if (postId != null) 'postId': postId,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (metadata != null) 'metadata': metadata?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampaignGenerationResult',
      if (id != null) 'id': id,
      'success': success,
      if (platformContents != null)
        'platformContents': platformContents?.toJson(),
      if (imagePrompt != null) 'imagePrompt': imagePrompt,
      if (postId != null) 'postId': postId,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (metadata != null) 'metadata': metadata?.toJson(),
    };
  }

  static CampaignGenerationResultInclude include() {
    return CampaignGenerationResultInclude._();
  }

  static CampaignGenerationResultIncludeList includeList({
    _i1.WhereExpressionBuilder<CampaignGenerationResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CampaignGenerationResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CampaignGenerationResultTable>? orderByList,
    CampaignGenerationResultInclude? include,
  }) {
    return CampaignGenerationResultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampaignGenerationResult.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CampaignGenerationResult.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampaignGenerationResultImpl extends CampaignGenerationResult {
  _CampaignGenerationResultImpl({
    int? id,
    required bool success,
    Map<String, String>? platformContents,
    String? imagePrompt,
    int? postId,
    String? errorMessage,
    Map<String, double>? metadata,
  }) : super._(
         id: id,
         success: success,
         platformContents: platformContents,
         imagePrompt: imagePrompt,
         postId: postId,
         errorMessage: errorMessage,
         metadata: metadata,
       );

  /// Returns a shallow copy of this [CampaignGenerationResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CampaignGenerationResult copyWith({
    Object? id = _Undefined,
    bool? success,
    Object? platformContents = _Undefined,
    Object? imagePrompt = _Undefined,
    Object? postId = _Undefined,
    Object? errorMessage = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return CampaignGenerationResult(
      id: id is int? ? id : this.id,
      success: success ?? this.success,
      platformContents: platformContents is Map<String, String>?
          ? platformContents
          : this.platformContents?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      imagePrompt: imagePrompt is String? ? imagePrompt : this.imagePrompt,
      postId: postId is int? ? postId : this.postId,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      metadata: metadata is Map<String, double>?
          ? metadata
          : this.metadata?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
    );
  }
}

class CampaignGenerationResultUpdateTable
    extends _i1.UpdateTable<CampaignGenerationResultTable> {
  CampaignGenerationResultUpdateTable(super.table);

  _i1.ColumnValue<bool, bool> success(bool value) => _i1.ColumnValue(
    table.success,
    value,
  );

  _i1.ColumnValue<Map<String, String>, Map<String, String>> platformContents(
    Map<String, String>? value,
  ) => _i1.ColumnValue(
    table.platformContents,
    value,
  );

  _i1.ColumnValue<String, String> imagePrompt(String? value) => _i1.ColumnValue(
    table.imagePrompt,
    value,
  );

  _i1.ColumnValue<int, int> postId(int? value) => _i1.ColumnValue(
    table.postId,
    value,
  );

  _i1.ColumnValue<String, String> errorMessage(String? value) =>
      _i1.ColumnValue(
        table.errorMessage,
        value,
      );

  _i1.ColumnValue<Map<String, double>, Map<String, double>> metadata(
    Map<String, double>? value,
  ) => _i1.ColumnValue(
    table.metadata,
    value,
  );
}

class CampaignGenerationResultTable extends _i1.Table<int?> {
  CampaignGenerationResultTable({super.tableRelation})
    : super(tableName: 'campaign_generation_results') {
    updateTable = CampaignGenerationResultUpdateTable(this);
    success = _i1.ColumnBool(
      'success',
      this,
    );
    platformContents = _i1.ColumnSerializable<Map<String, String>>(
      'platformContents',
      this,
    );
    imagePrompt = _i1.ColumnString(
      'imagePrompt',
      this,
    );
    postId = _i1.ColumnInt(
      'postId',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
    metadata = _i1.ColumnSerializable<Map<String, double>>(
      'metadata',
      this,
    );
  }

  late final CampaignGenerationResultUpdateTable updateTable;

  late final _i1.ColumnBool success;

  late final _i1.ColumnSerializable<Map<String, String>> platformContents;

  late final _i1.ColumnString imagePrompt;

  late final _i1.ColumnInt postId;

  late final _i1.ColumnString errorMessage;

  late final _i1.ColumnSerializable<Map<String, double>> metadata;

  @override
  List<_i1.Column> get columns => [
    id,
    success,
    platformContents,
    imagePrompt,
    postId,
    errorMessage,
    metadata,
  ];
}

class CampaignGenerationResultInclude extends _i1.IncludeObject {
  CampaignGenerationResultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CampaignGenerationResult.t;
}

class CampaignGenerationResultIncludeList extends _i1.IncludeList {
  CampaignGenerationResultIncludeList._({
    _i1.WhereExpressionBuilder<CampaignGenerationResultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CampaignGenerationResult.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CampaignGenerationResult.t;
}

class CampaignGenerationResultRepository {
  const CampaignGenerationResultRepository._();

  /// Returns a list of [CampaignGenerationResult]s matching the given query parameters.
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
  Future<List<CampaignGenerationResult>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CampaignGenerationResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CampaignGenerationResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CampaignGenerationResultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CampaignGenerationResult>(
      where: where?.call(CampaignGenerationResult.t),
      orderBy: orderBy?.call(CampaignGenerationResult.t),
      orderByList: orderByList?.call(CampaignGenerationResult.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CampaignGenerationResult] matching the given query parameters.
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
  Future<CampaignGenerationResult?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CampaignGenerationResultTable>? where,
    int? offset,
    _i1.OrderByBuilder<CampaignGenerationResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CampaignGenerationResultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CampaignGenerationResult>(
      where: where?.call(CampaignGenerationResult.t),
      orderBy: orderBy?.call(CampaignGenerationResult.t),
      orderByList: orderByList?.call(CampaignGenerationResult.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CampaignGenerationResult] by its [id] or null if no such row exists.
  Future<CampaignGenerationResult?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CampaignGenerationResult>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CampaignGenerationResult]s in the list and returns the inserted rows.
  ///
  /// The returned [CampaignGenerationResult]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CampaignGenerationResult>> insert(
    _i1.Session session,
    List<CampaignGenerationResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CampaignGenerationResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CampaignGenerationResult] and returns the inserted row.
  ///
  /// The returned [CampaignGenerationResult] will have its `id` field set.
  Future<CampaignGenerationResult> insertRow(
    _i1.Session session,
    CampaignGenerationResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CampaignGenerationResult>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CampaignGenerationResult]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CampaignGenerationResult>> update(
    _i1.Session session,
    List<CampaignGenerationResult> rows, {
    _i1.ColumnSelections<CampaignGenerationResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CampaignGenerationResult>(
      rows,
      columns: columns?.call(CampaignGenerationResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CampaignGenerationResult]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CampaignGenerationResult> updateRow(
    _i1.Session session,
    CampaignGenerationResult row, {
    _i1.ColumnSelections<CampaignGenerationResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CampaignGenerationResult>(
      row,
      columns: columns?.call(CampaignGenerationResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CampaignGenerationResult] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CampaignGenerationResult?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CampaignGenerationResultUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CampaignGenerationResult>(
      id,
      columnValues: columnValues(CampaignGenerationResult.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CampaignGenerationResult]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CampaignGenerationResult>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CampaignGenerationResultUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<CampaignGenerationResultTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CampaignGenerationResultTable>? orderBy,
    _i1.OrderByListBuilder<CampaignGenerationResultTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CampaignGenerationResult>(
      columnValues: columnValues(CampaignGenerationResult.t.updateTable),
      where: where(CampaignGenerationResult.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CampaignGenerationResult.t),
      orderByList: orderByList?.call(CampaignGenerationResult.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CampaignGenerationResult]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CampaignGenerationResult>> delete(
    _i1.Session session,
    List<CampaignGenerationResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CampaignGenerationResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CampaignGenerationResult].
  Future<CampaignGenerationResult> deleteRow(
    _i1.Session session,
    CampaignGenerationResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CampaignGenerationResult>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CampaignGenerationResult>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CampaignGenerationResultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CampaignGenerationResult>(
      where: where(CampaignGenerationResult.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CampaignGenerationResultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CampaignGenerationResult>(
      where: where?.call(CampaignGenerationResult.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
