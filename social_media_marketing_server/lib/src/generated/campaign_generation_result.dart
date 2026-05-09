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
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CampaignGenerationResult._({
    required this.success,
    this.platformContents,
    this.imagePrompt,
    this.postId,
    this.errorMessage,
    this.metadata,
  });

  factory CampaignGenerationResult({
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
    required bool success,
    Map<String, String>? platformContents,
    String? imagePrompt,
    int? postId,
    String? errorMessage,
    Map<String, double>? metadata,
  }) : super._(
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
    bool? success,
    Object? platformContents = _Undefined,
    Object? imagePrompt = _Undefined,
    Object? postId = _Undefined,
    Object? errorMessage = _Undefined,
    Object? metadata = _Undefined,
  }) {
    return CampaignGenerationResult(
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
