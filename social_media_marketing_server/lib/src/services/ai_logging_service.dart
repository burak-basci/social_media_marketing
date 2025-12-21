import 'dart:convert';
import 'dart:io';
import 'package:serverpod/serverpod.dart';
import '../generated/ai_interaction_log.dart';

/// Logging levels for LLM interactions
enum LLMLoggingLevel {
  /// Log everything: prompts, responses, timing, tokens, costs
  full,

  /// Log only timing and success/failure metrics
  timing,

  /// Log only errors and failures
  errors,

  /// Disable logging completely
  none,
}

/// Service for logging AI interactions to both database and JSONL files.
/// Provides comprehensive tracking of prompts, responses, timing, and costs.
class AILoggingService {
  final Session? _session;
  late final LLMLoggingLevel _loggingLevel;

  /// Creates an AI logging service with optional session for database access
  AILoggingService({Session? session}) : _session = session {
    // Read logging level from environment variable
    final levelStr = Platform.environment['LLM_LOGGING_LEVEL'] ?? 'FULL';
    _loggingLevel = _parseLoglLevel(levelStr);
  }

  /// Parse logging level from string
  LLMLoggingLevel _parseLoglLevel(String level) {
    switch (level.toUpperCase()) {
      case 'FULL':
        return LLMLoggingLevel.full;
      case 'TIMING':
        return LLMLoggingLevel.timing;
      case 'ERRORS':
        return LLMLoggingLevel.errors;
      case 'NONE':
        return LLMLoggingLevel.none;
      default:
        return LLMLoggingLevel.full;
    }
  }

