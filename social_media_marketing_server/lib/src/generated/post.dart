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

/// Represents a social media post in the platform.
/// Contains AI-generated content and scheduling information.
abstract class Post implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Post._({
    this.id,
    required this.organizationId,
    required this.userId,
    required this.companyProfileId,
    this.productId,
    required this.title,
    required this.userPrompt,
    required this.aiGeneratedContent,
    this.editedContent,
    required this.selectedPlatforms,
    required this.status,
    this.scheduleTime,
    this.postizPostId,
    this.postizWebhookData,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  factory Post({
    int? id,
    required int organizationId,
    required int userId,
    required int companyProfileId,
    int? productId,
    required String title,
    required String userPrompt,
    required String aiGeneratedContent,
    String? editedContent,
    required String selectedPlatforms,
    required String status,
    DateTime? scheduleTime,
    String? postizPostId,
    String? postizWebhookData,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? publishedAt,
  }) = _PostImpl;

  factory Post.fromJson(Map<String, dynamic> jsonSerialization) {
    return Post(
      id: jsonSerialization['id'] as int?,
      organizationId: jsonSerialization['organizationId'] as int,
      userId: jsonSerialization['userId'] as int,
      companyProfileId: jsonSerialization['companyProfileId'] as int,
      productId: jsonSerialization['productId'] as int?,
      title: jsonSerialization['title'] as String,
      userPrompt: jsonSerialization['userPrompt'] as String,
      aiGeneratedContent: jsonSerialization['aiGeneratedContent'] as String,
      editedContent: jsonSerialization['editedContent'] as String?,
      selectedPlatforms: jsonSerialization['selectedPlatforms'] as String,
      status: jsonSerialization['status'] as String,
      scheduleTime: jsonSerialization['scheduleTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduleTime'],
            ),
      postizPostId: jsonSerialization['postizPostId'] as String?,
      postizWebhookData: jsonSerialization['postizWebhookData'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['publishedAt'],
            ),
    );
  }

  static final t = PostTable();

  static const db = PostRepository._();

  @override
  int? id;

  /// Reference to the organization that owns this post.
  int organizationId;

  /// Reference to the user who created this post.
  int userId;

  /// Reference to the company profile this post is for.
  int companyProfileId;

  /// Optional reference to a specific product.
  int? productId;

  /// Post title.
  String title;

  /// Original user prompt for content generation.
  String userPrompt;

  /// JSON containing AI-generated content for different platforms.
  String aiGeneratedContent;

  /// Optional JSON containing user-edited content.
  String? editedContent;

  /// JSON array of selected social media platforms.
  String selectedPlatforms;

  /// Post status: 'draft', 'scheduled', 'publishing', 'published', or 'failed'.
  String status;

  /// Optional scheduled publish time.
  DateTime? scheduleTime;

  /// Optional Postiz post ID after scheduling.
  String? postizPostId;

  /// Optional JSON data from Postiz webhook.
  String? postizWebhookData;

  /// Timestamp when the post was created.
  DateTime createdAt;

  /// Timestamp when the post was last updated.
  DateTime updatedAt;

  /// Optional timestamp when the post was published.
  DateTime? publishedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Post]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Post copyWith({
    int? id,
    int? organizationId,
    int? userId,
    int? companyProfileId,
    int? productId,
    String? title,
    String? userPrompt,
    String? aiGeneratedContent,
    String? editedContent,
    String? selectedPlatforms,
    String? status,
    DateTime? scheduleTime,
    String? postizPostId,
    String? postizWebhookData,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Post',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'userId': userId,
      'companyProfileId': companyProfileId,
      if (productId != null) 'productId': productId,
      'title': title,
      'userPrompt': userPrompt,
      'aiGeneratedContent': aiGeneratedContent,
      if (editedContent != null) 'editedContent': editedContent,
      'selectedPlatforms': selectedPlatforms,
      'status': status,
      if (scheduleTime != null) 'scheduleTime': scheduleTime?.toJson(),
      if (postizPostId != null) 'postizPostId': postizPostId,
      if (postizWebhookData != null) 'postizWebhookData': postizWebhookData,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Post',
      if (id != null) 'id': id,
      'organizationId': organizationId,
      'userId': userId,
      'companyProfileId': companyProfileId,
      if (productId != null) 'productId': productId,
      'title': title,
      'userPrompt': userPrompt,
      'aiGeneratedContent': aiGeneratedContent,
      if (editedContent != null) 'editedContent': editedContent,
      'selectedPlatforms': selectedPlatforms,
      'status': status,
      if (scheduleTime != null) 'scheduleTime': scheduleTime?.toJson(),
      if (postizPostId != null) 'postizPostId': postizPostId,
      if (postizWebhookData != null) 'postizWebhookData': postizWebhookData,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
    };
  }

  static PostInclude include() {
    return PostInclude._();
  }

  static PostIncludeList includeList({
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    PostInclude? include,
  }) {
    return PostIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Post.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Post.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PostImpl extends Post {
  _PostImpl({
    int? id,
    required int organizationId,
    required int userId,
    required int companyProfileId,
    int? productId,
    required String title,
    required String userPrompt,
    required String aiGeneratedContent,
    String? editedContent,
    required String selectedPlatforms,
    required String status,
    DateTime? scheduleTime,
    String? postizPostId,
    String? postizWebhookData,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? publishedAt,
  }) : super._(
         id: id,
         organizationId: organizationId,
         userId: userId,
         companyProfileId: companyProfileId,
         productId: productId,
         title: title,
         userPrompt: userPrompt,
         aiGeneratedContent: aiGeneratedContent,
         editedContent: editedContent,
         selectedPlatforms: selectedPlatforms,
         status: status,
         scheduleTime: scheduleTime,
         postizPostId: postizPostId,
         postizWebhookData: postizWebhookData,
         createdAt: createdAt,
         updatedAt: updatedAt,
         publishedAt: publishedAt,
       );

  /// Returns a shallow copy of this [Post]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Post copyWith({
    Object? id = _Undefined,
    int? organizationId,
    int? userId,
    int? companyProfileId,
    Object? productId = _Undefined,
    String? title,
    String? userPrompt,
    String? aiGeneratedContent,
    Object? editedContent = _Undefined,
    String? selectedPlatforms,
    String? status,
    Object? scheduleTime = _Undefined,
    Object? postizPostId = _Undefined,
    Object? postizWebhookData = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? publishedAt = _Undefined,
  }) {
    return Post(
      id: id is int? ? id : this.id,
      organizationId: organizationId ?? this.organizationId,
      userId: userId ?? this.userId,
      companyProfileId: companyProfileId ?? this.companyProfileId,
      productId: productId is int? ? productId : this.productId,
      title: title ?? this.title,
      userPrompt: userPrompt ?? this.userPrompt,
      aiGeneratedContent: aiGeneratedContent ?? this.aiGeneratedContent,
      editedContent: editedContent is String?
          ? editedContent
          : this.editedContent,
      selectedPlatforms: selectedPlatforms ?? this.selectedPlatforms,
      status: status ?? this.status,
      scheduleTime: scheduleTime is DateTime?
          ? scheduleTime
          : this.scheduleTime,
      postizPostId: postizPostId is String? ? postizPostId : this.postizPostId,
      postizWebhookData: postizWebhookData is String?
          ? postizWebhookData
          : this.postizWebhookData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt is DateTime? ? publishedAt : this.publishedAt,
    );
  }
}

