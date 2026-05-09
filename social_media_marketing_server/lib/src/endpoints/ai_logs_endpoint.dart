import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for viewing AI interaction logs.
///
/// Provides read-only access to AI interaction history with filtering and pagination.
/// Logs are linked to posts, and access is controlled through post ownership.
class AILogsEndpoint extends Endpoint {
  /// Lists AI interaction logs with optional filtering.
  ///
  /// Parameters:
  /// - [userId] - User making the request (for access control)
  /// - [limit] - Max number of logs to return (default: 50, max: 200)
  /// - [offset] - Pagination offset (default: 0)
  /// - [interactionType] - Filter by type (initial_generation, edit_request, image_generation)
  /// - [startDate] - Filter logs after this date
  /// - [endDate] - Filter logs before this date
  /// - [postId] - Optional filter by specific post
  ///
  /// Returns: List of AIInteractionLog objects ordered by timestamp DESC
  ///
  /// Throws:
  /// - [Exception] if user not found
  Future<List<AIInteractionLog>> getLogs(
    Session session, {
    required int userId,
    int? limit,
    int? offset,
    String? interactionType,
    DateTime? startDate,
    DateTime? endDate,
    int? postId,
  }) async {
    try {
      // Validate user exists
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Set defaults
      final actualLimit = (limit == null || limit > 200) ? 50 : limit;
      final actualOffset = offset ?? 0;

      session.log('Fetching AI logs for user $userId (limit: $actualLimit, offset: $actualOffset)');

      // Build base query - we need to filter by posts owned by the user
      // First, get all posts owned by the user
      final userPosts = await Post.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      final userPostIds = userPosts.map((p) => p.id!).toList();

      if (userPostIds.isEmpty) {
        session.log('No posts found for user $userId');
        return [];
      }

      // Now get logs for those posts
      var logs = await AIInteractionLog.db.find(
        session,
        where: (t) => t.postId.inSet(userPostIds.toSet()),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      session.log('Found ${logs.length} total logs for user posts');

      // Apply optional filters in memory
      if (postId != null) {
        logs = logs.where((log) => log.postId == postId).toList();
      }

      if (interactionType != null) {
        logs = logs.where((log) => log.interactionType == interactionType).toList();
      }

      if (startDate != null) {
        logs = logs.where((log) => log.createdAt.isAfter(startDate)).toList();
      }

      if (endDate != null) {
        logs = logs.where((log) => log.createdAt.isBefore(endDate)).toList();
      }

      // Apply pagination after filtering
      final paginatedLogs = logs.skip(actualOffset).take(actualLimit).toList();

      session.log('Returning ${paginatedLogs.length} logs after filtering and pagination');
      return paginatedLogs;
    } catch (e, stackTrace) {
      session.log('Error retrieving AI logs: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets total cost of AI interactions for a user.
  ///
  /// Calculates the sum of all AI interaction costs for posts owned by the user.
  ///
  /// Parameters:
  /// - [userId] - User making the request
  /// - [startDate] - Include logs after this date
  /// - [endDate] - Include logs before this date
  /// - [postId] - Optional filter by specific post
  ///
  /// Returns: Total cost in USD
  ///
  /// Throws:
  /// - [Exception] if user not found
  Future<double> getTotalCost(
    Session session, {
    required int userId,
    DateTime? startDate,
    DateTime? endDate,
    int? postId,
  }) async {
    try {
      // Validate user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      session.log('Calculating total AI cost for user $userId');

      // Get all posts owned by the user
      final userPosts = await Post.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      final userPostIds = userPosts.map((p) => p.id!).toList();

      if (userPostIds.isEmpty) {
        session.log('No posts found for user $userId');
        return 0.0;
      }

      // Get all logs for those posts
      var logs = await AIInteractionLog.db.find(
        session,
        where: (t) => t.postId.inSet(userPostIds.toSet()),
      );

      // Apply optional filters
      if (postId != null) {
        logs = logs.where((log) => log.postId == postId).toList();
      }

      if (startDate != null) {
        logs = logs.where((log) => log.createdAt.isAfter(startDate)).toList();
      }

      if (endDate != null) {
        logs = logs.where((log) => log.createdAt.isBefore(endDate)).toList();
      }

      // Sum up total cost
      final totalCost = logs.fold<double>(
        0.0,
        (sum, log) => sum + (log.estimatedCostUsd ?? 0.0),
      );

      session.log('Total AI cost for user $userId: \$$totalCost (${logs.length} interactions)');
      return totalCost;
    } catch (e, stackTrace) {
      session.log('Error calculating total cost: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets detailed information about a specific log entry.
  ///
  /// Verifies that the user has access to the post associated with this log.
  ///
  /// Parameters:
  /// - [userId] - User making the request (for access control)
  /// - [logId] - ID of the log to retrieve
  ///
  /// Returns: AIInteractionLog or null if not found/not authorized
  ///
  /// Throws:
  /// - [Exception] if unauthorized access attempt
  Future<AIInteractionLog?> getLog(
    Session session, {
    required int userId,
    required int logId,
  }) async {
    try {
      session.log('Fetching log $logId for user $userId');

      // Get the log
      final log = await AIInteractionLog.db.findById(session, logId);

      if (log == null) {
        session.log('Log $logId not found');
        return null;
      }

      // If log has no postId, deny access (shouldn't happen in normal usage)
      if (log.postId == null) {
        session.log('Log $logId has no associated post');
        throw Exception('Unauthorized access to log');
      }

      // Verify user owns the post
      final post = await Post.db.findById(session, log.postId!);
      if (post == null) {
        session.log('Post ${log.postId} not found for log $logId');
        throw Exception('Unauthorized access to log');
      }

      if (post.userId != userId) {
        session.log('User $userId does not own post ${post.id} associated with log $logId');
        throw Exception('Unauthorized access to log');
      }

      session.log('Successfully retrieved log $logId for user $userId');
      return log;
    } catch (e, stackTrace) {
      session.log('Error retrieving log $logId: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets statistics about AI usage for a user.
  ///
  /// Returns aggregated data including:
  /// - Total interactions
  /// - Total cost
  /// - Breakdown by interaction type
  /// - Average cost per interaction
  ///
  /// Parameters:
  /// - [userId] - User making the request
  /// - [startDate] - Include logs after this date
  /// - [endDate] - Include logs before this date
  ///
  /// Returns: Map with statistics
  Future<Map<String, dynamic>> getStatistics(
    Session session, {
    required int userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Validate user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      session.log('Calculating AI statistics for user $userId');

      // Get all posts owned by the user
      final userPosts = await Post.db.find(
        session,
        where: (t) => t.userId.equals(userId),
      );

      final userPostIds = userPosts.map((p) => p.id!).toList();

      if (userPostIds.isEmpty) {
        return {
          'totalInteractions': 0,
          'totalCost': 0.0,
          'averageCost': 0.0,
          'byType': {},
          'successRate': 0.0,
        };
      }

      // Get all logs for those posts
      var logs = await AIInteractionLog.db.find(
        session,
        where: (t) => t.postId.inSet(userPostIds.toSet()),
      );

      // Apply date filters
      if (startDate != null) {
        logs = logs.where((log) => log.createdAt.isAfter(startDate)).toList();
      }

      if (endDate != null) {
        logs = logs.where((log) => log.createdAt.isBefore(endDate)).toList();
      }

      // Calculate statistics
      final totalInteractions = logs.length;
      final totalCost = logs.fold<double>(
        0.0,
        (sum, log) => sum + (log.estimatedCostUsd ?? 0.0),
      );
      final averageCost = totalInteractions > 0 ? totalCost / totalInteractions : 0.0;

      // Breakdown by type
      final byType = <String, Map<String, dynamic>>{};
      for (final log in logs) {
        final type = log.interactionType;
        if (!byType.containsKey(type)) {
          byType[type] = {
            'count': 0,
            'cost': 0.0,
          };
        }
        byType[type]!['count'] = (byType[type]!['count'] as int) + 1;
        byType[type]!['cost'] = (byType[type]!['cost'] as double) + (log.estimatedCostUsd ?? 0.0);
      }

      // Calculate success rate
      final successfulInteractions = logs.where((log) => log.success).length;
      final successRate = totalInteractions > 0 ? successfulInteractions / totalInteractions : 0.0;

      session.log('Statistics calculated: $totalInteractions interactions, \$$totalCost total cost');

      return {
        'totalInteractions': totalInteractions,
        'totalCost': totalCost,
        'averageCost': averageCost,
        'byType': byType,
        'successRate': successRate,
      };
    } catch (e, stackTrace) {
      session.log('Error calculating statistics: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }
}