  /// Logs an AI interaction to both database and JSONL file
  Future<void> log({
    required String interactionType,
    required String prompt,
    required String model,
    required String response,
    required Map<String, dynamic> timingBreakdown,
    required bool success,
    int? postId,
    String? errorMessage,
    Map<String, dynamic>? parameters,
    int? tokensUsed,
    double? estimatedCostUsd,
    Session? session,
  }) async {
    // Use provided session or fall back to the one from constructor
    final effectiveSession = session ?? _session;

    // Skip logging if level is none
    if (_loggingLevel == LLMLoggingLevel.none) {
      return;
    }

    // For errors level, only log failures
    if (_loggingLevel == LLMLoggingLevel.errors && success) {
      return;
    }

    try {
      // Prepare log data based on logging level
      final logData = _prepareLogData(
        interactionType: interactionType,
        prompt: prompt,
        model: model,
        response: response,
        timingBreakdown: timingBreakdown,
        success: success,
        postId: postId,
        errorMessage: errorMessage,
        parameters: parameters,
        tokensUsed: tokensUsed,
        estimatedCostUsd: estimatedCostUsd,
      );

      // Log to JSONL file
      await _logToFile(logData);

      // Log to database if session is available and appropriate logging level
      if (effectiveSession != null && _shouldLogToDatabase()) {
        await _logToDatabase(
          session: effectiveSession,
          interactionType: interactionType,
          prompt: prompt,
          model: model,
          response: response,
          timingBreakdown: timingBreakdown,
          success: success,
          postId: postId,
          errorMessage: errorMessage,
          parameters: parameters,
          tokensUsed: tokensUsed,
          estimatedCostUsd: estimatedCostUsd,
        );
      }
    } catch (e, stackTrace) {
      // Don't let logging failures break the application
      print('Error logging AI interaction: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Determines if we should log to database based on logging level
  bool _shouldLogToDatabase() {
    return _loggingLevel == LLMLoggingLevel.full ||
        _loggingLevel == LLMLoggingLevel.timing ||
        _loggingLevel == LLMLoggingLevel.errors;
  }

  /// Prepares log data according to logging level
  Map<String, dynamic> _prepareLogData({
    required String interactionType,
    required String prompt,
    required String model,
    required String response,
    required Map<String, dynamic> timingBreakdown,
    required bool success,
    int? postId,
    String? errorMessage,
    Map<String, dynamic>? parameters,
    int? tokensUsed,
    double? estimatedCostUsd,
  }) {
    final baseData = {
      'timestamp': DateTime.now().toIso8601String(),
      'interactionType': interactionType,
      'model': model,
      'success': success,
      'timingBreakdown': timingBreakdown,
    };

    if (postId != null) {
      baseData['postId'] = postId;
    }

    if (errorMessage != null) {
      baseData['errorMessage'] = errorMessage;
    }

    // Include full data for FULL logging level
    if (_loggingLevel == LLMLoggingLevel.full) {
      baseData['prompt'] = prompt;
      baseData['response'] = response;
      baseData['parameters'] = parameters ?? {};
      if (tokensUsed != null) baseData['tokensUsed'] = tokensUsed;
      if (estimatedCostUsd != null) baseData['estimatedCost'] = estimatedCostUsd;
    }

    // For TIMING level, include only timing info
    if (_loggingLevel == LLMLoggingLevel.timing) {
      baseData['promptLength'] = prompt.length;
      baseData['responseLength'] = response.length;
      if (tokensUsed != null) baseData['tokensUsed'] = tokensUsed;
      if (estimatedCostUsd != null) baseData['estimatedCost'] = estimatedCostUsd;
    }

    // For ERRORS level, include error details and prompts for debugging
    if (_loggingLevel == LLMLoggingLevel.errors && !success) {
      baseData['prompt'] = prompt;
      baseData['response'] = response;
      baseData['parameters'] = parameters ?? {};
    }

    return baseData;
  }

  /// Logs to JSONL file
  Future<void> _logToFile(Map<String, dynamic> logData) async {
    try {
      // Create logs directory if it doesn't exist
      final logsDir = Directory('logs');
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      // Create filename with current date
      final now = DateTime.now();
      final dateStr = '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final filename = 'llm_interactions_$dateStr.jsonl';
      final file = File('logs/$filename');

      // Append log entry as a single line JSON
      final jsonLine = jsonEncode(logData);
      await file.writeAsString('$jsonLine\n', mode: FileMode.append);
    } catch (e) {
      print('Error writing to JSONL log file: $e');
    }
  }

  /// Logs to database
  Future<void> _logToDatabase({
    required Session session,
    required String interactionType,
    required String prompt,
    required String model,
    required String response,
    required Map<String, dynamic> timingBreakdown,
    required bool success,
    int? postId,
    String? errorMessage,
    Map<String, dynamic>? parameters,
    int? tokensUsed,
    double? estimatedCostUsd,
  }) async {
    try {
      // For TIMING level, redact full prompt/response in database
      final dbPrompt = _loggingLevel == LLMLoggingLevel.timing
          ? '[REDACTED - length: ${prompt.length}]'
          : prompt;
      final dbResponse = _loggingLevel == LLMLoggingLevel.timing
          ? '[REDACTED - length: ${response.length}]'
          : response;

      final logEntry = AIInteractionLog(
        postId: postId,
        interactionType: interactionType,
        prompt: dbPrompt,
        model: model,
        parameters: jsonEncode(parameters ?? {}),
        rawResponse: dbResponse,
        timingBreakdown: jsonEncode(timingBreakdown),
        success: success,
        errorMessage: errorMessage,
        createdAt: DateTime.now(),
        tokensUsed: tokensUsed,
        estimatedCostUsd: estimatedCostUsd,
      );

      await AIInteractionLog.db.insertRow(session, logEntry);
    } catch (e) {
      print('Error writing to database log: $e');
    }
  }

  /// Estimates cost based on token usage and model
  static double? estimateCost({
    required String model,
    required int? tokensUsed,
  }) {
    if (tokensUsed == null) return null;

    // Gemini pricing (as of 2024)
    // These are approximate - adjust based on actual pricing
    final costPer1MTokens = _getModelCostPer1MTokens(model);
    if (costPer1MTokens == null) return null;

    return (tokensUsed / 1000000) * costPer1MTokens;
  }

  /// Gets cost per 1M tokens for a model
  static double? _getModelCostPer1MTokens(String model) {
    // Gemini 2.5 Flash pricing (approximate)
    // Input: $0.075 per 1M tokens
    // Output: $0.30 per 1M tokens
    // Using a blended rate for simplicity
    if (model.contains('gemini-2.5-flash')) {
      return 0.15; // Blended rate
    }

    // Gemini 1.5 Flash pricing
    if (model.contains('gemini-1.5-flash')) {
      return 0.10; // Blended rate
    }

    // Gemini 1.5 Pro pricing
    if (model.contains('gemini-1.5-pro')) {
      return 3.50; // Blended rate
    }

    return null; // Unknown model
  }

  /// Retrieves logs from database for a specific post
  static Future<List<AIInteractionLog>> getLogsForPost({
    required Session session,
    required int postId,
  }) async {
    return await AIInteractionLog.db.find(
      session,
      where: (t) => t.postId.equals(postId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Retrieves recent logs from database
  static Future<List<AIInteractionLog>> getRecentLogs({
    required Session session,
    int limit = 100,
    bool onlyErrors = false,
  }) async {
    return await AIInteractionLog.db.find(
      session,
      where: onlyErrors ? (t) => t.success.equals(false) : null,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
      limit: limit,
    );
  }

  /// Analyzes timing patterns from recent logs
  static Future<Map<String, dynamic>> analyzeTimingPatterns({
    required Session session,
    int limit = 1000,
  }) async {
    final logs = await getRecentLogs(session: session, limit: limit);

    if (logs.isEmpty) {
      return {'error': 'No logs available'};
    }

    final timings = logs.map((log) {
      final timing = jsonDecode(log.timingBreakdown);
      return timing['total_ms'] as int?;
    }).where((t) => t != null).cast<int>().toList();

    if (timings.isEmpty) {
      return {'error': 'No timing data available'};
    }

    timings.sort();

    final avg = timings.reduce((a, b) => a + b) / timings.length;
    final median = timings[timings.length ~/ 2];
    final p95 = timings[(timings.length * 0.95).floor()];
    final p99 = timings[(timings.length * 0.99).floor()];

    return {
      'count': timings.length,
      'average_ms': avg.round(),
      'median_ms': median,
      'p95_ms': p95,
      'p99_ms': p99,
      'min_ms': timings.first,
      'max_ms': timings.last,
    };
  }

  /// Gets total cost estimates from logs
  static Future<Map<String, dynamic>> getCostAnalysis({
    required Session session,
    DateTime? since,
  }) async {
    final logs = await AIInteractionLog.db.find(
      session,
      where: since != null ? (t) => t.createdAt > since : null,
    );

    double totalCost = 0.0;
    int totalTokens = 0;
    final modelBreakdown = <String, Map<String, dynamic>>{};

    for (final log in logs) {
      if (log.estimatedCostUsd != null) {
        totalCost += log.estimatedCostUsd!;
      }
      if (log.tokensUsed != null) {
        totalTokens += log.tokensUsed!;
      }

      // Track per-model stats
      if (!modelBreakdown.containsKey(log.model)) {
        modelBreakdown[log.model] = {
          'count': 0,
          'cost': 0.0,
          'tokens': 0,
        };
      }
      modelBreakdown[log.model]!['count'] =
          (modelBreakdown[log.model]!['count'] as int) + 1;
      if (log.estimatedCostUsd != null) {
        modelBreakdown[log.model]!['cost'] =
            (modelBreakdown[log.model]!['cost'] as double) +
                log.estimatedCostUsd!;
      }
      if (log.tokensUsed != null) {
        modelBreakdown[log.model]!['tokens'] =
            (modelBreakdown[log.model]!['tokens'] as int) + log.tokensUsed!;
      }
    }

    return {
      'totalCost': totalCost,
      'totalTokens': totalTokens,
      'totalInteractions': logs.length,
      'modelBreakdown': modelBreakdown,
      'period': since != null
          ? 'since ${since.toIso8601String()}'
          : 'all time',
    };
  }
}
