import 'package:serverpod/serverpod.dart';
import 'postiz_client.dart';

/// Example usage of the Postiz API client in Serverpod endpoints.
///
/// This file demonstrates how to integrate the Postiz client with your
/// Serverpod backend for scheduling and publishing AI-generated social media posts.

// ============================================================================
// EXAMPLE 1: Create a Serverpod Endpoint for Publishing Posts
// ============================================================================

/// Example endpoint for publishing a post to social media
///
/// This would be defined in lib/src/endpoints/posts_endpoint.dart
class PostsEndpointExample {
  /// Publishes an AI-generated post to selected social media platforms
  ///
  /// Flow:
  /// 1. Fetch organization and verify API key
  /// 2. Get connected social media integrations
  /// 3. Filter integrations based on selected platforms
  /// 4. Upload any media files
  /// 5. Create post request with platform-specific settings
  /// 6. Schedule/publish the post via Postiz
  /// 7. Update database with Postiz post ID
  Future<Map<String, dynamic>> publishPost(
    Session session,
    int postId,
    int organizationId,
  ) async {
    print('[PostsEndpoint] Publishing post $postId for organization $organizationId');

    try {
      // Step 1: Fetch the post from database
      final post = await session.db.findById<dynamic>(postId);
      if (post == null) {
        throw Exception('Post not found: $postId');
      }

      // Step 2: Get organization and Postiz credentials
      final organization = await session.db.findById<dynamic>(organizationId);
      if (organization == null) {
        throw Exception('Organization not found: $organizationId');
      }

      // Step 3: Initialize Postiz client
      final postizClient = PostizClient.cloud(
        apiKey: organization.postizApiKey,
        session: session,
      );

      try {
        // Step 4: Verify connection
        final isConnected = await postizClient.isConnected();
        if (!isConnected) {
          throw Exception('Invalid Postiz API key for organization $organizationId');
        }

        // Step 5: Get all connected integrations
        final allIntegrations = await postizClient.getIntegrations();
        print('[PostsEndpoint] Found ${allIntegrations.length} integrations');

        // Step 6: Parse selected platforms from post
        final selectedPlatforms = _parseSelectedPlatforms(post.selectedPlatforms);
        print('[PostsEndpoint] Selected platforms: $selectedPlatforms');

        // Step 7: Map platforms to integration IDs
        final platformIntegrations = <String, String>{};
        for (final integration in allIntegrations) {
          if (!integration.disabled &&
              selectedPlatforms.contains(integration.providerIdentifier)) {
            platformIntegrations[integration.providerIdentifier] = integration.id;
          }
        }

        if (platformIntegrations.isEmpty) {
          throw Exception('No active integrations found for selected platforms');
        }

        print('[PostsEndpoint] Using integrations: $platformIntegrations');

        // Step 8: Get the content to post (edited or AI-generated)
        final contentJson = post.editedContent ?? post.aiGeneratedContent;
        final content = _parseContent(contentJson);

        // Step 9: Handle media uploads (if any)
        final mediaUrls = await _uploadMediaIfNeeded(
          postizClient,
          content,
          organizationId,
        );

        // Step 10: Build integration posts for each platform
        final integrationPosts = _buildIntegrationPosts(
          platformIntegrations,
          content,
          mediaUrls,
        );

        // Step 11: Determine publish type and time
        final publishType = post.scheduleTime != null
            ? PostizPostType.schedule
            : PostizPostType.now;
        final publishDate = post.scheduleTime ?? DateTime.now();

        // Step 12: Create the post request
        final postRequest = PostizPostRequest(
          type: publishType,
          date: publishDate,
          integrations: integrationPosts,
        );

        // Step 13: Submit to Postiz
        print('[PostsEndpoint] Submitting post to Postiz...');
        final postizResponse = await postizClient.createPost(postRequest);
        print('[PostsEndpoint] Post created with ID: ${postizResponse.id}');

        // Step 14: Update database with Postiz post ID
        await _updatePostWithPostizId(session, postId, postizResponse.id);

        return {
          'success': true,
          'postizPostId': postizResponse.id,
          'publishDate': publishDate.toIso8601String(),
          'platforms': platformIntegrations.keys.toList(),
        };
      } finally {
        postizClient.dispose();
      }
    } catch (e, stackTrace) {
      print('[PostsEndpoint] ERROR: Failed to publish post $postId');
      print('[PostsEndpoint] Error: $e');
      print('[PostsEndpoint] Stack trace: $stackTrace');

      // Update post status to failed
      await _updatePostStatus(session, postId, 'failed');

      rethrow;
    }
  }

