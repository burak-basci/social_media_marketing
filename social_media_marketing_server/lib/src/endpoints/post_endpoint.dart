import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Post endpoint for managing social media posts (CRUD operations).
///
/// Provides methods for:
/// - Listing posts with filtering and pagination
/// - Getting a single post by ID
/// - Updating post details (status, schedule, content)
/// - Deleting posts
/// - Duplicating posts
/// - Publishing posts immediately
///
/// Example usage from client:
/// ```dart
/// // List posts with filters
/// final posts = await client.post.listPosts(
///   userId: 1,
///   statusFilter: ['draft', 'scheduled'],
///   platformFilter: ['x', 'linkedin'],
///   limit: 50,
/// );
///
/// // Get single post
/// final post = await client.post.getPost(
///   userId: 1,
///   postId: 123,
/// );
///
/// // Update post
/// final updated = await client.post.updatePost(
///   userId: 1,
///   postId: 123,
///   status: 'scheduled',
///   scheduleTime: DateTime.now().add(Duration(hours: 2)),
/// );
/// ```
class PostEndpoint extends Endpoint {
  /// Valid post statuses
  static const List<String> validStatuses = [
    'draft',
    'scheduled',
    'publishing',
    'published',
    'failed',
  ];

  /// Valid social media platforms
  static const List<String> validPlatforms = [
    'x',
    'linkedin',
    'instagram',
    'facebook',
    'pinterest',
  ];

