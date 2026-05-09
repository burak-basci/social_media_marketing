import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Settings endpoint for user and organization settings management.
///
/// Provides methods for:
/// - Getting user profile and organization information
/// - Updating user profile (name, email)
/// - Changing user password
/// - Updating organization settings (admin only)
/// - Deactivating user accounts
///
/// Example usage from client:
/// ```dart
/// // Get user settings
/// final settings = await client.settings.getUserSettings(userId: 1);
///
/// // Update user profile
/// final updatedUser = await client.settings.updateUserProfile(
///   userId: 1,
///   fullName: 'Jane Doe',
///   email: 'jane@example.com',
/// );
///
/// // Change password
/// await client.settings.updatePassword(
///   userId: 1,
///   currentPassword: 'old_password',
///   newPassword: 'new_secure_password',
/// );
///
/// // Update organization (admin only)
/// final updatedOrg = await client.settings.updateOrganization(
///   userId: 1,
///   name: 'New Company Name',
///   postizApiKey: 'new_api_key',
/// );
/// ```
class SettingsEndpoint extends Endpoint {
  /// Gets user profile and organization information.
  ///
  /// Returns both the user profile and their organization details
  /// in a single call for the settings page.
  ///
  /// Parameters:
  /// - [userId] - The user ID to fetch settings for
  ///
  /// Returns: Map containing:
  /// - 'user': User object without password hash
  /// - 'organization': Organization object
  ///
  /// Throws:
  /// - [Exception] if user or organization not found
  Future<Map<String, dynamic>> getUserSettings(
    Session session, {
    required int userId,
  }) async {
    try {
      session.log('Fetching settings for user $userId');

      // Load user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Load organization
      final organization = await Organization.db.findById(
        session,
        user.organizationId,
      );
      if (organization == null) {
        throw Exception('Organization not found');
      }

      session.log('Settings retrieved successfully for ${user.email}');

      return {
        'user': user.copyWith(passwordHash: '[REDACTED]').toJson(),
        'organization': organization.toJson(),
      };
    } catch (e) {
      session.log('Failed to get user settings: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Updates user's name and email.
  ///
  /// Allows users to update their profile information. Email must be
  /// unique across the system.
  ///
  /// Parameters:
  /// - [userId] - User ID to update
  /// - [fullName] - Optional new full name
  /// - [email] - Optional new email address
  ///
  /// Returns: Updated User object without password hash
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if email is already in use
  /// - [Exception] if email format is invalid
  Future<User> updateUserProfile(
    Session session, {
    required int userId,
    String? fullName,
    String? email,
  }) async {
    try {
      session.log('Updating profile for user $userId');

      // At least one field must be provided
      if (fullName == null && email == null) {
        throw Exception('At least one field must be provided for update');
      }

      // Load user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Validate and check email uniqueness if email is being updated
      if (email != null && email.trim().isNotEmpty) {
        _validateEmail(email);

        // Check if email is already in use by another user
        final existingUser = await User.db.findFirstRow(
          session,
          where: (t) =>
              t.email.equals(email.toLowerCase().trim()) &
              t.id.notEquals(userId),
        );

        if (existingUser != null) {
          throw Exception('Email already in use');
        }
      }

      // Validate full name if provided
      if (fullName != null && fullName.trim().isEmpty) {
        throw Exception('Full name cannot be empty');
      }

      // Update user
      final updatedUser = user.copyWith(
        fullName: fullName?.trim() ?? user.fullName,
        email: email?.toLowerCase().trim() ?? user.email,
      );

      final result = await User.db.updateRow(session, updatedUser);

      session.log('Profile updated successfully for ${result.email}');

      // Return without password hash
      return result.copyWith(passwordHash: '[REDACTED]');
    } catch (e) {
      session.log('Profile update failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Changes user password.
  ///
  /// Requires current password verification before allowing the change.
  /// New password must meet security requirements.
  ///
  /// Parameters:
  /// - [userId] - User ID
  /// - [currentPassword] - Current password for verification
  /// - [newPassword] - New password (min 8 characters)
  ///
  /// Returns: Success message string
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if current password is incorrect
  /// - [Exception] if new password doesn't meet requirements
  Future<String> updatePassword(
    Session session, {
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      session.log('Password change requested for user $userId');

      // Validate new password
      _validatePassword(newPassword);

      // Load user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Verify current password
      if (!_verifyPassword(currentPassword, user.passwordHash)) {
        throw Exception('Current password is incorrect');
      }

      // Ensure new password is different from current
      if (currentPassword == newPassword) {
        throw Exception('New password must be different from current password');
      }

      // Hash new password
      final newPasswordHash = _hashPassword(newPassword);

      // Update password
      await User.db.updateRow(
        session,
        user.copyWith(passwordHash: newPasswordHash),
      );

      session.log('Password changed successfully for ${user.email}');
      return 'Password changed successfully';
    } catch (e) {
      session.log('Password change failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Updates organization settings (admin only).
  ///
  /// Allows organization admins to update organization name and API keys.
  /// Regular users cannot access this endpoint.
  ///
  /// Parameters:
  /// - [userId] - User ID (must have admin role)
  /// - [name] - Optional new organization name
  /// - [postizApiKey] - Optional Postiz API key
  /// - [geminiApiKey] - Optional Gemini API key
  ///
  /// Returns: Updated Organization object
  ///
  /// Throws:
  /// - [Exception] if user is not admin
  /// - [Exception] if user or organization not found
  /// - [Exception] if no fields provided for update
  Future<Organization> updateOrganization(
    Session session, {
    required int userId,
    String? name,
    String? postizApiKey,
    String? geminiApiKey,
  }) async {
    try {
      session.log('Organization update requested by user $userId');

      // At least one field must be provided
      if (name == null && postizApiKey == null && geminiApiKey == null) {
        throw Exception('At least one field must be provided for update');
      }

      // Load user and verify admin role
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      if (user.role != 'admin') {
        throw Exception('Access denied: Only admins can update organization settings');
      }

      // Load organization
      final organization = await Organization.db.findById(
        session,
        user.organizationId,
      );
      if (organization == null) {
        throw Exception('Organization not found');
      }

      // Validate organization name if provided
      if (name != null && name.trim().isEmpty) {
        throw Exception('Organization name cannot be empty');
      }

      // Update organization
      final updatedOrganization = organization.copyWith(
        name: name?.trim() ?? organization.name,
        postizApiKey: postizApiKey ?? organization.postizApiKey,
        geminiApiKey: geminiApiKey ?? organization.geminiApiKey,
      );

      final result = await Organization.db.updateRow(session, updatedOrganization);

      session.log('Organization updated successfully: ${result.name}');
      return result;
    } catch (e) {
      session.log('Organization update failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Deactivates user account (soft delete).
  ///
  /// Marks the user account as inactive without deleting data.
  /// Requires password confirmation for security.
  ///
  /// Parameters:
  /// - [userId] - User ID to deactivate
  /// - [password] - Password confirmation
  ///
  /// Returns: Success message string
  ///
  /// Throws:
  /// - [Exception] if user not found
  /// - [Exception] if password is incorrect
  /// - [Exception] if account is already inactive
  Future<String> deactivateAccount(
    Session session, {
    required int userId,
    required String password,
  }) async {
    try {
      session.log('Account deactivation requested for user $userId');

      // Load user
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Check if already inactive
      if (!user.isActive) {
        throw Exception('Account is already inactive');
      }

      // Verify password
      if (!_verifyPassword(password, user.passwordHash)) {
        throw Exception('Password is incorrect');
      }

      // Deactivate account (soft delete)
      await User.db.updateRow(
        session,
        user.copyWith(isActive: false),
      );

      session.log('Account deactivated successfully for ${user.email}');
      return 'Account deactivated successfully. Contact support to reactivate.';
    } catch (e) {
      session.log('Account deactivation failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  // ==========================================================================
  // PRIVATE HELPER METHODS
  // ==========================================================================

  /// Validates email format using regex.
  ///
  /// Throws [Exception] if email format is invalid.
  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
  }

  /// Validates password strength.
  ///
  /// Requirements:
  /// - Minimum 8 characters
  ///
  /// Throws [Exception] if password doesn't meet requirements.
  void _validatePassword(String password) {
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters long');
    }

    // Additional validation rules can be added here:
    // - Must contain uppercase letter
    // - Must contain lowercase letter
    // - Must contain number
    // - Must contain special character
  }

  /// Hashes a password using SHA-256.
  ///
  /// Note: In production, use bcrypt or argon2 for better security.
  /// This is a simplified implementation matching the auth endpoint.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies a password against its hash.
  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }
}

// ==========================================================================
// DATA TRANSFER OBJECTS
// ==========================================================================

/// User settings response containing user and organization data.
class UserSettingsResponse {
  final User user;
  final Organization organization;

  UserSettingsResponse({
    required this.user,
    required this.organization,
  });

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'organization': organization.toJson(),
      };
}
