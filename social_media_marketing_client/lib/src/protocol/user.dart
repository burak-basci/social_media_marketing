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

/// Represents a user in the social media marketing platform.
/// Each user belongs to an organization and has a specific role.
abstract class User implements _i1.SerializableModel {
  User._({
    this.id,
    required this.email,
    required this.passwordHash,
    required this.fullName,
    required this.organizationId,
    required this.role,
    required this.createdAt,
    required this.isActive,
  });

  factory User({
    int? id,
    required String email,
    required String passwordHash,
    required String fullName,
    required int organizationId,
    required String role,
    required DateTime createdAt,
    required bool isActive,
  }) = _UserImpl;

  factory User.fromJson(Map<String, dynamic> jsonSerialization) {
    return User(
      id: jsonSerialization['id'] as int?,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      fullName: jsonSerialization['fullName'] as String,
      organizationId: jsonSerialization['organizationId'] as int,
      role: jsonSerialization['role'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Unique email address for the user.
  String email;

  /// Hashed password for authentication.
  String passwordHash;

  /// Full name of the user.
  String fullName;

  /// Reference to the organization this user belongs to.
  int organizationId;

  /// User role: 'admin' or 'user'.
  String role;

  /// Timestamp when the user was created.
  DateTime createdAt;

  /// Whether the user account is active.
  bool isActive;

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  User copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? fullName,
    int? organizationId,
    String? role,
    DateTime? createdAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'User',
      if (id != null) 'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'fullName': fullName,
      'organizationId': organizationId,
      'role': role,
      'createdAt': createdAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserImpl extends User {
  _UserImpl({
    int? id,
    required String email,
    required String passwordHash,
    required String fullName,
    required int organizationId,
    required String role,
    required DateTime createdAt,
    required bool isActive,
  }) : super._(
         id: id,
         email: email,
         passwordHash: passwordHash,
         fullName: fullName,
         organizationId: organizationId,
         role: role,
         createdAt: createdAt,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [User]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  User copyWith({
    Object? id = _Undefined,
    String? email,
    String? passwordHash,
    String? fullName,
    int? organizationId,
    String? role,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return User(
      id: id is int? ? id : this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      fullName: fullName ?? this.fullName,
      organizationId: organizationId ?? this.organizationId,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
