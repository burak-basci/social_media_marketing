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

/// Logs all AI interactions for analytics and debugging.
/// Tracks prompts, responses, timing, and costs.
abstract class AIInteractionLog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  AIInteractionLog._({
    this.id,
    this.postId,
    required this.interactionType,
    required this.prompt,
    required this.model,
    required this.parameters,
    required this.rawResponse,
    required this.timingBreakdown,
    required this.success,
    this.errorMessage,
    required this.createdAt,
    this.tokensUsed,
    this.estimatedCostUsd,
  });

  factory AIInteractionLog({
    int? id,
    int? postId,
    required String interactionType,
    required String prompt,
    required String model,
    required String parameters,
    required String rawResponse,
    required String timingBreakdown,
    required bool success,
    String? errorMessage,
    required DateTime createdAt,
    int? tokensUsed,
    double? estimatedCostUsd,
  }) = _AIInteractionLogImpl;

  factory AIInteractionLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AIInteractionLog(
      id: jsonSerialization['id'] as int?,
      postId: jsonSerialization['postId'] as int?,
      interactionType: jsonSerialization['interactionType'] as String,
      prompt: jsonSerialization['prompt'] as String,
      model: jsonSerialization['model'] as String,
      parameters: jsonSerialization['parameters'] as String,
      rawResponse: jsonSerialization['rawResponse'] as String,
      timingBreakdown: jsonSerialization['timingBreakdown'] as String,
      success: jsonSerialization['success'] as bool,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      tokensUsed: jsonSerialization['tokensUsed'] as int?,
      estimatedCostUsd: (jsonSerialization['estimatedCostUsd'] as num?)
          ?.toDouble(),
    );
  }

  static final t = AIInteractionLogTable();

  static const db = AIInteractionLogRepository._();

  @override
  int? id;

  /// Optional reference to the post this interaction is related to.
  int? postId;

  /// Type of interaction: 'initial_generation', 'edit_request', or 'image_generation'.
  String interactionType;

  /// The prompt sent to the AI model.
  String prompt;

  /// The AI model used (e.g., 'gemini-1.5-flash').
  String model;

  /// JSON containing model parameters (temperature, max_tokens, etc.).
  String parameters;

  /// JSON containing the raw AI response.
  String rawResponse;

  /// JSON containing timing breakdown (total_ms, api_call_ms, processing_ms).
  String timingBreakdown;

  /// Whether the interaction was successful.
  bool success;

  /// Optional error message if the interaction failed.
  String? errorMessage;

  /// Timestamp when the interaction occurred.
  DateTime createdAt;

  /// Optional number of tokens used by the AI model.
  int? tokensUsed;

  /// Optional estimated cost in USD.
  double? estimatedCostUsd;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [AIInteractionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AIInteractionLog copyWith({
    int? id,
    int? postId,
    String? interactionType,
    String? prompt,
    String? model,
    String? parameters,
    String? rawResponse,
    String? timingBreakdown,
    bool? success,
    String? errorMessage,
    DateTime? createdAt,
    int? tokensUsed,
    double? estimatedCostUsd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AIInteractionLog',
      if (id != null) 'id': id,
      if (postId != null) 'postId': postId,
      'interactionType': interactionType,
      'prompt': prompt,
      'model': model,
      'parameters': parameters,
      'rawResponse': rawResponse,
      'timingBreakdown': timingBreakdown,
      'success': success,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (tokensUsed != null) 'tokensUsed': tokensUsed,
      if (estimatedCostUsd != null) 'estimatedCostUsd': estimatedCostUsd,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AIInteractionLog',
      if (id != null) 'id': id,
      if (postId != null) 'postId': postId,
      'interactionType': interactionType,
      'prompt': prompt,
      'model': model,
      'parameters': parameters,
      'rawResponse': rawResponse,
      'timingBreakdown': timingBreakdown,
      'success': success,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (tokensUsed != null) 'tokensUsed': tokensUsed,
      if (estimatedCostUsd != null) 'estimatedCostUsd': estimatedCostUsd,
    };
  }

  static AIInteractionLogInclude include() {
    return AIInteractionLogInclude._();
  }

  static AIInteractionLogIncludeList includeList({
    _i1.WhereExpressionBuilder<AIInteractionLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AIInteractionLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AIInteractionLogTable>? orderByList,
    AIInteractionLogInclude? include,
  }) {
    return AIInteractionLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AIInteractionLog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(AIInteractionLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AIInteractionLogImpl extends AIInteractionLog {
  _AIInteractionLogImpl({
    int? id,
    int? postId,
    required String interactionType,
    required String prompt,
    required String model,
    required String parameters,
    required String rawResponse,
    required String timingBreakdown,
    required bool success,
    String? errorMessage,
    required DateTime createdAt,
    int? tokensUsed,
    double? estimatedCostUsd,
  }) : super._(
         id: id,
         postId: postId,
         interactionType: interactionType,
         prompt: prompt,
         model: model,
         parameters: parameters,
         rawResponse: rawResponse,
         timingBreakdown: timingBreakdown,
         success: success,
         errorMessage: errorMessage,
         createdAt: createdAt,
         tokensUsed: tokensUsed,
         estimatedCostUsd: estimatedCostUsd,
       );

  /// Returns a shallow copy of this [AIInteractionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AIInteractionLog copyWith({
    Object? id = _Undefined,
    Object? postId = _Undefined,
    String? interactionType,
    String? prompt,
    String? model,
    String? parameters,
    String? rawResponse,
    String? timingBreakdown,
    bool? success,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    Object? tokensUsed = _Undefined,
    Object? estimatedCostUsd = _Undefined,
  }) {
    return AIInteractionLog(
      id: id is int? ? id : this.id,
      postId: postId is int? ? postId : this.postId,
      interactionType: interactionType ?? this.interactionType,
      prompt: prompt ?? this.prompt,
      model: model ?? this.model,
      parameters: parameters ?? this.parameters,
      rawResponse: rawResponse ?? this.rawResponse,
      timingBreakdown: timingBreakdown ?? this.timingBreakdown,
      success: success ?? this.success,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      tokensUsed: tokensUsed is int? ? tokensUsed : this.tokensUsed,
      estimatedCostUsd: estimatedCostUsd is double?
          ? estimatedCostUsd
          : this.estimatedCostUsd,
    );
  }
}

class AIInteractionLogUpdateTable
    extends _i1.UpdateTable<AIInteractionLogTable> {
  AIInteractionLogUpdateTable(super.table);

  _i1.ColumnValue<int, int> postId(int? value) => _i1.ColumnValue(
    table.postId,
    value,
  );

  _i1.ColumnValue<String, String> interactionType(String value) =>
      _i1.ColumnValue(
        table.interactionType,
        value,
      );

  _i1.ColumnValue<String, String> prompt(String value) => _i1.ColumnValue(
    table.prompt,
    value,
  );

  _i1.ColumnValue<String, String> model(String value) => _i1.ColumnValue(
    table.model,
    value,
  );

  _i1.ColumnValue<String, String> parameters(String value) => _i1.ColumnValue(
    table.parameters,
    value,
  );

  _i1.ColumnValue<String, String> rawResponse(String value) => _i1.ColumnValue(
    table.rawResponse,
    value,
  );

  _i1.ColumnValue<String, String> timingBreakdown(String value) =>
      _i1.ColumnValue(
        table.timingBreakdown,
        value,
      );

  _i1.ColumnValue<bool, bool> success(bool value) => _i1.ColumnValue(
    table.success,
    value,
  );

  _i1.ColumnValue<String, String> errorMessage(String? value) =>
      _i1.ColumnValue(
        table.errorMessage,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> tokensUsed(int? value) => _i1.ColumnValue(
    table.tokensUsed,
    value,
  );

  _i1.ColumnValue<double, double> estimatedCostUsd(double? value) =>
      _i1.ColumnValue(
        table.estimatedCostUsd,
        value,
      );
}

class AIInteractionLogTable extends _i1.Table<int?> {
  AIInteractionLogTable({super.tableRelation})
    : super(tableName: 'ai_interaction_log') {
    updateTable = AIInteractionLogUpdateTable(this);
    postId = _i1.ColumnInt(
      'postId',
      this,
    );
    interactionType = _i1.ColumnString(
      'interactionType',
      this,
    );
    prompt = _i1.ColumnString(
      'prompt',
      this,
    );
    model = _i1.ColumnString(
      'model',
      this,
    );
    parameters = _i1.ColumnString(
      'parameters',
      this,
    );
    rawResponse = _i1.ColumnString(
      'rawResponse',
      this,
    );
    timingBreakdown = _i1.ColumnString(
      'timingBreakdown',
      this,
    );
    success = _i1.ColumnBool(
      'success',
      this,
    );
    errorMessage = _i1.ColumnString(
      'errorMessage',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    tokensUsed = _i1.ColumnInt(
      'tokensUsed',
      this,
    );
    estimatedCostUsd = _i1.ColumnDouble(
      'estimatedCostUsd',
      this,
    );
  }

  late final AIInteractionLogUpdateTable updateTable;

  /// Optional reference to the post this interaction is related to.
  late final _i1.ColumnInt postId;

  /// Type of interaction: 'initial_generation', 'edit_request', or 'image_generation'.
  late final _i1.ColumnString interactionType;

  /// The prompt sent to the AI model.
  late final _i1.ColumnString prompt;

  /// The AI model used (e.g., 'gemini-1.5-flash').
  late final _i1.ColumnString model;

  /// JSON containing model parameters (temperature, max_tokens, etc.).
  late final _i1.ColumnString parameters;

  /// JSON containing the raw AI response.
  late final _i1.ColumnString rawResponse;

  /// JSON containing timing breakdown (total_ms, api_call_ms, processing_ms).
  late final _i1.ColumnString timingBreakdown;

  /// Whether the interaction was successful.
  late final _i1.ColumnBool success;

  /// Optional error message if the interaction failed.
  late final _i1.ColumnString errorMessage;

  /// Timestamp when the interaction occurred.
  late final _i1.ColumnDateTime createdAt;

  /// Optional number of tokens used by the AI model.
  late final _i1.ColumnInt tokensUsed;

  /// Optional estimated cost in USD.
  late final _i1.ColumnDouble estimatedCostUsd;

  @override
  List<_i1.Column> get columns => [
    id,
    postId,
    interactionType,
    prompt,
    model,
    parameters,
    rawResponse,
    timingBreakdown,
    success,
    errorMessage,
    createdAt,
    tokensUsed,
    estimatedCostUsd,
  ];
}

class AIInteractionLogInclude extends _i1.IncludeObject {
  AIInteractionLogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => AIInteractionLog.t;
}

class AIInteractionLogIncludeList extends _i1.IncludeList {
  AIInteractionLogIncludeList._({
    _i1.WhereExpressionBuilder<AIInteractionLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AIInteractionLog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => AIInteractionLog.t;
}

class AIInteractionLogRepository {
  const AIInteractionLogRepository._();

  /// Returns a list of [AIInteractionLog]s matching the given query parameters.
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
  Future<List<AIInteractionLog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AIInteractionLogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AIInteractionLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AIInteractionLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<AIInteractionLog>(
      where: where?.call(AIInteractionLog.t),
      orderBy: orderBy?.call(AIInteractionLog.t),
      orderByList: orderByList?.call(AIInteractionLog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [AIInteractionLog] matching the given query parameters.
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
  Future<AIInteractionLog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AIInteractionLogTable>? where,
    int? offset,
    _i1.OrderByBuilder<AIInteractionLogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<AIInteractionLogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<AIInteractionLog>(
      where: where?.call(AIInteractionLog.t),
      orderBy: orderBy?.call(AIInteractionLog.t),
      orderByList: orderByList?.call(AIInteractionLog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [AIInteractionLog] by its [id] or null if no such row exists.
  Future<AIInteractionLog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<AIInteractionLog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [AIInteractionLog]s in the list and returns the inserted rows.
  ///
  /// The returned [AIInteractionLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<AIInteractionLog>> insert(
    _i1.Session session,
    List<AIInteractionLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<AIInteractionLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [AIInteractionLog] and returns the inserted row.
  ///
  /// The returned [AIInteractionLog] will have its `id` field set.
  Future<AIInteractionLog> insertRow(
    _i1.Session session,
    AIInteractionLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<AIInteractionLog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [AIInteractionLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<AIInteractionLog>> update(
    _i1.Session session,
    List<AIInteractionLog> rows, {
    _i1.ColumnSelections<AIInteractionLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<AIInteractionLog>(
      rows,
      columns: columns?.call(AIInteractionLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AIInteractionLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AIInteractionLog> updateRow(
    _i1.Session session,
    AIInteractionLog row, {
    _i1.ColumnSelections<AIInteractionLogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<AIInteractionLog>(
      row,
      columns: columns?.call(AIInteractionLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AIInteractionLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AIInteractionLog?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<AIInteractionLogUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<AIInteractionLog>(
      id,
      columnValues: columnValues(AIInteractionLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AIInteractionLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<AIInteractionLog>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<AIInteractionLogUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<AIInteractionLogTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<AIInteractionLogTable>? orderBy,
    _i1.OrderByListBuilder<AIInteractionLogTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<AIInteractionLog>(
      columnValues: columnValues(AIInteractionLog.t.updateTable),
      where: where(AIInteractionLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AIInteractionLog.t),
      orderByList: orderByList?.call(AIInteractionLog.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [AIInteractionLog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<AIInteractionLog>> delete(
    _i1.Session session,
    List<AIInteractionLog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<AIInteractionLog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [AIInteractionLog].
  Future<AIInteractionLog> deleteRow(
    _i1.Session session,
    AIInteractionLog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AIInteractionLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<AIInteractionLog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<AIInteractionLogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<AIInteractionLog>(
      where: where(AIInteractionLog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<AIInteractionLogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<AIInteractionLog>(
      where: where?.call(AIInteractionLog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
