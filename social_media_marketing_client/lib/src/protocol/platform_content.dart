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

abstract class PlatformContent implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String platform;

  String? content;

  String status;

  String? errorMessage;

  int? characterCount;

  DateTime? generatedAt;

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