  // Helper methods

  List<String> _parseSelectedPlatforms(String selectedPlatformsJson) {
    // Parse JSON array of selected platforms
    // Example: '["x", "linkedin", "facebook"]'
    // TODO: Implement actual JSON parsing
    return ['x', 'linkedin']; // Placeholder
  }

  Map<String, dynamic> _parseContent(String contentJson) {
    // Parse AI-generated or edited content
    // Example structure:
    // {
    //   "x": "Tweet content here #hashtag",
    //   "linkedin": "LinkedIn post content here",
    //   "imageUrl": "https://example.com/image.jpg"
    // }
    // TODO: Implement actual JSON parsing
    return {
      'x': 'Sample tweet content #example',
      'linkedin': 'Sample LinkedIn post content',
      'imageUrl': null,
    };
  }

  Future<Map<String, List<String>>> _uploadMediaIfNeeded(
    PostizClient client,
    Map<String, dynamic> content,
    int organizationId,
  ) async {
    final mediaUrls = <String, List<String>>{};

    // Check if content has images
    if (content['imageUrl'] != null) {
      try {
        // Upload image to Postiz
        final postizImageUrl = await client.uploadFromUrl(content['imageUrl']);
        mediaUrls['images'] = [postizImageUrl];
        print('[PostsEndpoint] Uploaded image: $postizImageUrl');
      } catch (e) {
        print('[PostsEndpoint] Warning: Failed to upload image: $e');
      }
    }

    return mediaUrls;
  }

  List<PostizIntegrationPost> _buildIntegrationPosts(
    Map<String, String> platformIntegrations,
    Map<String, dynamic> content,
    Map<String, List<String>> mediaUrls,
  ) {
    final posts = <PostizIntegrationPost>[];
    final images = mediaUrls['images'];

    for (final entry in platformIntegrations.entries) {
      final platform = entry.key;
      final integrationId = entry.value;
      final platformContent = content[platform] ?? content['default'] ?? '';

      PostizPlatformSettings settings;

      switch (platform) {
        case 'x':
          settings = PostizXSettings(imageUrls: images);
          break;
        case 'linkedin':
          settings = PostizLinkedInSettings(imageUrls: images);
          break;
        case 'instagram':
          settings = PostizInstagramSettings(imageUrls: images);
          break;
        case 'facebook':
          settings = PostizFacebookSettings(imageUrls: images);
          break;
        case 'pinterest':
          settings = PostizPinterestSettings(
            imageUrl: images?.isNotEmpty == true ? images!.first : null,
          );
          break;
        default:
          settings = PostizGenericSettings(
            platformType: platform,
            imageUrls: images,
          );
      }

      posts.add(
        PostizIntegrationPost(
          integrationId: integrationId,
          content: platformContent,
          settings: settings,
        ),
      );
    }

    return posts;
  }

  Future<void> _updatePostWithPostizId(
    Session session,
    int postId,
    String postizPostId,
  ) async {
    // Update the post record with Postiz post ID
    // TODO: Implement database update
    print('[PostsEndpoint] Updated post $postId with Postiz ID: $postizPostId');
  }

  Future<void> _updatePostStatus(
    Session session,
    int postId,
    String status,
  ) async {
    // Update post status (scheduled, published, failed)
    // TODO: Implement database update
    print('[PostsEndpoint] Updated post $postId status to: $status');
  }
}

