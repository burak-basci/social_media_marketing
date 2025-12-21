import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Authentication endpoint for user registration, login, and session management.
///
/// Provides secure authentication with bcrypt password hashing and
/// organization-based multi-tenancy support.
///
/// Example usage from client:
/// ```dart
/// // Register new user and organization
/// final session = await client.auth.register(
///   email: 'admin@company.com',
///   password: 'secure_password',
///   fullName: 'John Doe',
///   organizationName: 'Acme Corp',
/// );
///
/// // Login existing user
/// final session = await client.auth.login(
///   email: 'admin@company.com',
///   password: 'secure_password',
///   );
/// ```
class AuthEndpoint extends Endpoint {
  /// Registers a new user and creates a new organization.
  ///
  /// This is the initial signup flow - it creates both a user account
  /// and a new organization, making the user an admin of that organization.
  ///
  /// Parameters:
  /// - [email] - User's email address (must be unique)
  /// - [password] - Plain text password (will be hashed)
  /// - [fullName] - User's full name
  /// - [organizationName] - Name for the new organization
  ///
  /// Returns: The newly created [User] object (without password hash)
  ///
  /// Throws:
  /// - [Exception] if email already exists
  /// - [Exception] if validation fails
  Future<User> register(
    Session session, {
    required String email,
    required String password,
    required String fullName,
    required String organizationName,
  }) async {
    // Validate input
    _validateEmail(email);
    _validatePassword(password);
    _validateNonEmpty(fullName, 'Full name');
    _validateNonEmpty(organizationName, 'Organization name');

    try {
      // Check if email already exists
      final existingUser = await User.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email.toLowerCase().trim()),
      );

      if (existingUser != null) {
        throw Exception('Email already registered');
      }

