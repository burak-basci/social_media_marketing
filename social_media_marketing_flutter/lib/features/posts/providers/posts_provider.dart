import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';

/// Provider for managing posts list, filters, and CRUD operations.
///
/// This provider handles:
/// - Posts list with pagination
/// - Filters: status, platform, date range, search query
/// - CRUD operations: load, update, delete, duplicate, publish
/// - Selected post for detail view
/// - Loading and error states
class PostsProvider with ChangeNotifier {
  // ====================================================================
  // STATE VARIABLES
  // ====================================================================

  // Posts list
  List<Post> _posts = [];
  bool _isLoading = false;
  String? _error;

  // Pagination
  int _limit = 50;
  int _offset = 0;
  bool _hasMore = true;

  // Filters
  List<String> _statusFilter = [];
  List<String> _platformFilter = [];
  DateTime? _startDate;
  DateTime? _endDate;
  String _searchQuery = '';

  // Search debouncing
  Timer? _searchDebounce;

  // Selected post for detail view
  Post? _selectedPost;

  // Operation states
  bool _isUpdating = false;
  bool _isDeleting = false;
  bool _isDuplicating = false;
  bool _isPublishing = false;

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  /// Mock user ID (TODO: Replace with actual auth)
  final int _userId = 1;

  // ====================================================================
  // GETTERS
  // ====================================================================

  List<Post> get posts => List.unmodifiable(_posts);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasMore => _hasMore;

  // Filters
  List<String> get statusFilter => List.unmodifiable(_statusFilter);
  List<String> get platformFilter => List.unmodifiable(_platformFilter);
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String get searchQuery => _searchQuery;

  // Selected post
  Post? get selectedPost => _selectedPost;

  // Operation states
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  bool get isDuplicating => _isDuplicating;
  bool get isPublishing => _isPublishing;

  // Helper getters
  bool get hasActiveFilters =>
      _statusFilter.isNotEmpty ||
      _platformFilter.isNotEmpty ||
      _startDate != null ||
      _endDate != null ||
      _searchQuery.isNotEmpty;

  int get totalPosts => _posts.length;

  // ====================================================================
  // CONSTRUCTOR
  // ====================================================================

  PostsProvider() {
    _init();
  }

  /// Initialize the provider by loading posts
  Future<void> _init() async {
    await loadPosts();
  }

  // ====================================================================
  // POSTS LOADING
  // ====================================================================

  /// Loads posts with current filters and pagination
  Future<void> loadPosts({bool reset = false}) async {
    if (reset) {
      _offset = 0;
      _posts = [];
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loadedPosts = await _client.post.listPosts(
        userId: _userId,
        statusFilter: _statusFilter.isNotEmpty ? _statusFilter : null,
        platformFilter: _platformFilter.isNotEmpty ? _platformFilter : null,
        startDate: _startDate,
        endDate: _endDate,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        limit: _limit,
        offset: _offset,
      );

      if (reset) {
        _posts = loadedPosts;
      } else {
        _posts.addAll(loadedPosts);
      }

      _hasMore = loadedPosts.length >= _limit;
      _offset += loadedPosts.length;
      _error = null;
    } catch (e) {
      _error = 'Failed to load posts: ${e.toString()}';
      debugPrint('Error loading posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes the posts list (pull to refresh)
  Future<void> refreshPosts() async {
    await loadPosts(reset: true);
  }

  /// Loads more posts (pagination)
  Future<void> loadMorePosts() async {
    await loadPosts();
  }

  // ====================================================================
  // FILTERS
  // ====================================================================

  /// Sets status filter
  void setStatusFilter(List<String> statuses) {
    _statusFilter = List.from(statuses);
    _applyFilters();
  }

  /// Toggles a status in the filter
  void toggleStatusFilter(String status) {
    if (_statusFilter.contains(status)) {
      _statusFilter.remove(status);
    } else {
      _statusFilter.add(status);
    }
    _applyFilters();
  }

  /// Sets platform filter
  void setPlatformFilter(List<String> platforms) {
    _platformFilter = List.from(platforms);
    _applyFilters();
  }

  /// Toggles a platform in the filter
  void togglePlatformFilter(String platform) {
    if (_platformFilter.contains(platform)) {
      _platformFilter.remove(platform);
    } else {
      _platformFilter.add(platform);
    }
    _applyFilters();
  }

  /// Sets date range filter
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
  }

  /// Sets search query with debouncing
  void setSearchQuery(String query) {
    _searchQuery = query;

    // Cancel previous debounce timer
    _searchDebounce?.cancel();

    // Debounce for 500ms
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });

    notifyListeners();
  }