// ============================================================================
// EXAMPLE 2: Get Connected Social Media Accounts
// ============================================================================

class IntegrationsEndpointExample {
  /// Retrieves all connected social media accounts for an organization
  Future<List<Map<String, dynamic>>> getConnectedAccounts(
    Session session,
    int organizationId,
  ) async {
    print('[IntegrationsEndpoint] Fetching integrations for organization $organizationId');

    try {
      // Get organization
      final organization = await session.db.findById<dynamic>(organizationId);
      if (organization == null) {
        throw Exception('Organization not found: $organizationId');
      }

      // Initialize Postiz client
      final postizClient = PostizClient.cloud(
        apiKey: organization.postizApiKey,
        session: session,
      );

      try {
        // Fetch integrations
        final integrations = await postizClient.getIntegrations();

        // Convert to response format
        return integrations.map((integration) {
          return {
            'id': integration.id,
            'name': integration.name,
            'platform': integration.providerIdentifier,
            'picture': integration.picture,
            'active': !integration.disabled,
          };
        }).toList();
      } finally {
        postizClient.dispose();
      }
    } catch (e) {
      print('[IntegrationsEndpoint] ERROR: $e');
      rethrow;
    }
  }
}

// ============================================================================
// EXAMPLE 3: Delete a Scheduled Post
// ============================================================================

class PostDeletionEndpointExample {
  /// Deletes a scheduled post from Postiz and updates database
  Future<bool> deleteScheduledPost(
    Session session,
    int postId,
    int organizationId,
  ) async {
    print('[PostDeletionEndpoint] Deleting post $postId');

    try {
      // Get the post
      final post = await session.db.findById<dynamic>(postId);
      if (post == null) {
        throw Exception('Post not found: $postId');
      }

      // Check if post has Postiz ID
      if (post.postizPostId == null) {
        print('[PostDeletionEndpoint] Post has no Postiz ID, nothing to delete');
        return true;
      }

      // Get organization
      final organization = await session.db.findById<dynamic>(organizationId);
      if (organization == null) {
        throw Exception('Organization not found: $organizationId');
      }

      // Initialize Postiz client
      final postizClient = PostizClient.cloud(
        apiKey: organization.postizApiKey,
        session: session,
      );

      try {
        // Delete from Postiz
        await postizClient.deletePost(post.postizPostId);
        print('[PostDeletionEndpoint] Deleted from Postiz: ${post.postizPostId}');

        // Update database
        await _updatePostStatus(session, postId, 'deleted');

        return true;
      } finally {
        postizClient.dispose();
      }
    } catch (e) {
      print('[PostDeletionEndpoint] ERROR: $e');
      rethrow;
    }
  }

  Future<void> _updatePostStatus(Session session, int postId, String status) async {
    // Update post status
    // TODO: Implement database update
    print('[PostDeletionEndpoint] Updated post $postId status to: $status');
  }
}

// ============================================================================
// EXAMPLE 4: Get Scheduled Posts
// ============================================================================

class PostsCalendarEndpointExample {
  /// Retrieves all scheduled posts for an organization within a date range
  Future<List<Map<String, dynamic>>> getScheduledPosts(
    Session session,
    int organizationId, {
    int daysAhead = 30,
  }) async {
    print('[PostsCalendarEndpoint] Fetching scheduled posts for $daysAhead days');

    try {
      // Get organization
      final organization = await session.db.findById<dynamic>(organizationId);
      if (organization == null) {
        throw Exception('Organization not found: $organizationId');
      }

      // Initialize Postiz client
      final postizClient = PostizClient.cloud(
        apiKey: organization.postizApiKey,
        session: session,
      );

      try {
        final now = DateTime.now();
        final endDate = now.add(Duration(days: daysAhead));

        // Get posts from Postiz
        final postizPosts = await postizClient.getPosts(
          startDate: now,
          endDate: endDate,
        );

        // Convert to response format
        return postizPosts.map((post) {
          return {
            'id': post.id,
            'publishDate': post.publishDate.toIso8601String(),
            'status': post.status,
            'platforms': _extractPlatforms(post.integrations),
          };
        }).toList();
      } finally {
        postizClient.dispose();
      }
    } catch (e) {
      print('[PostsCalendarEndpoint] ERROR: $e');
      rethrow;
    }
  }

