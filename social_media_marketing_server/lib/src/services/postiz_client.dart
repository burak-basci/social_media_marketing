import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Postiz API client for scheduling and publishing social media posts.
///
/// This client provides a Dart interface to the Postiz Public API for managing
/// social media content across multiple platforms (X, LinkedIn, Instagram, Facebook, Pinterest).
///
/// ## Authentication
/// Each organization must configure their Postiz API key and base URL in the
/// Organization settings. The API key is passed in the Authorization header.
///
/// ## Rate Limiting
/// Postiz enforces a limit of 30 API requests per hour. Multiple posts can be
/// scheduled in a single request to maximize throughput.
///
/// ## Example Usage
/// ```dart
/// final postizClient = PostizClient(
///   apiKey: organization.postizApiKey,
///   baseUrl: organization.postizBaseUrl,
///   session: session,
/// );
///
/// // Get connected social media accounts
/// final integrations = await postizClient.getIntegrations();
///
/// // Create and schedule a post
/// final postRequest = PostizPostRequest(
///   type: PostizPostType.schedule,
///   date: DateTime.now().add(Duration(hours: 2)),
///   integrations: [
///     PostizIntegrationPost(
///       integrationId: 'integration-id-123',
///       content: 'Your post content here #marketing',
///       settings: PostizXSettings(imageUrls: ['https://example.com/image.jpg']),
///     ),
///   ],
/// );
///
/// final result = await postizClient.createPost(postRequest);
/// print('Post scheduled with ID: ${result.id}');
/// ```
class PostizClient {
  final String apiKey;
  final String baseUrl;
  final Session? _session;
  final http.Client _httpClient;

  /// Default timeout for API requests (30 seconds)
  static const Duration _defaultTimeout = Duration(seconds: 30);

  /// Creates a Postiz API client.
  ///
  /// [apiKey] - API key from Postiz settings (required)
  /// [baseUrl] - Base URL for self-hosted Postiz instance or 'https://api.postiz.com'
  /// [session] - Optional Serverpod session for logging
  /// [httpClient] - Optional custom HTTP client (useful for testing)
  PostizClient({
    required this.apiKey,
    required String baseUrl,
    Session? session,
    http.Client? httpClient,
  })  : baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl,
        _session = session,
        _httpClient = httpClient ?? http.Client();

  /// Factory constructor for cloud-hosted Postiz
  factory PostizClient.cloud({
    required String apiKey,
    Session? session,
  }) {
    return PostizClient(
      apiKey: apiKey,
      baseUrl: 'https://api.postiz.com',
      session: session,
    );
  }

  /// Factory constructor for self-hosted Postiz
  factory PostizClient.selfHosted({
    required String apiKey,
    required String backendUrl,
    Session? session,
  }) {
    return PostizClient(
      apiKey: apiKey,
      baseUrl: '$backendUrl',
      session: session,
    );
  }

  // ============================================================================
  // PUBLIC API METHODS
  // ============================================================================

