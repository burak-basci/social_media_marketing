import 'package:social_media_marketing_client/social_media_marketing_client.dart';

/// Singleton Serverpod client manager
class ServerpodClientManager {
  static ServerpodClientManager? _instance;
  late final Client _client;

  ServerpodClientManager._({required String serverUrl}) {
    _client = Client(
      serverUrl,
    );
  }

  /// Get the singleton instance
  static ServerpodClientManager get instance {
    if (_instance == null) {
      throw Exception(
        'ServerpodClientManager not initialized. Call initialize() first.',
      );
    }
    return _instance!;
  }

  /// Initialize the client (call this once at app startup)
  static void initialize({required String serverUrl}) {
    _instance = ServerpodClientManager._(serverUrl: serverUrl);
  }

  /// Get the Serverpod client
  Client get client => _client;

  /// Close the client connection
  void dispose() {
    _client.close();
  }
}

/// Extension to easily access the client from anywhere
extension ServerpodClientX on Client {
  /// Get the client instance
  static Client get instance => ServerpodClientManager.instance.client;
}
