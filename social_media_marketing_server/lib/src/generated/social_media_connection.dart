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

/// Represents a connected social media account.
/// Links organization to their social media platforms via Postiz.
abstract class SocialMediaConnection
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SocialMediaConnection._({
    this.id,
    required this.organizationId,
    required this.platform,
    required this.platformUserId,
    required this.platformUsername,
    required this.postizIntegrationId,
    required this.isActive,
    required this.createdAt,
    this.lastUsed,
  });

  factory SocialMediaConnection({
    int? id,
    required int organizationId,
    required String platform,
    required String platformUserId,
    required String platformUsername,
    required String postizIntegrationId,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastUsed,
  }) = _SocialMediaConnectionImpl;

  factory SocialMediaConnection.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SocialMediaConnection(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      platform: jsonSerialization['platform'] as String,
      platformUserId: jsonSerialization['platformUserId'] as String,
      platformUsername: jsonSerialization['platformUsername'] as String,
      postizIntegrationId: jsonSerialization['postizIntegrationId'] as String,
      isActive: jsonSerialization['isActive'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastUsed: jsonSerialization['lastUsed'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUsed']),
    );
  }

  static final t = SocialMediaConnectionTable();

  static const db = SocialMediaConnectionRepository._();

  @override
  int? id;

  /// Reference to the organization that owns this connection.
  int organizationId;

  /// Platform name: 'x', 'facebook', 'instagram', 'linkedin', or 'pinterest'.
  String platform;

  /// User ID on the social media platform.
  String platformUserId;

  /// Username on the social media platform.
  String platformUsername;

  /// Postiz integration ID for this connection.
  String postizIntegrationId;

  /// Whether this connection is currently active.
  bool isActive;

  /// Timestamp when the connection was created.
  DateTime createdAt;

  /// Optional timestamp when the connection was last used.
  DateTime? lastUsed;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SocialMediaConnection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SocialMediaConnection copyWith({
    int? id,
    int? organizationId,
    String? platform,
    String? platformUserId,
    String? platformUsername,
    String? postizIntegrationId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastUsed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SocialMediaConnection',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'platform': platform,
      'platformUserId': platformUserId,
      'platformUsername': platformUsername,
      'postizIntegrationId': postizIntegrationId,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastUsed != null) 'lastUsed': lastUsed?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SocialMediaConnection',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'platform': platform,
      'platformUserId': platformUserId,
      'platformUsername': platformUsername,
      'postizIntegrationId': postizIntegrationId,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
      if (lastUsed != null) 'lastUsed': lastUsed?.toJson(),
    };
  }

  static SocialMediaConnectionInclude include() {
    return SocialMediaConnectionInclude._();
  }

  static SocialMediaConnectionIncludeList includeList({
    _i1.WhereExpressionBuilder<SocialMediaConnectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SocialMediaConnectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SocialMediaConnectionTable>? orderByList,
    SocialMediaConnectionInclude? include,
  }) {
    return SocialMediaConnectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SocialMediaConnection.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SocialMediaConnection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SocialMediaConnectionImpl extends SocialMediaConnection {
  _SocialMediaConnectionImpl({
    int? id,
    required int organizationId,
    required String platform,
    required String platformUserId,
    required String platformUsername,
    required String postizIntegrationId,
    required bool isActive,
    required DateTime createdAt,
    DateTime? lastUsed,
  }) : super._(
         id: id,
         organizationId: organizationId,
         platform: platform,
         platformUserId: platformUserId,
         platformUsername: platformUsername,
         postizIntegrationId: postizIntegrationId,
         isActive: isActive,
         createdAt: createdAt,
         lastUsed: lastUsed,
       );

  /// Returns a shallow copy of this [SocialMediaConnection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SocialMediaConnection copyWith({
    Object? id = _Undefined,
    int? organizationId,
    String? platform,
    String? platformUserId,
    String? platformUsername,
    String? postizIntegrationId,
    bool? isActive,
    DateTime? createdAt,
    Object? lastUsed = _Undefined,
  }) {
    return SocialMediaConnection(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      platform: platform ?? this.platform,
      platformUserId: platformUserId ?? this.platformUserId,
      platformUsername: platformUsername ?? this.platformUsername,
      postizIntegrationId: postizIntegrationId ?? this.postizIntegrationId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed is DateTime? ? lastUsed : this.lastUsed,
    );
  }
}

class SocialMediaConnectionUpdateTable
    extends _i1.UpdateTable<SocialMediaConnectionTable> {
  SocialMediaConnectionUpdateTable(super.table);

  _i1.ColumnValue<int, int> organizationId(int value) => _i1.ColumnValue(
    table.organizationId,
    value,
  );

  _i1.ColumnValue<String, String> platform(String value) => _i1.ColumnValue(
    table.platform,
    value,
  );

  _i1.ColumnValue<String, String> platformUserId(String value) =>
      _i1.ColumnValue(
        table.platformUserId,
        value,
      );

  _i1.ColumnValue<String, String> platformUsername(String value) =>
      _i1.ColumnValue(
        table.platformUsername,
        value,
      );

  _i1.ColumnValue<String, String> postizIntegrationId(String value) =>
      _i1.ColumnValue(
        table.postizIntegrationId,
        value,
      );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> lastUsed(DateTime? value) =>
      _i1.ColumnValue(
        table.lastUsed,
        value,
      );
}