  /// Verifies that the API key is valid and can connect to Postiz.
  ///
  /// Returns `true` if connection successful, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// final isValid = await postizClient.isConnected();
  /// if (!isValid) {
  ///   throw Exception('Invalid Postiz API key');
  /// }
  /// ```
  Future<bool> isConnected() async {
    try {
      _log('Checking connection to Postiz API');
      final response = await _get('/public/v1/is-connected');
      _log('Connection check successful: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      _logError('Connection check failed', e);
      return false;
    }
  }

  /// Retrieves all connected social media integrations for this API key.
  ///
  /// Returns a list of [PostizIntegration] objects containing integration details
  /// including platform type, account name, and integration ID.
  ///
  /// Example:
  /// ```dart
  /// final integrations = await postizClient.getIntegrations();
  /// for (final integration in integrations) {
  ///   print('${integration.providerIdentifier}: ${integration.name}');
  /// }
  /// ```
  Future<List<PostizIntegration>> getIntegrations() async {
    try {
      _log('Fetching connected integrations');
      final response = await _get('/public/v1/integrations');

      if (response.statusCode != 200) {
        throw PostizApiException(
          'Failed to fetch integrations',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final List<dynamic> data = jsonDecode(response.body);
      final integrations = data.map((item) => PostizIntegration.fromJson(item)).toList();

      _log('Retrieved ${integrations.length} integrations');
      return integrations;
    } catch (e) {
      _logError('Failed to fetch integrations', e);
      rethrow;
    }
  }

  /// Finds the next available posting slot for a specific integration.
  ///
  /// [integrationId] - The ID of the integration to check
  ///
  /// Returns a [DateTime] representing the next available slot, or null if
  /// the integration doesn't have scheduling slots configured.
  ///
  /// Example:
  /// ```dart
  /// final nextSlot = await postizClient.findNextSlot('integration-123');
  /// if (nextSlot != null) {
  ///   print('Next available slot: $nextSlot');
  /// }
  /// ```
  Future<DateTime?> findNextSlot(String integrationId) async {
    try {
      _log('Finding next slot for integration: $integrationId');
      final response = await _get('/public/v1/find-slot/$integrationId');

      if (response.statusCode != 200) {
        throw PostizApiException(
          'Failed to find next slot',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final data = jsonDecode(response.body);
      if (data['slot'] != null) {
        return DateTime.parse(data['slot']);
      }
      return null;
    } catch (e) {
      _logError('Failed to find next slot for integration: $integrationId', e);
      rethrow;
    }
  }

  /// Creates and schedules a post on one or more social media platforms.
  ///
  /// [request] - The post request containing content, scheduling, and platform settings
  ///
  /// Returns a [PostizPostResponse] with the created post ID and details.
  ///
  /// Example:
  /// ```dart
  /// final request = PostizPostRequest(
  ///   type: PostizPostType.schedule,
  ///   date: DateTime.now().add(Duration(hours: 1)),
  ///   integrations: [
  ///     PostizIntegrationPost(
  ///       integrationId: 'integration-123',
  ///       content: 'Check out our new product! 🚀 #launch',
  ///       settings: PostizXSettings(imageUrls: ['https://example.com/img.jpg']),
  ///     ),
  ///   ],
  /// );
  ///
  /// final result = await postizClient.createPost(request);
  /// print('Post created with ID: ${result.id}');
  /// ```
  Future<PostizPostResponse> createPost(PostizPostRequest request) async {
    try {
      _log('Creating post: ${request.type.name} at ${request.date}');
      _log('Platforms: ${request.integrations.length}');

      final response = await _post(
        '/public/v1/posts',
        body: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw PostizApiException(
          'Failed to create post',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final data = jsonDecode(response.body);
      final postResponse = PostizPostResponse.fromJson(data);

      _log('Post created successfully: ${postResponse.id}');
      return postResponse;
    } catch (e) {
      _logError('Failed to create post', e);
      rethrow;
    }
  }

  /// Retrieves posts within a specified date range.
  ///
  /// [startDate] - Start of the date range
  /// [endDate] - End of the date range
  /// [customerId] - Optional customer ID to filter posts
  ///
  /// Returns a list of [PostizPost] objects.
  ///
  /// Example:
  /// ```dart
  /// final posts = await postizClient.getPosts(
  ///   startDate: DateTime.now().subtract(Duration(days: 7)),
  ///   endDate: DateTime.now(),
  /// );
  /// print('Found ${posts.length} posts in the last week');
  /// ```
  Future<List<PostizPost>> getPosts({
    required DateTime startDate,
    required DateTime endDate,
    String? customerId,
  }) async {
    try {
      _log('Fetching posts from ${startDate.toIso8601String()} to ${endDate.toIso8601String()}');

      final queryParams = {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        if (customerId != null) 'customer': customerId,
      };

      final response = await _get('/public/v1/posts', queryParams: queryParams);

      if (response.statusCode != 200) {
        throw PostizApiException(
          'Failed to fetch posts',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final List<dynamic> data = jsonDecode(response.body);
      final posts = data.map((item) => PostizPost.fromJson(item)).toList();

      _log('Retrieved ${posts.length} posts');
      return posts;
    } catch (e) {
      _logError('Failed to fetch posts', e);
      rethrow;
    }
  }

  /// Deletes a scheduled post by its ID.
  ///
  /// [postId] - The ID of the post to delete
  ///
  /// Returns `true` if deletion was successful.
  ///
  /// Example:
  /// ```dart
  /// await postizClient.deletePost('post-123');
  /// print('Post deleted successfully');
  /// ```
  Future<bool> deletePost(String postId) async {
    try {
      _log('Deleting post: $postId');
      final response = await _delete('/public/v1/posts/$postId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw PostizApiException(
          'Failed to delete post',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      _log('Post deleted successfully: $postId');
      return true;
    } catch (e) {
      _logError('Failed to delete post: $postId', e);
      rethrow;
    }
  }

  /// Uploads a file to Postiz for use in posts.
  ///
  /// [filePath] - Local path to the file
  /// [fileName] - Optional custom filename
  ///
  /// Returns the Postiz URL path for the uploaded file, which can be used
  /// in post image/video URLs.
  ///
  /// Example:
  /// ```dart
  /// final postizUrl = await postizClient.uploadFile('/path/to/image.jpg');
  /// print('Uploaded to: $postizUrl');
  /// // Use in post: settings: PostizXSettings(imageUrls: [postizUrl])
  /// ```
  Future<String> uploadFile(String filePath, {String? fileName}) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw PostizApiException('File not found: $filePath');
      }

      _log('Uploading file: $filePath');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/public/v1/upload'),
      );

      request.headers['Authorization'] = apiKey;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: fileName ?? filePath.split('/').last,
        ),
      );

      final streamedResponse = await request.send().timeout(_defaultTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw PostizApiException(
          'Failed to upload file',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final data = jsonDecode(response.body);
      final uploadedUrl = data['path'] ?? data['url'];

      _log('File uploaded successfully: $uploadedUrl');
      return uploadedUrl;
    } catch (e) {
      _logError('Failed to upload file: $filePath', e);
      rethrow;
    }
  }

  /// Uploads a file from a URL to Postiz.
  ///
  /// [url] - The URL of the file to upload
  ///
  /// Returns the Postiz URL path for the uploaded file.
  ///
  /// Example:
  /// ```dart
  /// final postizUrl = await postizClient.uploadFromUrl(
  ///   'https://example.com/image.jpg'
  /// );
  /// ```
  Future<String> uploadFromUrl(String url) async {
    try {
      _log('Uploading file from URL: $url');

      final response = await _post(
        '/public/v1/upload-from-url',
        body: {'url': url},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw PostizApiException(
          'Failed to upload from URL',
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      }

      final data = jsonDecode(response.body);
      final uploadedUrl = data['path'] ?? data['url'];

      _log('File uploaded from URL successfully: $uploadedUrl');
      return uploadedUrl;
    } catch (e) {
      _logError('Failed to upload from URL: $url', e);
      rethrow;
    }
  }

  // ============================================================================
  // PRIVATE HTTP METHODS
  // ============================================================================

  Future<http.Response> _get(String path, {Map<String, String>? queryParams}) async {
    final uri = _buildUri(path, queryParams: queryParams);
    return await _httpClient
        .get(
          uri,
          headers: _buildHeaders(),
        )
        .timeout(_defaultTimeout);
  }

  Future<http.Response> _post(String path, {Map<String, dynamic>? body}) async {
    final uri = _buildUri(path);
    return await _httpClient
        .post(
          uri,
          headers: _buildHeaders(contentType: 'application/json'),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(_defaultTimeout);
  }

  Future<http.Response> _delete(String path) async {
    final uri = _buildUri(path);
    return await _httpClient
        .delete(
          uri,
          headers: _buildHeaders(),
        )
        .timeout(_defaultTimeout);
  }

  Uri _buildUri(String path, {Map<String, String>? queryParams}) {
    final fullUrl = '$baseUrl$path';
    final uri = Uri.parse(fullUrl);

    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }

    return uri;
  }

  Map<String, String> _buildHeaders({String? contentType}) {
    return {
      'Authorization': apiKey,
      if (contentType != null) 'Content-Type': contentType,
    };
  }

  // ============================================================================
  // LOGGING
  // ============================================================================

  void _log(String message) {
    print('[PostizClient] $message');
    // TODO: Integrate with Serverpod logging when available
  }

  void _logError(String message, Object error) {
    print('[PostizClient] ERROR: $message - $error');
    // TODO: Integrate with Serverpod error logging
  }

  /// Disposes the HTTP client (call when done using the client)
  void dispose() {
    _httpClient.close();
  }
}

// ==============================================================================
// DATA MODELS
// ==============================================================================

/// Represents a connected social media integration in Postiz.
class PostizIntegration {
  final String id;
  final String name;
  final String providerIdentifier;
  final String? picture;
  final bool disabled;

  PostizIntegration({
    required this.id,
    required this.name,
    required this.providerIdentifier,
    this.picture,
    required this.disabled,
  });

  factory PostizIntegration.fromJson(Map<String, dynamic> json) {
    return PostizIntegration(
      id: json['id'] as String,
      name: json['name'] as String,
      providerIdentifier: json['providerIdentifier'] as String,
      picture: json['picture'] as String?,
      disabled: json['disabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'providerIdentifier': providerIdentifier,
      if (picture != null) 'picture': picture,
      'disabled': disabled,
    };
  }

  @override
  String toString() => 'PostizIntegration(id: $id, name: $name, provider: $providerIdentifier)';
}

/// Type of post scheduling
enum PostizPostType {
  /// Post immediately
  now,

  /// Schedule for future
  schedule,
}

/// Request to create/schedule a post on Postiz
class PostizPostRequest {
  final PostizPostType type;
  final DateTime date;
  final List<PostizIntegrationPost> integrations;

  PostizPostRequest({
    required this.type,
    required this.date,
    required this.integrations,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'date': date.toIso8601String(),
      'integrations': integrations.map((i) => i.toJson()).toList(),
    };
  }
}

/// Post content for a specific integration/platform
class PostizIntegrationPost {
  final String integrationId;
  final String content;
  final PostizPlatformSettings settings;

  PostizIntegrationPost({
    required this.integrationId,
    required this.content,
    required this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': integrationId,
      'content': content,
      'settings': settings.toJson(),
    };
  }
}

/// Base class for platform-specific settings
abstract class PostizPlatformSettings {
  String get platformType;

  Map<String, dynamic> toJson();
}

/// Settings for X (Twitter) posts
class PostizXSettings implements PostizPlatformSettings {
  @override
  String get platformType => 'x';

  final List<String>? imageUrls;
  final String? videoUrl;

  PostizXSettings({
    this.imageUrls,
    this.videoUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__type': platformType,
      if (imageUrls != null && imageUrls!.isNotEmpty) 'image': imageUrls,
      if (videoUrl != null) 'video': videoUrl,
    };
  }
}

/// Settings for LinkedIn posts
class PostizLinkedInSettings implements PostizPlatformSettings {
  @override
  String get platformType => 'linkedin';

  final List<String>? imageUrls;
  final String? videoUrl;

  PostizLinkedInSettings({
    this.imageUrls,
    this.videoUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__type': platformType,
      if (imageUrls != null && imageUrls!.isNotEmpty) 'image': imageUrls,
      if (videoUrl != null) 'video': videoUrl,
    };
  }
}

/// Settings for Instagram posts
class PostizInstagramSettings implements PostizPlatformSettings {
  @override
  String get platformType => 'instagram';

  final List<String>? imageUrls;
  final String? videoUrl;
  final String? type; // 'post', 'reel', 'story'

  PostizInstagramSettings({
    this.imageUrls,
    this.videoUrl,
    this.type = 'post',
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__type': platformType,
      if (imageUrls != null && imageUrls!.isNotEmpty) 'image': imageUrls,
      if (videoUrl != null) 'video': videoUrl,
      if (type != null) 'type': type,
    };
  }
}

/// Settings for Facebook posts
class PostizFacebookSettings implements PostizPlatformSettings {
  @override
  String get platformType => 'facebook';

  final List<String>? imageUrls;
  final String? videoUrl;

  PostizFacebookSettings({
    this.imageUrls,
    this.videoUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__type': platformType,
      if (imageUrls != null && imageUrls!.isNotEmpty) 'image': imageUrls,
      if (videoUrl != null) 'video': videoUrl,
    };
  }
}

/// Settings for Pinterest posts
class PostizPinterestSettings implements PostizPlatformSettings {
  @override
  String get platformType => 'pinterest';

  final String? imageUrl;
  final String? boardId;
  final String? link;

  PostizPinterestSettings({
    this.imageUrl,
    this.boardId,
    this.link,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__type': platformType,
      if (imageUrl != null) 'image': imageUrl,
      if (boardId != null) 'board': boardId,
      if (link != null) 'link': link,
    };
  }
}

/// Settings for platforms without custom settings (Threads, Mastodon, Bluesky, etc.)
class PostizGenericSettings implements PostizPlatformSettings {
  @override
  final String platformType;

  final List<String>? imageUrls;
  final String? videoUrl;

  PostizGenericSettings({
    required this.platformType,
    this.imageUrls,
    this.videoUrl,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      '__type': platformType,
      if (imageUrls != null && imageUrls!.isNotEmpty) 'image': imageUrls,
      if (videoUrl != null) 'video': videoUrl,
    };
  }
}

/// Response from creating a post
class PostizPostResponse {
  final String id;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  PostizPostResponse({
    required this.id,
    required this.createdAt,
    this.metadata,
  });

  factory PostizPostResponse.fromJson(Map<String, dynamic> json) {
    return PostizPostResponse(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] ?? json['created_at'] ?? DateTime.now().toIso8601String()),
      metadata: json,
    );
  }

  @override
  String toString() => 'PostizPostResponse(id: $id, createdAt: $createdAt)';
}

/// Represents a post retrieved from Postiz
class PostizPost {
  final String id;
  final DateTime publishDate;
  final String? status;
  final List<Map<String, dynamic>>? integrations;
  final Map<String, dynamic> raw;

  PostizPost({
    required this.id,
    required this.publishDate,
    this.status,
    this.integrations,
    required this.raw,
  });

  factory PostizPost.fromJson(Map<String, dynamic> json) {
    return PostizPost(
      id: json['id'] as String,
      publishDate: DateTime.parse(json['publishDate'] ?? json['publish_date'] ?? DateTime.now().toIso8601String()),
      status: json['status'] as String?,
      integrations: (json['integrations'] as List<dynamic>?)?.map((e) => e as Map<String, dynamic>).toList(),
      raw: json,
    );
  }

  @override
  String toString() => 'PostizPost(id: $id, status: $status, publishDate: $publishDate)';
}

/// Exception thrown when Postiz API calls fail
class PostizApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? responseBody;

  PostizApiException(
    this.message, {
    this.statusCode,
    this.responseBody,
  });

  @override
  String toString() {
    final buffer = StringBuffer('PostizApiException: $message');
    if (statusCode != null) {
      buffer.write(' (HTTP $statusCode)');
    }
    if (responseBody != null && responseBody!.isNotEmpty) {
      buffer.write('\nResponse: $responseBody');
    }
    return buffer.toString();
  }
}
