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
import 'ai_interaction_log.dart' as _i2;
import 'campaign_generation_result.dart' as _i3;
import 'company_profile.dart' as _i4;
import 'greetings/greeting.dart' as _i5;
import 'organization.dart' as _i6;
import 'platform_content.dart' as _i7;
import 'post.dart' as _i8;
import 'product.dart' as _i9;
import 'social_media_connection.dart' as _i10;
import 'user.dart' as _i11;
import 'package:social_media_marketing_client/src/protocol/ai_interaction_log.dart'
    as _i12;
import 'package:social_media_marketing_client/src/protocol/company_profile.dart'
    as _i13;
import 'package:social_media_marketing_client/src/protocol/product.dart'
    as _i14;
import 'package:social_media_marketing_client/src/protocol/social_media_connection.dart'
    as _i15;
import 'package:social_media_marketing_client/src/protocol/post.dart' as _i16;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i17;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i18;
export 'ai_interaction_log.dart';
export 'campaign_generation_result.dart';
export 'company_profile.dart';
export 'greetings/greeting.dart';
export 'organization.dart';
export 'platform_content.dart';
export 'post.dart';
export 'product.dart';
export 'social_media_connection.dart';
export 'user.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AIInteractionLog) {
      return _i2.AIInteractionLog.fromJson(data) as T;
    }
    if (t == _i3.CampaignGenerationResult) {
      return _i3.CampaignGenerationResult.fromJson(data) as T;
    }
    if (t == _i4.CompanyProfile) {
      return _i4.CompanyProfile.fromJson(data) as T;
    }
    if (t == _i5.Greeting) {
      return _i5.Greeting.fromJson(data) as T;
    }
    if (t == _i6.Organization) {
      return _i6.Organization.fromJson(data) as T;
    }
    if (t == _i7.PlatformContent) {
      return _i7.PlatformContent.fromJson(data) as T;
    }
    if (t == _i8.Post) {
      return _i8.Post.fromJson(data) as T;
    }
    if (t == _i9.Product) {
      return _i9.Product.fromJson(data) as T;
    }
    if (t == _i10.SocialMediaConnection) {
      return _i10.SocialMediaConnection.fromJson(data) as T;
    }
    if (t == _i11.User) {
      return _i11.User.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AIInteractionLog?>()) {
      return (data != null ? _i2.AIInteractionLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CampaignGenerationResult?>()) {
      return (data != null ? _i3.CampaignGenerationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.CompanyProfile?>()) {
      return (data != null ? _i4.CompanyProfile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Greeting?>()) {
      return (data != null ? _i5.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Organization?>()) {
      return (data != null ? _i6.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PlatformContent?>()) {
      return (data != null ? _i7.PlatformContent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Post?>()) {
      return (data != null ? _i8.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.Product?>()) {
      return (data != null ? _i9.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SocialMediaConnection?>()) {
      return (data != null ? _i10.SocialMediaConnection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.User?>()) {
      return (data != null ? _i11.User.fromJson(data) : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, double>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<double>(v)),
                )
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i9.Product>) {
      return (data as List).map((e) => deserialize<_i9.Product>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.Product>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i9.Product>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i12.AIInteractionLog>) {
      return (data as List)
              .map((e) => deserialize<_i12.AIInteractionLog>(e))
              .toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i13.CompanyProfile>) {
      return (data as List)
              .map((e) => deserialize<_i13.CompanyProfile>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i14.Product>) {
      return (data as List).map((e) => deserialize<_i14.Product>(e)).toList()
          as T;
    }
    if (t == List<_i15.SocialMediaConnection>) {
      return (data as List)
              .map((e) => deserialize<_i15.SocialMediaConnection>(e))
              .toList()
          as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == List<_i16.Post>) {
      return (data as List).map((e) => deserialize<_i16.Post>(e)).toList() as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    try {
      return _i17.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i18.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AIInteractionLog => 'AIInteractionLog',
      _i3.CampaignGenerationResult => 'CampaignGenerationResult',
      _i4.CompanyProfile => 'CompanyProfile',
      _i5.Greeting => 'Greeting',
      _i6.Organization => 'Organization',
      _i7.PlatformContent => 'PlatformContent',
      _i8.Post => 'Post',
      _i9.Product => 'Product',
      _i10.SocialMediaConnection => 'SocialMediaConnection',
      _i11.User => 'User',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'social_media_marketing.',
        '',
      );
    }

    switch (data) {
      case _i2.AIInteractionLog():
        return 'AIInteractionLog';
      case _i3.CampaignGenerationResult():
        return 'CampaignGenerationResult';
      case _i4.CompanyProfile():
        return 'CompanyProfile';
      case _i5.Greeting():
        return 'Greeting';
      case _i6.Organization():
        return 'Organization';
      case _i7.PlatformContent():
        return 'PlatformContent';
      case _i8.Post():
        return 'Post';
      case _i9.Product():
        return 'Product';
      case _i10.SocialMediaConnection():
        return 'SocialMediaConnection';
      case _i11.User():
        return 'User';
    }
    className = _i17.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i18.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AIInteractionLog') {
      return deserialize<_i2.AIInteractionLog>(data['data']);
    }
    if (dataClassName == 'CampaignGenerationResult') {
      return deserialize<_i3.CampaignGenerationResult>(data['data']);
    }
    if (dataClassName == 'CompanyProfile') {
      return deserialize<_i4.CompanyProfile>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i5.Greeting>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i6.Organization>(data['data']);
    }
    if (dataClassName == 'PlatformContent') {
      return deserialize<_i7.PlatformContent>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i8.Post>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i9.Product>(data['data']);
    }
    if (dataClassName == 'SocialMediaConnection') {
      return deserialize<_i10.SocialMediaConnection>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i11.User>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i17.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i18.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
