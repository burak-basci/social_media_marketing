import 'package:flutter/foundation.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../services/serverpod_client.dart';
import '../../../services/auth_service.dart';

/// Provider for managing settings page state and operations
class SettingsProvider with ChangeNotifier {
  // ====================================================================
  // STATE VARIABLES
  // ====================================================================

  // User data
  User? _user;
  Organization? _organization;

  // Loading states
  bool _isLoading = false;
  bool _isSaving = false;

  // Error states
  String? _error;

  // Form states
  bool _hasUnsavedChanges = false;

  // ====================================================================
  // GETTERS
  // ====================================================================

  User? get user => _user;
  Organization? get organization => _organization;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasUnsavedChanges => _hasUnsavedChanges;
  bool get isAdmin => _user?.role == 'admin';

  /// Serverpod client instance
  Client get _client => ServerpodClientManager.instance.client;

  // ====================================================================
  // CONSTRUCTOR
  // ====================================================================

  /// Constructor that initializes the provider
  SettingsProvider() {
    _init();
  }

  /// Initialize the provider by loading settings
  Future<void> _init() async {
    await loadSettings();
  }

  // ====================================================================
  // LOAD SETTINGS
  // ====================================================================

  /// Loads user and organization settings
  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get user ID from auth service
      final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Load user and organization data
      final settings = await _client.settings.getUserSettings(userId: userId);

      _user = settings['user'] as User?;
      _organization = settings['organization'] as Organization?;

      _error = null;
    } catch (e) {
      _error = 'Failed to load settings: ${e.toString()}';
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // UPDATE USER PROFILE
  // ====================================================================

  /// Updates user profile (full name, email)
  Future<bool> updateUserProfile({
    required String fullName,
    required String email,
  }) async {
    if (_user == null) {
      _error = 'User not loaded';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updatedUser = await _client.settings.updateUserProfile(
        userId: userId,
        fullName: fullName.trim(),
        email: email.trim(),
      );

      // Update local user data
      _user = updatedUser;
      _hasUnsavedChanges = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
      debugPrint('Error updating user profile: $e');
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // UPDATE PASSWORD
  // ====================================================================

  /// Updates user password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_user == null) {
      _error = 'User not loaded';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _client.settings.updatePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update password: ${e.toString()}';
      debugPrint('Error updating password: $e');
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // UPDATE ORGANIZATION
  // ====================================================================

  /// Updates organization settings (admin only)
  Future<bool> updateOrganization({
    required String organizationName,
    String? postizApiKey,
    String? geminiApiKey,
  }) async {
    if (!isAdmin) {
      _error = 'Only admins can update organization settings';
      notifyListeners();
      return false;
    }

    if (_organization == null) {
      _error = 'Organization not loaded';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updatedOrganization = await _client.settings.updateOrganization(
        userId: userId,
        name: organizationName.trim(),
        postizApiKey: postizApiKey?.trim(),
        geminiApiKey: geminiApiKey?.trim(),
      );

      // Update local organization data
      _organization = updatedOrganization;
      _hasUnsavedChanges = false;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update organization: ${e.toString()}';
      debugPrint('Error updating organization: $e');
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // DEACTIVATE ACCOUNT
  // ====================================================================

  /// Deactivates user account (requires password confirmation)
  Future<bool> deactivateAccount({
    required String password,
  }) async {
    if (_user == null) {
      _error = 'User not loaded';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await AuthService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      await _client.settings.deactivateAccount(
        userId: userId,
        password: password,
      );

      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to deactivate account: ${e.toString()}';
      debugPrint('Error deactivating account: $e');
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Marks that there are unsaved changes
  void markUnsavedChanges() {
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  /// Clears unsaved changes flag
  void clearUnsavedChanges() {
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  /// Clears error state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Masks API key for display (shows last 4 characters)
  String maskApiKey(String? apiKey) {
    if (apiKey == null || apiKey.isEmpty) {
      return '';
    }
    if (apiKey.length <= 4) {
      return apiKey;
    }
    final visiblePart = apiKey.substring(apiKey.length - 4);
    final maskedPart = '•' * (apiKey.length - 4);
    return '$maskedPart$visiblePart';
  }
}