class PostUpdateTable extends _i1.UpdateTable<PostTable> {
  PostUpdateTable(super.table);

  _i1.ColumnValue<int, int> organizationId(int value) => _i1.ColumnValue(
    table.organizationId,
    value,
  );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<int, int> companyProfileId(int value) => _i1.ColumnValue(
    table.companyProfileId,
    value,
  );

  _i1.ColumnValue<int, int> productId(int? value) => _i1.ColumnValue(
    table.productId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> userPrompt(String value) => _i1.ColumnValue(
    table.userPrompt,
    value,
  );

  _i1.ColumnValue<String, String> aiGeneratedContent(String value) =>
      _i1.ColumnValue(
        table.aiGeneratedContent,
        value,
      );

  _i1.ColumnValue<String, String> editedContent(String? value) =>
      _i1.ColumnValue(
        table.editedContent,
        value,
      );

  _i1.ColumnValue<String, String> selectedPlatforms(String value) =>
      _i1.ColumnValue(
        table.selectedPlatforms,
        value,
      );

  _i1.ColumnValue<String, String> status(String value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> scheduleTime(DateTime? value) =>
      _i1.ColumnValue(
        table.scheduleTime,
        value,
      );

  _i1.ColumnValue<String, String> postizPostId(String? value) =>
      _i1.ColumnValue(
        table.postizPostId,
        value,
      );

  _i1.ColumnValue<String, String> postizWebhookData(String? value) =>
      _i1.ColumnValue(
        table.postizWebhookData,
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

  _i1.ColumnValue<DateTime, DateTime> publishedAt(DateTime? value) =>
      _i1.ColumnValue(
        table.publishedAt,
        value,
      );
}

class PostTable extends _i1.Table<int?> {
  PostTable({super.tableRelation}) : super(tableName: 'post') {
    updateTable = PostUpdateTable(this);
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    companyProfileId = _i1.ColumnInt(
      'companyProfileId',
      this,
    );
    productId = _i1.ColumnInt(
      'productId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    userPrompt = _i1.ColumnString(
      'userPrompt',
      this,
    );
    aiGeneratedContent = _i1.ColumnString(
      'aiGeneratedContent',
      this,
    );
    editedContent = _i1.ColumnString(
      'editedContent',
      this,
    );
    selectedPlatforms = _i1.ColumnString(
      'selectedPlatforms',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    scheduleTime = _i1.ColumnDateTime(
      'scheduleTime',
      this,
    );
    postizPostId = _i1.ColumnString(
      'postizPostId',
      this,
    );
    postizWebhookData = _i1.ColumnString(
      'postizWebhookData',
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
    publishedAt = _i1.ColumnDateTime(
      'publishedAt',
      this,
    );
  }

  late final PostUpdateTable updateTable;

  /// Reference to the organization that owns this post.
  late final _i1.ColumnInt organizationId;

  /// Reference to the user who created this post.
  late final _i1.ColumnInt userId;

  /// Reference to the company profile this post is for.
  late final _i1.ColumnInt companyProfileId;

  /// Optional reference to a specific product.
  late final _i1.ColumnInt productId;

  /// Post title.
  late final _i1.ColumnString title;

  /// Original user prompt for content generation.
  late final _i1.ColumnString userPrompt;

  /// JSON containing AI-generated content for different platforms.
  late final _i1.ColumnString aiGeneratedContent;

  /// Optional JSON containing user-edited content.
  late final _i1.ColumnString editedContent;

  /// JSON array of selected social media platforms.
  late final _i1.ColumnString selectedPlatforms;

  /// Post status: 'draft', 'scheduled', 'publishing', 'published', or 'failed'.
  late final _i1.ColumnString status;

  /// Optional scheduled publish time.
  late final _i1.ColumnDateTime scheduleTime;

  /// Optional Postiz post ID after scheduling.
  late final _i1.ColumnString postizPostId;

  /// Optional JSON data from Postiz webhook.
  late final _i1.ColumnString postizWebhookData;

  /// Timestamp when the post was created.
  late final _i1.ColumnDateTime createdAt;

  /// Timestamp when the post was last updated.
  late final _i1.ColumnDateTime updatedAt;

  /// Optional timestamp when the post was published.
  late final _i1.ColumnDateTime publishedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    organizationId,
    userId,
    companyProfileId,
    productId,
    title,
    userPrompt,
    aiGeneratedContent,
    editedContent,
    selectedPlatforms,
    status,
    scheduleTime,
    postizPostId,
    postizWebhookData,
    createdAt,
    updatedAt,
    publishedAt,
  ];
}

class PostInclude extends _i1.IncludeObject {
  PostInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Post.t;
}

class PostIncludeList extends _i1.IncludeList {
  PostIncludeList._({
    _i1.WhereExpressionBuilder<PostTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Post.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Post.t;
}

class PostRepository {
  const PostRepository._();

  /// Returns a list of [Post]s matching the given query parameters.
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
  Future<List<Post>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Post] matching the given query parameters.
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
  Future<Post?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Post>(
      where: where?.call(Post.t),
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Post] by its [id] or null if no such row exists.
  Future<Post?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Post>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Post]s in the list and returns the inserted rows.
  ///
  /// The returned [Post]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Post>> insert(
    _i1.Session session,
    List<Post> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Post>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Post] and returns the inserted row.
  ///
  /// The returned [Post] will have its `id` field set.
  Future<Post> insertRow(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Post>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Post]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Post>> update(
    _i1.Session session,
    List<Post> rows, {
    _i1.ColumnSelections<PostTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Post>(
      rows,
      columns: columns?.call(Post.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Post]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Post> updateRow(
    _i1.Session session,
    Post row, {
    _i1.ColumnSelections<PostTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Post>(
      row,
      columns: columns?.call(Post.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Post] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Post?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<PostUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Post>(
      id,
      columnValues: columnValues(Post.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Post]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Post>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<PostUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PostTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PostTable>? orderBy,
    _i1.OrderByListBuilder<PostTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Post>(
      columnValues: columnValues(Post.t.updateTable),
      where: where(Post.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Post.t),
      orderByList: orderByList?.call(Post.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Post]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Post>> delete(
    _i1.Session session,
    List<Post> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Post>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Post].
  Future<Post> deleteRow(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Post>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Post>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PostTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Post>(
      where: where(Post.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PostTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Post>(
      where: where?.call(Post.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