class SocialMediaConnectionTable extends _i1.Table<int?> {
  SocialMediaConnectionTable({super.tableRelation})
    : super(tableName: 'social_media_connection') {
    updateTable = SocialMediaConnectionUpdateTable(this);
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    platform = _i1.ColumnString(
      'platform',
      this,
    );
    platformUserId = _i1.ColumnString(
      'platformUserId',
      this,
    );
    platformUsername = _i1.ColumnString(
      'platformUsername',
      this,
    );
    postizIntegrationId = _i1.ColumnString(
      'postizIntegrationId',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastUsed = _i1.ColumnDateTime(
      'lastUsed',
      this,
    );
  }

  late final SocialMediaConnectionUpdateTable updateTable;

  /// Reference to the organization that owns this connection.
  late final _i1.ColumnInt organizationId;

  /// Platform name: 'x', 'facebook', 'instagram', 'linkedin', or 'pinterest'.
  late final _i1.ColumnString platform;

  /// User ID on the social media platform.
  late final _i1.ColumnString platformUserId;

  /// Username on the social media platform.
  late final _i1.ColumnString platformUsername;

  /// Postiz integration ID for this connection.
  late final _i1.ColumnString postizIntegrationId;

  /// Whether this connection is currently active.
  late final _i1.ColumnBool isActive;

  /// Timestamp when the connection was created.
  late final _i1.ColumnDateTime createdAt;

  /// Optional timestamp when the connection was last used.
  late final _i1.ColumnDateTime lastUsed;

  @override
  List<_i1.Column> get columns => [
    id,
    organizationId,
    platform,
    platformUserId,
    platformUsername,
    postizIntegrationId,
    isActive,
    createdAt,
    lastUsed,
  ];
}

class SocialMediaConnectionInclude extends _i1.IncludeObject {
  SocialMediaConnectionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SocialMediaConnection.t;
}

class SocialMediaConnectionIncludeList extends _i1.IncludeList {
  SocialMediaConnectionIncludeList._({
    _i1.WhereExpressionBuilder<SocialMediaConnectionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SocialMediaConnection.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SocialMediaConnection.t;
}

class SocialMediaConnectionRepository {
  const SocialMediaConnectionRepository._();

  /// Returns a list of [SocialMediaConnection]s matching the given query parameters.
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
  Future<List<SocialMediaConnection>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SocialMediaConnectionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SocialMediaConnectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SocialMediaConnectionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SocialMediaConnection>(
      where: where?.call(SocialMediaConnection.t),
      orderBy: orderBy?.call(SocialMediaConnection.t),
      orderByList: orderByList?.call(SocialMediaConnection.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SocialMediaConnection] matching the given query parameters.
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
  Future<SocialMediaConnection?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SocialMediaConnectionTable>? where,
    int? offset,
    _i1.OrderByBuilder<SocialMediaConnectionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SocialMediaConnectionTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SocialMediaConnection>(
      where: where?.call(SocialMediaConnection.t),
      orderBy: orderBy?.call(SocialMediaConnection.t),
      orderByList: orderByList?.call(SocialMediaConnection.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SocialMediaConnection] by its [id] or null if no such row exists.
  Future<SocialMediaConnection?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SocialMediaConnection>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SocialMediaConnection]s in the list and returns the inserted rows.
  ///
  /// The returned [SocialMediaConnection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SocialMediaConnection>> insert(
    _i1.Session session,
    List<SocialMediaConnection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SocialMediaConnection>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SocialMediaConnection] and returns the inserted row.
  ///
  /// The returned [SocialMediaConnection] will have its `id` field set.
  Future<SocialMediaConnection> insertRow(
    _i1.Session session,
    SocialMediaConnection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SocialMediaConnection>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SocialMediaConnection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SocialMediaConnection>> update(
    _i1.Session session,
    List<SocialMediaConnection> rows, {
    _i1.ColumnSelections<SocialMediaConnectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SocialMediaConnection>(
      rows,
      columns: columns?.call(SocialMediaConnection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SocialMediaConnection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SocialMediaConnection> updateRow(
    _i1.Session session,
    SocialMediaConnection row, {
    _i1.ColumnSelections<SocialMediaConnectionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SocialMediaConnection>(
      row,
      columns: columns?.call(SocialMediaConnection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SocialMediaConnection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SocialMediaConnection?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SocialMediaConnectionUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SocialMediaConnection>(
      id,
      columnValues: columnValues(SocialMediaConnection.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SocialMediaConnection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SocialMediaConnection>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SocialMediaConnectionUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SocialMediaConnectionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SocialMediaConnectionTable>? orderBy,
    _i1.OrderByListBuilder<SocialMediaConnectionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SocialMediaConnection>(
      columnValues: columnValues(SocialMediaConnection.t.updateTable),
      where: where(SocialMediaConnection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SocialMediaConnection.t),
      orderByList: orderByList?.call(SocialMediaConnection.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SocialMediaConnection]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SocialMediaConnection>> delete(
    _i1.Session session,
    List<SocialMediaConnection> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SocialMediaConnection>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SocialMediaConnection].
  Future<SocialMediaConnection> deleteRow(
    _i1.Session session,
    SocialMediaConnection row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SocialMediaConnection>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SocialMediaConnection>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SocialMediaConnectionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SocialMediaConnection>(
      where: where(SocialMediaConnection.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SocialMediaConnectionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SocialMediaConnection>(
      where: where?.call(SocialMediaConnection.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
