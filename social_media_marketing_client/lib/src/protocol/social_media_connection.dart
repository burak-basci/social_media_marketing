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

/// Represents a connected social media account.
/// Links organization to their social media platforms via Postiz.
abstract class SocialMediaConnection implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
