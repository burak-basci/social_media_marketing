import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';

/// Provider for managing social media connections.
///
/// This provider handles:
/// - List of connections (List<SocialMediaConnection>)
/// - Connection status map (Map<String, bool>)
/// - Loading states
/// - Methods: loadConnections(), syncFromPostiz(), disconnectPlatform(), getConnectionStatus()
class ConnectionsProvider with ChangeNotifier {
  // ====================================================================
  // STATE VARIABLES
  // ====================================================================

  // Connections list
  List<SocialMediaConnection> _connections = [];
  bool _isLoading = false;
  String? _error;

  // Connection status map (platform -> isConnected)
  Map<String, bool> _connectionStatus = {};

  // Operation states
  bool _isSyncing = false;
  bool _isDisconnecting = false;

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  /// Mock user ID (TODO: Replace with actual auth)
  final int _userId = 1;

  // ====================================================================
  // GETTERS
  // ====================================================================

  List<SocialMediaConnection> get connections =>
      List.unmodifiable(_connections);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  Map<String, bool> get connectionStatus =>
      Map.unmodifiable(_connectionStatus);

  // Operation states
  bool get isSyncing => _isSyncing;
  bool get isDisconnecting => _isDisconnecting;

  // Helper getters
  int get connectedCount =>
      _connectionStatus.values.where((connected) => connected).length;
  bool get hasConnections => _connections.isNotEmpty;

  // ====================================================================
  // CONSTRUCTOR
  // ====================================================================

  ConnectionsProvider() {
    _init();
  }

  /// Initialize the provider by loading connections
  Future<void> _init() async {
    await loadConnections();
  }

  // ====================================================================
  // CONNECTIONS LOADING
  // ====================================================================

  /// Loads all connections for the user's organization
  Future<void> loadConnections() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load connections list
      _connections = await _client.connections.listConnections(
        userId: _userId,
      );

      // Load connection status
      _connectionStatus = await _client.connections.getConnectionStatus(
        userId: _userId,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to load connections: ${e.toString()}';
      debugPrint('Error loading connections: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refreshes the connections list
  Future<void> refreshConnections() async {
    await loadConnections();
  }

  // ====================================================================
  // SYNC FROM POSTIZ
  // ====================================================================

  /// Syncs connections from Postiz API
  ///
  /// This fetches all integrations from Postiz and creates/updates
  /// connection records in the database.
  Future<void> syncFromPostiz() async {
    if (_isSyncing) return;

    _isSyncing = true;
    _error = null;
    notifyListeners();

    try {
      // Sync connections from Postiz
      final syncedConnections = await _client.connections.syncFromPostiz(
        userId: _userId,
      );

      // Update local state
      _connections = syncedConnections;

      // Reload connection status
      _connectionStatus = await _client.connections.getConnectionStatus(
        userId: _userId,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to sync from Postiz: ${e.toString()}';
      debugPrint('Error syncing from Postiz: $e');
      rethrow;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // DISCONNECT PLATFORM
  // ====================================================================

  /// Disconnects a platform by removing the connection record
  ///
  /// NOTE: This only removes from our database. Users must disconnect
  /// from Postiz directly to revoke access.
  Future<void> disconnectPlatform(int connectionId) async {
    _isDisconnecting = true;
    _error = null;
    notifyListeners();

    try {
      // Disconnect platform
      await _client.connections.disconnectPlatform(
        userId: _userId,
        connectionId: connectionId,
      );

      // Remove from local list
      _connections.removeWhere((c) => c.id == connectionId);

      // Reload connection status
      _connectionStatus = await _client.connections.getConnectionStatus(
        userId: _userId,
      );

      _error = null;
    } catch (e) {
      _error = 'Failed to disconnect platform: ${e.toString()}';
      debugPrint('Error disconnecting platform: $e');
      rethrow;
    } finally {
      _isDisconnecting = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Gets connection status for a specific platform
  bool isPlatformConnected(String platform) {
    return _connectionStatus[platform.toLowerCase()] ?? false;
  }

  /// Gets connection for a specific platform (if exists)
  SocialMediaConnection? getConnectionForPlatform(String platform) {
    try {
      return _connections.firstWhere(
        (c) => c.platform.toLowerCase() == platform.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Clears error state
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
