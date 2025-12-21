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
import 'package:social_media_marketing_client/src/protocol/protocol.dart'
    as _i2;

abstract class CampaignGenerationResult implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  bool success;

  Map<String, String>? platformContents;

  String? imagePrompt;

  int? postId;

  String? errorMessage;

  Map<String, double>? metadata;

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
