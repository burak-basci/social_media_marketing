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

/// Logs all AI interactions for analytics and debugging.
/// Tracks prompts, responses, timing, and costs.
abstract class AIInteractionLog implements _i1.SerializableModel {
  AIInteractionLog._({
    this.id,
    this.postId,
    required this.interactionType,
    required this.prompt,
    required this.model,
    required this.parameters,
    required this.rawResponse,
    required this.timingBreakdown,
    required this.success,
    this.errorMessage,
    required this.createdAt,
    this.tokensUsed,
    this.estimatedCostUsd,
  });

  factory AIInteractionLog({
    int? id,
    int? postId,
    required String interactionType,
    required String prompt,
    required String model,
    required String parameters,
    required String rawResponse,
    required String timingBreakdown,
    required bool success,
    String? errorMessage,
    required DateTime createdAt,
    int? tokensUsed,
    double? estimatedCostUsd,
  }) = _AIInteractionLogImpl;

  factory AIInteractionLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AIInteractionLog(
      id: jsonSerialization['id'] as int?,
      postId: jsonSerialization['postId'] as int?,
      interactionType: jsonSerialization['interactionType'] as String,
      prompt: jsonSerialization['prompt'] as String,
      model: jsonSerialization['model'] as String,
      parameters: jsonSerialization['parameters'] as String,
      rawResponse: jsonSerialization['rawResponse'] as String,
      timingBreakdown: jsonSerialization['timingBreakdown'] as String,
      success: jsonSerialization['success'] as bool,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      tokensUsed: jsonSerialization['tokensUsed'] as int?,
      estimatedCostUsd: (jsonSerialization['estimatedCostUsd'] as num?)
          ?.toDouble(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Optional reference to the post this interaction is related to.
  int? postId;

  /// Type of interaction: 'initial_generation', 'edit_request', or 'image_generation'.
  String interactionType;

  /// The prompt sent to the AI model.
  String prompt;

  /// The AI model used (e.g., 'gemini-1.5-flash').
  String model;

  /// JSON containing model parameters (temperature, max_tokens, etc.).
  String parameters;

  /// JSON containing the raw AI response.
  String rawResponse;

  /// JSON containing timing breakdown (total_ms, api_call_ms, processing_ms).
  String timingBreakdown;

  /// Whether the interaction was successful.
  bool success;

  /// Optional error message if the interaction failed.
  String? errorMessage;

  /// Timestamp when the interaction occurred.
  DateTime createdAt;

  /// Optional number of tokens used by the AI model.
  int? tokensUsed;

  /// Optional estimated cost in USD.
  double? estimatedCostUsd;

  /// Returns a shallow copy of this [AIInteractionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AIInteractionLog copyWith({
    int? id,
    int? postId,
    String? interactionType,
    String? prompt,
    String? model,
    String? parameters,
    String? rawResponse,
    String? timingBreakdown,
    bool? success,
    String? errorMessage,
    DateTime? createdAt,
    int? tokensUsed,
    double? estimatedCostUsd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AIInteractionLog',
      if (id != null) 'id': id,
      if (postId != null) 'postId': postId,
      'interactionType': interactionType,
      'prompt': prompt,
      'model': model,
      'parameters': parameters,
      'rawResponse': rawResponse,
      'timingBreakdown': timingBreakdown,
      'success': success,
      if (errorMessage != null) 'errorMessage': errorMessage,
      'createdAt': createdAt.toJson(),
      if (tokensUsed != null) 'tokensUsed': tokensUsed,
      if (estimatedCostUsd != null) 'estimatedCostUsd': estimatedCostUsd,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AIInteractionLogImpl extends AIInteractionLog {
  _AIInteractionLogImpl({
    int? id,
    int? postId,
    required String interactionType,
    required String prompt,
    required String model,
    required String parameters,
    required String rawResponse,
    required String timingBreakdown,
    required bool success,
    String? errorMessage,
    required DateTime createdAt,
    int? tokensUsed,
    double? estimatedCostUsd,
  }) : super._(
         id: id,
         postId: postId,
         interactionType: interactionType,
         prompt: prompt,
         model: model,
         parameters: parameters,
         rawResponse: rawResponse,
         timingBreakdown: timingBreakdown,
         success: success,
         errorMessage: errorMessage,
         createdAt: createdAt,
         tokensUsed: tokensUsed,
         estimatedCostUsd: estimatedCostUsd,
       );

  /// Returns a shallow copy of this [AIInteractionLog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AIInteractionLog copyWith({
    Object? id = _Undefined,
    Object? postId = _Undefined,
    String? interactionType,
    String? prompt,
    String? model,
    String? parameters,
    String? rawResponse,
    String? timingBreakdown,
    bool? success,
    Object? errorMessage = _Undefined,
    DateTime? createdAt,
    Object? tokensUsed = _Undefined,
    Object? estimatedCostUsd = _Undefined,
  }) {
    return AIInteractionLog(
      id: id is int? ? id : this.id,
      postId: postId is int? ? postId : this.postId,
      interactionType: interactionType ?? this.interactionType,
      prompt: prompt ?? this.prompt,
      model: model ?? this.model,
      parameters: parameters ?? this.parameters,
      rawResponse: rawResponse ?? this.rawResponse,
      timingBreakdown: timingBreakdown ?? this.timingBreakdown,
      success: success ?? this.success,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      tokensUsed: tokensUsed is int? ? tokensUsed : this.tokensUsed,
      estimatedCostUsd: estimatedCostUsd is double?
          ? estimatedCostUsd
          : this.estimatedCostUsd,
    );
  }
}