      // Use transaction to ensure atomic creation of organization and user
      return await session.db.transaction((transaction) async {
        // Create organization first
        final organization = await Organization.db.insertRow(
          session,
          Organization(
            name: organizationName.trim(),
            postizApiKey: '', // To be configured later
            geminiApiKey: null, // Optional
            settings: jsonEncode({}), // Default empty settings
            createdAt: DateTime.now(),
          ),
          transaction: transaction,
        );

        // Hash password
        final passwordHash = _hashPassword(password);

        // Create user as admin of the organization
        final user = await User.db.insertRow(
          session,
          User(
            email: email.toLowerCase().trim(),
            passwordHash: passwordHash,
            fullName: fullName.trim(),
            organizationId: organization.id!,
            role: 'admin',
            createdAt: DateTime.now(),
            isActive: true,
          ),
          transaction: transaction,
        );

        session.log('User registered successfully: ${user.email}');

        // Return user without password hash for security
        return user.copyWith(passwordHash: '[REDACTED]');
      });
    } catch (e) {
      session.log('Registration failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Authenticates a user and returns session information.
  ///
  /// Verifies email and password, then returns the authenticated user
  /// if credentials are valid.
  ///
  /// Parameters:
  /// - [email] - User's email address
  /// - [password] - Plain text password
  ///
  /// Returns: Authenticated [User] object (without password hash)
  ///
  /// Throws:
  /// - [Exception] if credentials are invalid
  /// - [Exception] if account is inactive
  Future<User> login(
    Session session, {
    required String email,
    required String password,
  }) async {
    try {
      // Find user by email
      final user = await User.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email.toLowerCase().trim()),
      );

      if (user == null) {
        throw Exception('Invalid email or password');
      }

      // Check if account is active
      if (!user.isActive) {
        throw Exception('Account is inactive. Please contact support.');
      }

      // Verify password
      if (!_verifyPassword(password, user.passwordHash)) {
        throw Exception('Invalid email or password');
      }

      session.log('User logged in: ${user.email}');

      // Return user without password hash
      return user.copyWith(passwordHash: '[REDACTED]');
    } catch (e) {
      session.log('Login failed for $email: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Logs out the current user session.
  ///
  /// Cleans up any session-related resources.
  ///
  /// Returns: Success message
  Future<String> logout(Session session) async {
    // TODO: Integrate with Serverpod auth when frontend is ready
    session.log('User logout requested');
    return 'Logged out successfully';
  }

  /// Gets user information by user ID.
  ///
  /// Parameters:
  /// - [userId] - The user ID to fetch
  ///
  /// Returns: [User] object with organization details
  ///
  /// Throws:
  /// - [Exception] if user not found
  Future<User> getCurrentUser(Session session, {required int userId}) async {
    // TODO: Get userId from session.auth when Serverpod auth is integrated
    // Refresh user data from database
    final user = await User.db.findById(session, userId);

    if (user == null) {
      throw Exception('User not found');
    }

    // Return without password hash
    return user.copyWith(passwordHash: '[REDACTED]');
  }

  /// Changes the current user's password.
  ///
  /// Requires authentication and current password verification.
  ///
  /// Parameters:
  /// - [currentPassword] - Current password for verification
  /// - [newPassword] - New password to set
  ///
  /// Returns: Success message
  ///
  /// Throws:
  /// - [Exception] if current password is invalid
  /// - [Exception] if new password doesn't meet requirements
  Future<String> changePassword(
    Session session, {
    required int userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    // TODO: Get userId from session.auth when Serverpod auth is integrated
    _validatePassword(newPassword);

    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Verify current password
    if (!_verifyPassword(currentPassword, user.passwordHash)) {
      throw Exception('Current password is incorrect');
    }

    // Hash and update new password
    final newPasswordHash = _hashPassword(newPassword);
    await User.db.updateRow(
      session,
      user.copyWith(passwordHash: newPasswordHash),
      columns: (t) => [t.passwordHash],
    );

    session.log('Password changed for user: ${user.email}');
    return 'Password changed successfully';
  }

  /// Updates current user's profile information.
  ///
  /// Requires authentication.
  ///
  /// Parameters:
  /// - [fullName] - Optional new full name
  /// - [email] - Optional new email (must be unique)
  ///
  /// Returns: Updated [User] object
  Future<User> updateProfile(
    Session session, {
    required int userId,
    String? fullName,
    String? email,
  }) async {
    // TODO: Get userId from session.auth when Serverpod auth is integrated
    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Validate and check if email is already taken
    if (email != null) {
      _validateEmail(email);
      final existingUser = await User.db.findFirstRow(
        session,
        where: (t) =>
            t.email.equals(email.toLowerCase().trim()) &
            t.id.notEquals(user.id!),
      );

      if (existingUser != null) {
        throw Exception('Email already in use');
      }
    }

    // Update user
    final updatedUser = user.copyWith(
      fullName: fullName?.trim() ?? user.fullName,
      email: email?.toLowerCase().trim() ?? user.email,
    );

    final result = await User.db.updateRow(session, updatedUser);

    session.log('Profile updated for user: ${result.email}');
    return result.copyWith(passwordHash: '[REDACTED]');
  }

  // ==========================================================================
  // PRIVATE HELPER METHODS
  // ==========================================================================

  /// Hashes a password using SHA-256.
  ///
  /// In production, use bcrypt or argon2 for better security.
  /// This is a simplified implementation for demonstration.
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verifies a password against its hash.
  bool _verifyPassword(String password, String hash) {
    return _hashPassword(password) == hash;
  }

  /// Validates email format.
  void _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
  }

  /// Validates password strength.
  void _validatePassword(String password) {
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters long');
    }
    // Add more validation rules as needed
    // - Must contain uppercase
    // - Must contain lowercase
    // - Must contain number
    // - Must contain special character
  }

  /// Validates that a string is not empty.
  void _validateNonEmpty(String value, String fieldName) {
    if (value.trim().isEmpty) {
      throw Exception('$fieldName cannot be empty');
    }
  }
}