  /// Clears all filters
  void clearFilters() {
    _statusFilter = [];
    _platformFilter = [];
    _startDate = null;
    _endDate = null;
    _searchQuery = '';
    _searchDebounce?.cancel();
    _applyFilters();
  }

  /// Applies filters and reloads posts
  void _applyFilters() {
    loadPosts(reset: true);
  }

  // ====================================================================
  // CRUD OPERATIONS
  // ====================================================================

  /// Updates a post
  Future<void> updatePost({
    required int postId,
    String? status,
    DateTime? scheduleTime,
    Map<String, String>? editedContent,
    String? title,
  }) async {
    _isUpdating = true;
    _error = null;
    notifyListeners();

    try {
      final updatedPost = await _client.post.updatePost(
        userId: _userId,
        postId: postId,
        status: status,
        scheduleTime: scheduleTime,
        editedContent: editedContent,
        title: title,
      );

      // Update post in the list
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = updatedPost;
      }

      // Update selected post if it's the same
      if (_selectedPost?.id == postId) {
        _selectedPost = updatedPost;
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to update post: ${e.toString()}';
      debugPrint('Error updating post: $e');
      rethrow;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  /// Deletes a post
  Future<void> deletePost(int postId) async {
    _isDeleting = true;
    _error = null;
    notifyListeners();

    try {
      await _client.post.deletePost(
        userId: _userId,
        postId: postId,
      );

      // Remove post from the list
      _posts.removeWhere((p) => p.id == postId);

      // Clear selected post if it's the deleted one
      if (_selectedPost?.id == postId) {
        _selectedPost = null;
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to delete post: ${e.toString()}';
      debugPrint('Error deleting post: $e');
      rethrow;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  /// Duplicates a post
  Future<Post> duplicatePost(int postId) async {
    _isDuplicating = true;
    _error = null;
    notifyListeners();

    try {
      final duplicatedPost = await _client.post.duplicatePost(
        userId: _userId,
        postId: postId,
      );

      // Add duplicated post to the beginning of the list
      _posts.insert(0, duplicatedPost);

      _error = null;
      return duplicatedPost;
    } catch (e) {
      _error = 'Failed to duplicate post: ${e.toString()}';
      debugPrint('Error duplicating post: $e');
      rethrow;
    } finally {
      _isDuplicating = false;
      notifyListeners();
    }
  }

  /// Publishes a post immediately
  Future<void> publishNow(int postId) async {
    _isPublishing = true;
    _error = null;
    notifyListeners();

    try {
      final publishedPost = await _client.post.publishNow(
        userId: _userId,
        postId: postId,
      );

      // Update post in the list
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = publishedPost;
      }

      // Update selected post if it's the same
      if (_selectedPost?.id == postId) {
        _selectedPost = publishedPost;
      }

      _error = null;
    } catch (e) {
      _error = 'Failed to publish post: ${e.toString()}';
      debugPrint('Error publishing post: $e');
      rethrow;
    } finally {
      _isPublishing = false;
      notifyListeners();
    }
  }

  /// Selects a post for detail view
  Future<void> selectPost(int postId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final post = await _client.post.getPost(
        userId: _userId,
        postId: postId,
      );

      _selectedPost = post;
      _error = null;
    } catch (e) {
      _error = 'Failed to load post: ${e.toString()}';
      debugPrint('Error loading post: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears the selected post
  void clearSelectedPost() {
    _selectedPost = null;
    notifyListeners();
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Parses JSON content map from string
  Map<String, String> parseContentMap(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value.toString()));
      }
      return {};
    } catch (e) {
      debugPrint('Error parsing content map: $e');
      return {};
    }
  }

  /// Parses JSON platform list from string
  List<String> parsePlatformList(String jsonString) {
    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error parsing platform list: $e');
      return [];
    }
  }

  /// Gets content for a post (edited if available, otherwise AI-generated)
  Map<String, String> getPostContent(Post post) {
    if (post.editedContent != null && post.editedContent!.isNotEmpty) {
      return parseContentMap(post.editedContent!);
    }
    return parseContentMap(post.aiGeneratedContent);
  }

  /// Gets platforms for a post
  List<String> getPostPlatforms(Post post) {
    return parsePlatformList(post.selectedPlatforms);
  }

  /// Clears error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
