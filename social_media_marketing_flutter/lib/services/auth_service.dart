import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'serverpod_client.dart';

/// Service for handling authentication and session persistence
///
/// NOTE: This is a simplified implementation because the backend's custom
/// auth endpoint doesn't use Serverpod's built-in session management.
/// It just stores user credentials locally. For production, integrate with
/// Serverpod's auth module or implement proper JWT tokens.
class AuthService {
  static const String _keyIsAuthenticated = 'is_authenticated';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';

  /// Save authentication session
  static Future<void> saveSession(
    int userId,
    String email,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsAuthenticated, true);
      await prefs.setInt(_keyUserId, userId);
      await prefs.setString(_keyUserEmail, email);
      debugPrint('✓ Session saved for user: $email (ID: $userId)');
    } catch (e) {
      debugPrint('✗ Error saving session: $e');
    }
  }

  /// Restore authentication session from storage
  /// Returns true if a session was restored
  static Future<bool> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool(_keyIsAuthenticated) ?? false;
      final userId = prefs.getInt(_keyUserId);
      final userEmail = prefs.getString(_keyUserEmail);

      if (isAuth && userId != null && userEmail != null) {
        // Validate the session is still valid by making a test API call
        try {
          final client = ServerpodClientManager.instance.client;
          await client.auth.getCurrentUser(userId: userId);
          debugPrint('✓ Session restored for user: $userEmail (ID: $userId)');
          return true;
        } catch (e) {
          // Session invalid, clear it
          debugPrint('✗ Saved session invalid, clearing: $e');
          await clearSession();
          return false;
        }
      } else {
        debugPrint('○ No saved session found');
      }
    } catch (e) {
      debugPrint('✗ Error restoring session: $e');
    }
    return false;
  }

  /// Clear session on logout
  static Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsAuthenticated);
      await prefs.remove(_keyUserId);
      await prefs.remove(_keyUserEmail);
      debugPrint('✓ Session cleared successfully');
    } catch (e) {
      debugPrint('✗ Error clearing session: $e');
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isAuth = prefs.getBool(_keyIsAuthenticated) ?? false;

      // If we think we're authenticated, validate it
      if (isAuth) {
        final userId = prefs.getInt(_keyUserId);
        if (userId != null) {
          try {
            final client = ServerpodClientManager.instance.client;
            await client.auth.getCurrentUser(userId: userId);
            return true;
          } catch (e) {
            // Session invalid
            await clearSession();
            return false;
          }
        }
      }
      return false;
    } catch (e) {
      debugPrint('✗ Error checking authentication: $e');
      return false;
    }
  }

  /// Get current user ID
  static Future<int?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_keyUserId);
    } catch (e) {
      debugPrint('✗ Error getting user ID: $e');
      return null;
    }
  }

  /// Get current user email
  static Future<String?> getUserEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserEmail);
    } catch (e) {
      debugPrint('✗ Error getting user email: $e');
      return null;
    }
  }
}
