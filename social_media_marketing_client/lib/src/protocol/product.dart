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

/// Represents a product associated with a company profile.
/// Products are used to generate targeted marketing content.
abstract class Product implements _i1.SerializableModel {
  Product._({
    this.id,
    required this.companyProfileId,
    required this.name,
    this.description,
    this.targetAudience,
    this.keyFeatures,
    this.category,
    required this.createdAt,
  });

  factory Product({
    int? id,
    required int companyProfileId,
    required String name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
    required DateTime createdAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      companyProfileId: jsonSerialization['companyProfileId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      targetAudience: jsonSerialization['targetAudience'] as String?,
      keyFeatures: jsonSerialization['keyFeatures'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['keyFeatures'],
            ),
      category: jsonSerialization['category'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Reference to the company profile this product belongs to.
  int companyProfileId;

  /// Product name.
  String name;

  /// Optional product description.
  String? description;

  /// Optional target audience information.
  String? targetAudience;

  /// List of key product features.
  List<String>? keyFeatures;

  /// Optional product category.
  String? category;

  /// Timestamp when the product was created.
  DateTime createdAt;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    int? id,
    int? companyProfileId,
    String? name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'companyProfileId': companyProfileId,
      'name': name,
      if (description != null) 'description': description,
      if (targetAudience != null) 'targetAudience': targetAudience,
      if (keyFeatures != null) 'keyFeatures': keyFeatures?.toJson(),
      if (category != null) 'category': category,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    int? id,
    required int companyProfileId,
    required String name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
    required DateTime createdAt,
  }) : super._(
         id: id,
         companyProfileId: companyProfileId,
         name: name,
         description: description,
         targetAudience: targetAudience,
         keyFeatures: keyFeatures,
         category: category,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    int? companyProfileId,
    String? name,
    Object? description = _Undefined,
    Object? targetAudience = _Undefined,
    Object? keyFeatures = _Undefined,
    Object? category = _Undefined,
    DateTime? createdAt,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      companyProfileId: companyProfileId ?? this.companyProfileId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      targetAudience: targetAudience is String?
          ? targetAudience
          : this.targetAudience,
      keyFeatures: keyFeatures is List<String>?
          ? keyFeatures
          : this.keyFeatures?.map((e0) => e0).toList(),
      category: category is String? ? category : this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
