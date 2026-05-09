import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';

/// Provider for managing AI logs state.
///
/// Handles fetching, filtering, and displaying AI interaction logs
/// with pagination and statistics.
class AILogsProvider with ChangeNotifier {
  // ====================================================================
  // STATE VARIABLES
  // ====================================================================

  // Logs data
  List<AIInteractionLog> _logs = [];
  Map<String, dynamic>? _statistics;

  // Filters
  String? _selectedInteractionType;
  DateTime? _startDate;
  DateTime? _endDate;

  // Pagination
  final int _limit = 50;
  int _offset = 0;
  bool _hasMore = true;

  // Loading and error states
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // ====================================================================
  // GETTERS
  // ====================================================================

  List<AIInteractionLog> get logs => List.unmodifiable(_logs);
  Map<String, dynamic>? get statistics => _statistics;

  String? get selectedInteractionType => _selectedInteractionType;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  int get limit => _limit;
  int get offset => _offset;
  bool get hasMore => _hasMore;

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasError => _error != null;

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  /// Mock user ID (TODO: Replace with actual auth)
  final int _userId = 1;

  // ====================================================================
  // CONSTRUCTOR
  // ====================================================================

  /// Constructor that initializes the provider
  AILogsProvider() {
    _init();
  }

  /// Initialize the provider by loading initial data
  Future<void> _init() async {
    await Future.wait([
      loadLogs(),
      loadStatistics(),
    ]);
  }

  // ====================================================================
  // DATA LOADING
  // ====================================================================

  /// Loads logs with current filters and pagination
  Future<void> loadLogs({bool reset = false}) async {
    if (reset) {
      _offset = 0;
      _logs.clear();
      _hasMore = true;
    }

    if (_isLoading || _isLoadingMore) return;

    if (reset) {
      _isLoading = true;
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final newLogs = await _client.aILogs.getLogs(
        userId: _userId,
        limit: _limit,
        offset: _offset,
        interactionType: _selectedInteractionType,
        startDate: _startDate,
        endDate: _endDate,
      );

      if (reset) {
        _logs = newLogs;
      } else {
        _logs.addAll(newLogs);
      }

      // Check if there are more logs to load
      _hasMore = newLogs.length >= _limit;
      _offset += newLogs.length;

      _error = null;
    } catch (e) {
      _error = 'Failed to load logs: ${e.toString()}';
      debugPrint('Error loading logs: $e');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Loads more logs (pagination)
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore) return;
    await loadLogs();
  }

  /// Gets total cost for current filters
  Future<double> getTotalCost() async {
    try {
      final cost = await _client.aILogs.getTotalCost(
        userId: _userId,
        startDate: _startDate,
        endDate: _endDate,
      );
      return cost;
    } catch (e) {
      debugPrint('Error getting total cost: $e');
      return 0.0;
    }
  }

  /// Loads statistics for current filters
  Future<void> loadStatistics() async {
    try {
      _statistics = await _client.aILogs.getStatistics(
        userId: _userId,
        startDate: _startDate,
        endDate: _endDate,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading statistics: $e');
      _statistics = null;
      notifyListeners();
    }
  }

  // ====================================================================
  // FILTERS
  // ====================================================================

  /// Sets interaction type filter
  void setInteractionType(String? type) {
    _selectedInteractionType = type;
    notifyListeners();
    loadLogs(reset: true);
    loadStatistics();
  }

  /// Sets date range filter
  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    notifyListeners();
    loadLogs(reset: true);
    loadStatistics();
  }

  /// Clears all filters
  void clearFilters() {
    _selectedInteractionType = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
    loadLogs(reset: true);
    loadStatistics();
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Refreshes all data
  Future<void> refresh() async {
    await Future.wait([
      loadLogs(reset: true),
      loadStatistics(),
    ]);
  }

  /// Clears error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Gets statistics value safely
  T? getStatValue<T>(String key) {
    if (_statistics == null) return null;
    final value = _statistics![key];
    return value is T ? value : null;
  }

  /// Gets interaction type statistics
  Map<String, dynamic>? getInteractionTypeStats(String type) {
    if (_statistics == null) return null;
    final byType = _statistics!['byType'] as Map<String, dynamic>?;
    if (byType == null) return null;
    return byType[type] as Map<String, dynamic>?;
  }
}
