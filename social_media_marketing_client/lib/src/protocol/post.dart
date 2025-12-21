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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Represents a social media post in the platform.
/// Contains AI-generated content and scheduling information.
abstract class Post implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
