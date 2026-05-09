import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';

/// Provider for managing calendar view, posts by date, and date selection.
///
/// This provider handles:
/// - Selected date and current month tracking
/// - Posts grouped by date for calendar markers
/// - Loading posts for visible month
/// - Date selection and navigation
class CalendarProvider with ChangeNotifier {
  // ====================================================================
  // STATE VARIABLES
  // ====================================================================

  // Date tracking
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  // Posts data
  Map<DateTime, List<Post>> _postsByDate = {};
  bool _isLoading = false;
  String? _error;

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  /// Mock user ID (TODO: Replace with actual auth)
  final int _userId = 1;

  // ====================================================================
  // GETTERS
  // ====================================================================

  DateTime get selectedDate => _selectedDate;
  DateTime get focusedMonth => _focusedMonth;
  Map<DateTime, List<Post>> get postsByDate => Map.unmodifiable(_postsByDate);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;

  // ====================================================================
  // CONSTRUCTOR
  // ====================================================================

  CalendarProvider() {
    _init();
  }

  /// Initialize the provider by loading current month's posts
  Future<void> _init() async {
    await loadPostsForMonth(_focusedMonth);
  }

  // ====================================================================
  // DATE SELECTION & NAVIGATION
  // ====================================================================

  /// Selects a date and notifies listeners
  void selectDate(DateTime date) {
    _selectedDate = _normalizeDate(date);
    notifyListeners();
  }

  /// Changes the focused month and loads posts for that month
  Future<void> setFocusedMonth(DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month, 1);
    if (_focusedMonth != normalizedMonth) {
      _focusedMonth = normalizedMonth;
      notifyListeners();
      await loadPostsForMonth(normalizedMonth);
    }
  }

  /// Navigates to today and loads current month if needed
  Future<void> goToToday() async {
    final today = DateTime.now();
    _selectedDate = _normalizeDate(today);

    final currentMonth = DateTime(today.year, today.month, 1);
    if (_focusedMonth != currentMonth) {
      _focusedMonth = currentMonth;
      await loadPostsForMonth(currentMonth);
    } else {
      notifyListeners();
    }
  }

  // ====================================================================
  // POSTS LOADING
  // ====================================================================

  /// Loads posts for the specified month
  Future<void> loadPostsForMonth(DateTime month) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get first and last day of the month
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

      // Load posts for the month
      final posts = await _client.post.listPosts(
        userId: _userId,
        startDate: firstDay,
        endDate: lastDay,
        limit: 1000, // Load all posts for the month
        offset: 0,
      );

      // Group posts by date
      _postsByDate = _groupPostsByDate(posts);
      _error = null;
    } catch (e) {
      _error = 'Failed to load posts: ${e.toString()}';
      debugPrint('Error loading posts for month: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes posts for the current month
  Future<void> refreshPosts() async {
    await loadPostsForMonth(_focusedMonth);
  }

  // ====================================================================
  // DATA ACCESS
  // ====================================================================

  /// Gets posts for a specific date
  List<Post> getPostsForDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    return _postsByDate[normalizedDate] ?? [];
  }

  /// Gets posts for the currently selected date
  List<Post> getSelectedDatePosts() {
    return getPostsForDate(_selectedDate);
  }

  /// Checks if a date has any posts
  bool hasPostsOnDate(DateTime date) {
    final normalizedDate = _normalizeDate(date);
    final posts = _postsByDate[normalizedDate];
    return posts != null && posts.isNotEmpty;
  }

  /// Gets post count for a specific date
  int getPostCountForDate(DateTime date) {
    return getPostsForDate(date).length;
  }

  /// Gets status counts for a specific date
  Map<String, int> getStatusCountsForDate(DateTime date) {
    final posts = getPostsForDate(date);
    final counts = <String, int>{};

    for (final post in posts) {
      counts[post.status] = (counts[post.status] ?? 0) + 1;
    }

    return counts;
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Groups posts by their scheduled date
  Map<DateTime, List<Post>> _groupPostsByDate(List<Post> posts) {
    final grouped = <DateTime, List<Post>>{};

    for (final post in posts) {
      // Use scheduleTime if available, otherwise use createdAt
      final date = post.scheduleTime ?? post.createdAt;
      final normalizedDate = _normalizeDate(date);

      if (!grouped.containsKey(normalizedDate)) {
        grouped[normalizedDate] = [];
      }
      grouped[normalizedDate]!.add(post);
    }

    // Sort posts within each day by time
    for (final posts in grouped.values) {
      posts.sort((a, b) {
        final aTime = a.scheduleTime ?? a.createdAt;
        final bTime = b.scheduleTime ?? b.createdAt;
        return aTime.compareTo(bTime);
      });
    }

    return grouped;
  }

  /// Normalizes a DateTime to midnight (removes time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Clears error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