  List<String> _extractPlatforms(List<Map<String, dynamic>>? integrations) {
    if (integrations == null) return [];
    return integrations
        .map((i) => i['providerIdentifier'] as String?)
        .where((p) => p != null)
        .cast<String>()
        .toList();
  }
}

// ============================================================================
// EXAMPLE 5: Auto-Schedule Using Posting Slots
// ============================================================================

class AutoScheduleEndpointExample {
  /// Automatically schedules a post to the next available slot
  Future<Map<String, dynamic>> autoSchedulePost(
    Session session,
    int postId,
    int organizationId,
    String integrationId,
  ) async {
    print('[AutoScheduleEndpoint] Auto-scheduling post $postId');

    try {
      // Get organization
      final organization = await session.db.findById<dynamic>(organizationId);
      if (organization == null) {
        throw Exception('Organization not found: $organizationId');
      }

      // Initialize Postiz client
      final postizClient = PostizClient.cloud(
        apiKey: organization.postizApiKey,
        session: session,
      );

      try {
        // Find next available slot
        final nextSlot = await postizClient.findNextSlot(integrationId);

        if (nextSlot == null) {
          throw Exception('No posting slots configured for integration $integrationId');
        }

        print('[AutoScheduleEndpoint] Next available slot: $nextSlot');

        // Get post content
        final post = await session.db.findById<dynamic>(postId);
        if (post == null) {
          throw Exception('Post not found: $postId');
        }

        // Create post request with auto-scheduled time
        final request = PostizPostRequest(
          type: PostizPostType.schedule,
          date: nextSlot,
          integrations: [
            PostizIntegrationPost(
              integrationId: integrationId,
              content: _extractContent(post),
              settings: PostizXSettings(), // Adjust based on platform
            ),
          ],
        );

        // Submit to Postiz
        final response = await postizClient.createPost(request);

        return {
          'success': true,
          'postizPostId': response.id,
          'scheduledFor': nextSlot.toIso8601String(),
        };
      } finally {
        postizClient.dispose();
      }
    } catch (e) {
      print('[AutoScheduleEndpoint] ERROR: $e');
      rethrow;
    }
  }

  String _extractContent(dynamic post) {
    // Extract post content
    // TODO: Implement actual content extraction
    return 'Post content';
  }
}

// ============================================================================
// NOTES
// ============================================================================

/*
Integration Checklist:

1. Database Setup:
   - Ensure Organization model has postizApiKey field
   - Ensure Post model has postizPostId and postizWebhookData fields
   - Add indexes on postizPostId for faster lookups

2. Error Handling:
   - Always wrap Postiz calls in try-catch
   - Log all errors for debugging
   - Update post status on failure
   - Implement retry logic for transient failures

3. Multi-Tenancy:
   - Use organization-level API keys
   - Never mix data between organizations
   - Validate organization ownership before API calls

4. Rate Limiting:
   - Track API calls per organization
   - Implement queue system for high-volume organizations
   - Batch posts when possible (single API call for multiple platforms)

5. Media Handling:
   - Upload media before creating posts
   - Store Postiz media URLs in database
   - Implement cleanup for unused media

6. Webhooks (Future):
   - Set up webhook endpoint to receive status updates from Postiz
   - Update post status when Postiz sends notifications
   - Handle publish success/failure events

7. Testing:
   - Test with invalid API keys
   - Test with disconnected integrations
   - Test rate limiting behavior
   - Test media upload failures
   - Test scheduling in the past (should fail)

8. Monitoring:
   - Track success/failure rates
   - Monitor API response times
   - Alert on repeated failures
   - Track costs (API usage)
*/
