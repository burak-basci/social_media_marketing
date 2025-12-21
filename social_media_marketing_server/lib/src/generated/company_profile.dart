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
import 'product.dart' as _i2;
import 'package:social_media_marketing_server/src/generated/protocol.dart'
    as _i3;

/// Represents a company profile within an organization.
/// Contains brand information and uploaded files for content generation.
abstract class CompanyProfile
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CompanyProfile._({
    this.id,
    required this.organizationId,
    required this.name,
    this.description,
    this.brandVoice,
    this.uploadedFiles,
    this.targetAudience,
    this.industry,
    this.products,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyProfile({
    int? id,
    required int organizationId,
    required String name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
    String? targetAudience,
    String? industry,
    List<_i2.Product>? products,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CompanyProfileImpl;

  factory CompanyProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return CompanyProfile(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      brandVoice: jsonSerialization['brandVoice'] as String?,
      uploadedFiles: jsonSerialization['uploadedFiles'] == null
          ? null
          : _i3.Protocol().deserialize<List<String>>(
              jsonSerialization['uploadedFiles'],
            ),
      targetAudience: jsonSerialization['targetAudience'] as String?,
      industry: jsonSerialization['industry'] as String?,
      products: jsonSerialization['products'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.Product>>(
              jsonSerialization['products'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = CompanyProfileTable();

  static const db = CompanyProfileRepository._();

  @override
  int? id;

  /// Reference to the organization that owns this profile.
  int organizationId;

  /// Company name.
  String name;

  /// Optional company description.
  String? description;

  /// Optional brand voice guidelines for AI content generation.
  String? brandVoice;

  /// List of uploaded file references.
  List<String>? uploadedFiles;

  /// Optional target audience information.
  String? targetAudience;

  /// Optional industry classification.
  String? industry;

  /// List of products associated with this company.
  List<_i2.Product>? products;

  /// Timestamp when the profile was created.
  DateTime createdAt;

  /// Timestamp when the profile was last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CompanyProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CompanyProfile copyWith({
    int? id,
    int? organizationId,
    String? name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
    String? targetAudience,
    String? industry,
    List<_i2.Product>? products,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CompanyProfile',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'name': name,
      if (description != null) 'description': description,
      if (brandVoice != null) 'brandVoice': brandVoice,
      if (uploadedFiles != null) 'uploadedFiles': uploadedFiles?.toJson(),
      if (targetAudience != null) 'targetAudience': targetAudience,
      if (industry != null) 'industry': industry,
      if (products != null)
        'products': products?.toJson(valueToJson: (v) => v.toJson()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CompanyProfile',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'name': name,
      if (description != null) 'description': description,
      if (brandVoice != null) 'brandVoice': brandVoice,
      if (uploadedFiles != null) 'uploadedFiles': uploadedFiles?.toJson(),
      if (targetAudience != null) 'targetAudience': targetAudience,
      if (industry != null) 'industry': industry,
      if (products != null)
        'products': products?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static CompanyProfileInclude include() {
    return CompanyProfileInclude._();
  }

  static CompanyProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<CompanyProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyProfileTable>? orderByList,
    CompanyProfileInclude? include,
  }) {
    return CompanyProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CompanyProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CompanyProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CompanyProfileImpl extends CompanyProfile {
  _CompanyProfileImpl({
    int? id,
    required int organizationId,
    required String name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
    String? targetAudience,
    String? industry,
    List<_i2.Product>? products,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         organizationId: organizationId,
         name: name,
         description: description,
         brandVoice: brandVoice,
         uploadedFiles: uploadedFiles,
         targetAudience: targetAudience,
         industry: industry,
         products: products,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CompanyProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CompanyProfile copyWith({
    Object? id = _Undefined,
    int? organizationId,
    String? name,
    Object? description = _Undefined,
    Object? brandVoice = _Undefined,
    Object? uploadedFiles = _Undefined,
    Object? targetAudience = _Undefined,
    Object? industry = _Undefined,
    Object? products = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CompanyProfile(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      brandVoice: brandVoice is String? ? brandVoice : this.brandVoice,
      uploadedFiles: uploadedFiles is List<String>?
          ? uploadedFiles
          : this.uploadedFiles?.map((e0) => e0).toList(),
      targetAudience: targetAudience is String?
          ? targetAudience
          : this.targetAudience,
      industry: industry is String? ? industry : this.industry,
      products: products is List<_i2.Product>?
          ? products
          : this.products?.map((e0) => e0.copyWith()).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CompanyProfileUpdateTable extends _i1.UpdateTable<CompanyProfileTable> {
  CompanyProfileUpdateTable(super.table);

  _i1.ColumnValue<int, int> organizationId(int value) => _i1.ColumnValue(
    table.organizationId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> brandVoice(String? value) => _i1.ColumnValue(
    table.brandVoice,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> uploadedFiles(
    List<String>? value,
  ) => _i1.ColumnValue(
    table.uploadedFiles,
    value,
  );

  _i1.ColumnValue<String, String> targetAudience(String? value) =>
      _i1.ColumnValue(
        table.targetAudience,
        value,
      );

  _i1.ColumnValue<String, String> industry(String? value) => _i1.ColumnValue(
    table.industry,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class CompanyProfileTable extends _i1.Table<int?> {
  CompanyProfileTable({super.tableRelation})
    : super(tableName: 'company_profile') {
    updateTable = CompanyProfileUpdateTable(this);
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    brandVoice = _i1.ColumnString(
      'brandVoice',
      this,
    );
    uploadedFiles = _i1.ColumnSerializable<List<String>>(
      'uploadedFiles',
      this,
    );
    targetAudience = _i1.ColumnString(
      'targetAudience',
      this,
    );
    industry = _i1.ColumnString(
      'industry',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final CompanyProfileUpdateTable updateTable;

  /// Reference to the organization that owns this profile.
  late final _i1.ColumnInt organizationId;

  /// Company name.
  late final _i1.ColumnString name;

  /// Optional company description.
  late final _i1.ColumnString description;

  /// Optional brand voice guidelines for AI content generation.
  late final _i1.ColumnString brandVoice;

  /// List of uploaded file references.
  late final _i1.ColumnSerializable<List<String>> uploadedFiles;

  /// Optional target audience information.
  late final _i1.ColumnString targetAudience;

  /// Optional industry classification.
  late final _i1.ColumnString industry;

  /// Timestamp when the profile was created.
  late final _i1.ColumnDateTime createdAt;

  /// Timestamp when the profile was last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    organizationId,
    name,
    description,
    brandVoice,
    uploadedFiles,
    targetAudience,
    industry,
    createdAt,
    updatedAt,
  ];
}

class CompanyProfileInclude extends _i1.IncludeObject {
  CompanyProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CompanyProfile.t;
}

class CompanyProfileIncludeList extends _i1.IncludeList {
  CompanyProfileIncludeList._({
    _i1.WhereExpressionBuilder<CompanyProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CompanyProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CompanyProfile.t;
}

class CompanyProfileRepository {
  const CompanyProfileRepository._();

  /// Returns a list of [CompanyProfile]s matching the given query parameters.
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
  Future<List<CompanyProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CompanyProfile>(
      where: where?.call(CompanyProfile.t),
      orderBy: orderBy?.call(CompanyProfile.t),
      orderByList: orderByList?.call(CompanyProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CompanyProfile] matching the given query parameters.
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
  Future<CompanyProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<CompanyProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CompanyProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CompanyProfile>(
      where: where?.call(CompanyProfile.t),
      orderBy: orderBy?.call(CompanyProfile.t),
      orderByList: orderByList?.call(CompanyProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CompanyProfile] by its [id] or null if no such row exists.
  Future<CompanyProfile?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CompanyProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CompanyProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [CompanyProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CompanyProfile>> insert(
    _i1.Session session,
    List<CompanyProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CompanyProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CompanyProfile] and returns the inserted row.
  ///
  /// The returned [CompanyProfile] will have its `id` field set.
  Future<CompanyProfile> insertRow(
    _i1.Session session,
    CompanyProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CompanyProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CompanyProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CompanyProfile>> update(
    _i1.Session session,
    List<CompanyProfile> rows, {
    _i1.ColumnSelections<CompanyProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CompanyProfile>(
      rows,
      columns: columns?.call(CompanyProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CompanyProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CompanyProfile> updateRow(
    _i1.Session session,
    CompanyProfile row, {
    _i1.ColumnSelections<CompanyProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CompanyProfile>(
      row,
      columns: columns?.call(CompanyProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CompanyProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CompanyProfile?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<CompanyProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<CompanyProfile>(
      id,
      columnValues: columnValues(CompanyProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CompanyProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<CompanyProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<CompanyProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<CompanyProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CompanyProfileTable>? orderBy,
    _i1.OrderByListBuilder<CompanyProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<CompanyProfile>(
      columnValues: columnValues(CompanyProfile.t.updateTable),
      where: where(CompanyProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CompanyProfile.t),
      orderByList: orderByList?.call(CompanyProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [CompanyProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CompanyProfile>> delete(
    _i1.Session session,
    List<CompanyProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CompanyProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CompanyProfile].
  Future<CompanyProfile> deleteRow(
    _i1.Session session,
    CompanyProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CompanyProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CompanyProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CompanyProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CompanyProfile>(
      where: where(CompanyProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CompanyProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CompanyProfile>(
      where: where?.call(CompanyProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