  /// Lists posts with filtering and pagination.
  ///
  /// This method retrieves posts for a specific user with various filtering
  /// options. All posts are filtered by organization to ensure data isolation.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (used for organization validation)
  /// - [statusFilter] - Optional list of statuses to filter by (draft, scheduled, published, failed)
  /// - [platformFilter] - Optional list of platforms to filter by (x, linkedin, instagram, facebook, pinterest)
  /// - [startDate] - Optional start date for filtering by createdAt
  /// - [endDate] - Optional end date for filtering by createdAt
  /// - [searchQuery] - Optional text search in title and content
  /// - [limit] - Maximum number of posts to return (default: 50, max: 200)
  /// - [offset] - Number of posts to skip for pagination (default: 0)
  ///
  /// Returns: List of Post objects matching the filters, ordered by createdAt DESC
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if invalid status or platform values provided
  Future<List<Post>> listPosts(
    Session session, {
    required int userId,
    List<String>? statusFilter,
    List<String>? platformFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      session.log('Listing posts for user $userId');

      // Validate limit
      if (limit <= 0 || limit > 200) {
        throw Exception('Limit must be between 1 and 200');
      }

      // Validate offset
      if (offset < 0) {
        throw Exception('Offset must be non-negative');
      }

      // Validate status filter
      if (statusFilter != null && statusFilter.isNotEmpty) {
        for (final status in statusFilter) {
          if (!validStatuses.contains(status)) {
            throw Exception('Invalid status: $status. Valid values: ${validStatuses.join(', ')}');
          }
        }
      }

      // Validate platform filter
      if (platformFilter != null && platformFilter.isNotEmpty) {
        for (final platform in platformFilter) {
          if (!validPlatforms.contains(platform)) {
            throw Exception('Invalid platform: $platform. Valid values: ${validPlatforms.join(', ')}');
          }
        }
      }

      // Load user and get organization ID
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      session.log('User organization: ${user.organizationId}');

      // Build query with filters
      final posts = await Post.db.find(
        session,
        where: (t) {
          // Base filter: organization ID
          var expr = t.organizationId.equals(user.organizationId);

          // Filter by status
          if (statusFilter != null && statusFilter.isNotEmpty) {
            expr = expr & t.status.inSet(statusFilter.toSet());
          }

          // Filter by date range
          if (startDate != null) {
            expr = expr & (t.createdAt >= startDate);
          }
          if (endDate != null) {
            expr = expr & (t.createdAt <= endDate);
          }

          // Search in title and user prompt
          if (searchQuery != null && searchQuery.trim().isNotEmpty) {
            final query = searchQuery.trim();
            expr = expr & (
              t.title.like('%$query%') |
              t.userPrompt.like('%$query%')
            );
          }

          // Platform filter requires JSON parsing, so we'll do it post-query
          // since Serverpod doesn't support JSON querying directly

          return expr;
        },
        orderBy: (t) => t.createdAt,
        orderDescending: true,
        limit: limit,
        offset: offset,
      );

      // Filter by platform if needed (post-query filtering)
      if (platformFilter != null && platformFilter.isNotEmpty) {
        final filteredPosts = posts.where((post) {
          final selectedPlatforms = (jsonDecode(post.selectedPlatforms) as List)
              .map((e) => e as String)
              .toList();

          // Check if any of the selected platforms match the filter
          return platformFilter.any((platform) => selectedPlatforms.contains(platform));
        }).toList();

        session.log('Found ${filteredPosts.length} posts (after platform filter)');
        return filteredPosts;
      }

      session.log('Found ${posts.length} posts');
      return posts;
    } catch (e, stackTrace) {
      session.log('List posts failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets a single post by ID.
  ///
  /// Validates that the user has access to the post through their organization.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to retrieve
  ///
  /// Returns: Post object or null if not found or user doesn't have access
  ///
  /// Throws:
  /// - [Exception] if user not found
  Future<Post?> getPost(
    Session session, {
    required int userId,
    required int postId,
  }) async {
    try {
      session.log('Getting post $postId for user $userId');

      // Load user to get organization
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load post
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        session.log('Post not found');
        return null;
      }

      // Validate user has access to this post (through organization)
      if (post.organizationId != user.organizationId) {
        session.log('Access denied: User does not belong to post organization', level: LogLevel.warning);
        return null;
      }

      session.log('Post retrieved successfully');
      return post;
    } catch (e, stackTrace) {
      session.log('Get post failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Updates an existing post.
  ///
  /// Allows updating post status, schedule time, edited content, and title.
  /// User must own the post (through organization).
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to update
  /// - [status] - Optional new status (draft, scheduled, published, failed)
  /// - [scheduleTime] - Optional new schedule time
  /// - [editedContent] - Optional map of platform-specific edited content
  /// - [title] - Optional new title
  ///
  /// Returns: Updated Post object
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  /// - [Exception] if invalid status value
  Future<Post> updatePost(
    Session session, {
    required int userId,
    required int postId,
    String? status,
    DateTime? scheduleTime,
    Map<String, String>? editedContent,
    String? title,
  }) async {
    try {
      session.log('Updating post $postId for user $userId');

      // Validate status if provided
      if (status != null && !validStatuses.contains(status)) {
        throw Exception('Invalid status: $status. Valid values: ${validStatuses.join(', ')}');
      }

      // Load user to get organization
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load post
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        throw Exception('Post not found');
      }

      // Validate user has access to this post
      if (post.organizationId != user.organizationId) {
        throw Exception('Access denied: User does not belong to post organization');
      }

      // Build updated post
      final updatedPost = post.copyWith(
        status: status ?? post.status,
        scheduleTime: scheduleTime ?? post.scheduleTime,
        editedContent: editedContent != null
            ? jsonEncode(editedContent)
            : post.editedContent,
        title: title ?? post.title,
        updatedAt: DateTime.now(),
      );

      // Save to database
      final result = await Post.db.updateRow(session, updatedPost);

      session.log('Post updated successfully');
      return result;
    } catch (e, stackTrace) {
      session.log('Update post failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Deletes a post.
  ///
  /// User must own the post (through organization).
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to delete
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  Future<void> deletePost(
    Session session, {
    required int userId,
    required int postId,
  }) async {
    try {
      session.log('Deleting post $postId for user $userId');

      // Load user to get organization
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load post
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        throw Exception('Post not found');
      }

      // Validate user has access to this post
      if (post.organizationId != user.organizationId) {
        throw Exception('Access denied: User does not belong to post organization');
      }

      // Delete the post
      await Post.db.deleteRow(session, post);

      session.log('Post deleted successfully');
    } catch (e, stackTrace) {
      session.log('Delete post failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Duplicates an existing post.
  ///
  /// Creates a copy of the post with all fields except id, createdAt.
  /// The new post is set to 'draft' status with cleared publishing timestamps.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to duplicate
  ///
  /// Returns: New Post object (the duplicate)
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  Future<Post> duplicatePost(
    Session session, {
    required int userId,
    required int postId,
  }) async {
    try {
      session.log('Duplicating post $postId for user $userId');

      // Load user to get organization
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load post
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        throw Exception('Post not found');
      }

      // Validate user has access to this post
      if (post.organizationId != user.organizationId) {
        throw Exception('Access denied: User does not belong to post organization');
      }

      // Create duplicate with new timestamps and draft status
      final now = DateTime.now();
      final duplicate = Post(
        organizationId: post.organizationId,
        userId: post.userId,
        companyProfileId: post.companyProfileId,
        productId: post.productId,
        title: '${post.title} (Copy)',
        userPrompt: post.userPrompt,
        aiGeneratedContent: post.aiGeneratedContent,
        editedContent: post.editedContent,
        selectedPlatforms: post.selectedPlatforms,
        status: 'draft',
        scheduleTime: null,
        postizPostId: null,
        postizWebhookData: null,
        createdAt: now,
        updatedAt: now,
        publishedAt: null,
      );

      // Insert into database
      final newPost = await Post.db.insertRow(session, duplicate);

      session.log('Post duplicated successfully: ${newPost.id}');
      return newPost;
    } catch (e, stackTrace) {
      session.log('Duplicate post failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }

  /// Publishes a post immediately by scheduling it for now.
  ///
  /// Sets the post status to 'scheduled' and scheduleTime to current time.
  /// This triggers the publishing workflow.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - ID of the post to publish
  ///
  /// Returns: Updated Post object
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if post not found
  /// - [Exception] if user doesn't have access to the post
  Future<Post> publishNow(
    Session session, {
    required int userId,
    required int postId,
  }) async {
    try {
      session.log('Publishing post $postId immediately for user $userId');

      // Load user to get organization
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load post
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        throw Exception('Post not found');
      }

      // Validate user has access to this post
      if (post.organizationId != user.organizationId) {
        throw Exception('Access denied: User does not belong to post organization');
      }

      // Update post to scheduled with current time
      final now = DateTime.now();
      final updatedPost = post.copyWith(
        status: 'scheduled',
        scheduleTime: now,
        updatedAt: now,
      );

      // Save to database
      final result = await Post.db.updateRow(session, updatedPost);

      session.log('Post scheduled for immediate publishing');
      return result;
    } catch (e, stackTrace) {
      session.log('Publish now failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);
      rethrow;
    }
  }
}
