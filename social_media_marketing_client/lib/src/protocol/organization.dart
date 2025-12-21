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

/// Represents an organization in the platform.
/// Organizations have their own API keys and settings.
abstract class Organization implements _i1.SerializableModel {
  Organization._({
    this.id,
    required this.name,
    required this.postizApiKey,
    this.geminiApiKey,
    required this.settings,
    required this.createdAt,
  });

  factory Organization({
    int? id,
    required String name,
    required String postizApiKey,
    String? geminiApiKey,
    required String settings,
    required DateTime createdAt,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      postizApiKey: jsonSerialization['postizApiKey'] as String,
      geminiApiKey: jsonSerialization['geminiApiKey'] as String?,
      settings: jsonSerialization['settings'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Name of the organization.
  String name;

  /// Postiz API key for social media posting (encrypted in application logic).
  String postizApiKey;

  /// Optional Gemini API key for AI content generation (encrypted in application logic).
  String? geminiApiKey;

  /// JSON serialized organization settings.
  String settings;

  /// Timestamp when the organization was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Organization copyWith({
    int? id,
    String? name,
    String? postizApiKey,
    String? geminiApiKey,
    String? settings,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Organization',
      if (id != null) 'id': id,
      'name': name,
      'postizApiKey': postizApiKey,
      if (geminiApiKey != null) 'geminiApiKey': geminiApiKey,
      'settings': settings,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    required String postizApiKey,
    String? geminiApiKey,
    required String settings,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         postizApiKey: postizApiKey,
         geminiApiKey: geminiApiKey,
         settings: settings,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Organization copyWith({
    Object? id = _Undefined,
    String? name,
    String? postizApiKey,
    Object? geminiApiKey = _Undefined,
    String? settings,
    DateTime? createdAt,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      postizApiKey: postizApiKey ?? this.postizApiKey,
      geminiApiKey: geminiApiKey is String? ? geminiApiKey : this.geminiApiKey,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
