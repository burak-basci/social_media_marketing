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
import 'product.dart' as _i2;
import 'package:social_media_marketing_client/src/protocol/protocol.dart'
    as _i3;

/// Represents a company profile within an organization.
/// Contains brand information and uploaded files for content generation.
abstract class CompanyProfile implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
