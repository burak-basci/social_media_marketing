import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Company Profile endpoint for managing company brand information.
///
/// Provides CRUD operations for company profiles within an organization.
/// Company profiles contain brand voice, description, and uploaded files
/// that are used as context for AI content generation.
///
/// Example usage from client:
/// ```dart
/// // List all company profiles for organization
/// final profiles = await client.company.listCompanyProfiles(
///   userId: currentUser.id,
/// );
///
/// // Create new company profile
/// final profile = await client.company.createCompanyProfile(
///   userId: currentUser.id,
///   name: 'Acme Corp',
///   description: 'Leading provider of innovative solutions',
///   brandVoice: 'Professional, friendly, innovative',
///   uploadedFiles: ['file1.pdf', 'logo.png'],
/// );
/// ```
class CompanyEndpoint extends Endpoint {
  /// Lists all company profiles for the user's organization.
  ///
  /// Returns company profiles filtered by the user's organization ID
  /// to ensure multi-tenant isolation.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (to get organization ID)
  ///
  /// Returns: List of CompanyProfile objects
  ///
  /// Throws:
  /// - [Exception] if user not found
  Future<List<CompanyProfile>> listCompanyProfiles(
    Session session, {
    required int userId,
  }) async {
    try {
      session.log('Listing company profiles for user $userId');

      // Get user to find organization ID
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Find all company profiles for this organization
      final profiles = await CompanyProfile.db.find(
        session,
        where: (t) => t.organizationId.equals(user.organizationId),
        orderBy: (t) => t.name,
      );

      session.log('Found ${profiles.length} company profiles');
      return profiles;
    } catch (e) {
      session.log('Failed to list company profiles: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets a single company profile by ID.
  ///
  /// Validates that the user has access to this company profile
  /// via their organization.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID to retrieve
  ///
  /// Returns: CompanyProfile object
  ///
  /// Throws:
  /// - [Exception] if profile not found
  /// - [Exception] if access denied
  Future<CompanyProfile> getCompanyProfile(
    Session session, {
    required int userId,
    required int companyProfileId,
  }) async {
    try {
      session.log('Getting company profile $companyProfileId');

      // Get user for organization validation
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Get company profile
      final profile = await CompanyProfile.db.findById(session, companyProfileId);
      if (profile == null) {
        throw Exception('Company profile not found');
      }

      // Validate access
      if (profile.organizationId != user.organizationId) {
        throw Exception('Access denied: Company profile belongs to different organization');
      }

      return profile;
    } catch (e) {
      session.log('Failed to get company profile: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Creates a new company profile.
  ///
  /// Creates a company profile within the user's organization.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (to get organization ID)
  /// - [name] - Company name (required)
  /// - [description] - Company description (optional)
  /// - [brandVoice] - Brand voice guidelines (optional)
  /// - [uploadedFiles] - List of uploaded file references (optional)
  ///
  /// Returns: Created CompanyProfile object
  ///
  /// Throws:
  /// - [Exception] if validation fails
  /// - [Exception] if user not found
  Future<CompanyProfile> createCompanyProfile(
    Session session, {
    required int userId,
    required String name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
  }) async {
    try {
      session.log('Creating company profile: $name');

      // Validate input
      if (name.trim().isEmpty) {
        throw Exception('Company name cannot be empty');
      }

      // Get user to find organization ID
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Check for duplicate name within organization
      final existing = await CompanyProfile.db.findFirstRow(
        session,
        where: (t) =>
            t.organizationId.equals(user.organizationId) &
            t.name.equals(name.trim()),
      );

      if (existing != null) {
        throw Exception('Company profile with this name already exists');
      }

      // Create company profile (uploadedFiles is now List<String>? directly)
      final profile = await CompanyProfile.db.insertRow(
        session,
        CompanyProfile(
          organizationId: user.organizationId,
          name: name.trim(),
          description: description?.trim(),
          brandVoice: brandVoice?.trim(),
          uploadedFiles: uploadedFiles,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      session.log('Company profile created: ${profile.id}');
      return profile;
    } catch (e) {
      session.log('Failed to create company profile: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Updates an existing company profile.
  ///
  /// Updates specified fields of a company profile. Only the user's
  /// organization profiles can be updated.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID to update
  /// - [name] - New company name (optional)
  /// - [description] - New description (optional)
  /// - [brandVoice] - New brand voice (optional)
  /// - [uploadedFiles] - New uploaded files list (optional)
  ///
  /// Returns: Updated CompanyProfile object
  ///
  /// Throws:
  /// - [Exception] if profile not found or access denied
  /// - [Exception] if validation fails
  Future<CompanyProfile> updateCompanyProfile(
    Session session, {
    required int userId,
    required int companyProfileId,
    String? name,
    String? description,
    String? brandVoice,
    List<String>? uploadedFiles,
  }) async {
    try {
      session.log('Updating company profile $companyProfileId');

      // Get user for validation
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Get existing profile
      final profile = await CompanyProfile.db.findById(session, companyProfileId);
      if (profile == null) {
        throw Exception('Company profile not found');
      }

      // Validate access
      if (profile.organizationId != user.organizationId) {
        throw Exception('Access denied: Company profile belongs to different organization');
      }

      // Validate name if provided
      if (name != null && name.trim().isEmpty) {
        throw Exception('Company name cannot be empty');
      }

      // Check for duplicate name if changing name
      if (name != null && name.trim() != profile.name) {
        final existing = await CompanyProfile.db.findFirstRow(
          session,
          where: (t) =>
              t.organizationId.equals(user.organizationId) &
              t.name.equals(name.trim()) &
              t.id.notEquals(companyProfileId),
        );

        if (existing != null) {
          throw Exception('Company profile with this name already exists');
        }
      }

      // Update profile (uploadedFiles is now List<String>? directly)
      final updatedProfile = await CompanyProfile.db.updateRow(
        session,
        profile.copyWith(
          name: name?.trim() ?? profile.name,
          description: description?.trim() ?? profile.description,
          brandVoice: brandVoice?.trim() ?? profile.brandVoice,
          uploadedFiles: uploadedFiles ?? profile.uploadedFiles,
          updatedAt: DateTime.now(),
        ),
      );

      session.log('Company profile updated: ${updatedProfile.id}');
      return updatedProfile;
    } catch (e) {
      session.log('Failed to update company profile: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Deletes a company profile.
  ///
  /// Deletes a company profile and all associated data. This operation
  /// cannot be undone.
  ///
  /// Note: This will fail if there are products or posts referencing
  /// this company profile due to foreign key constraints.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID to delete
  ///
  /// Returns: Success message
  ///
  /// Throws:
  /// - [Exception] if profile not found or access denied
  /// - [Exception] if there are dependent records
  Future<String> deleteCompanyProfile(
    Session session, {
    required int userId,
    required int companyProfileId,
  }) async {
    try {
      session.log('Deleting company profile $companyProfileId');

      // Get user for validation
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Get profile
      final profile = await CompanyProfile.db.findById(session, companyProfileId);
      if (profile == null) {
        throw Exception('Company profile not found');
      }

      // Validate access
      if (profile.organizationId != user.organizationId) {
        throw Exception('Access denied: Company profile belongs to different organization');
      }

      // Check for dependent products
      final products = await Product.db.find(
        session,
        where: (t) => t.companyProfileId.equals(companyProfileId),
        limit: 1,
      );

      if (products.isNotEmpty) {
        throw Exception(
          'Cannot delete company profile: It has associated products. '
          'Please delete products first.',
        );
      }

      // Check for dependent posts
      final posts = await Post.db.find(
        session,
        where: (t) => t.companyProfileId.equals(companyProfileId),
        limit: 1,
      );

      if (posts.isNotEmpty) {
        throw Exception(
          'Cannot delete company profile: It has associated posts. '
          'Please delete posts first.',
        );
      }

      // Delete profile
      await CompanyProfile.db.deleteRow(session, profile);

      session.log('Company profile deleted: $companyProfileId');
      return 'Company profile deleted successfully';
    } catch (e) {
      session.log('Failed to delete company profile: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets all products for a company profile.
  ///
  /// Convenience method to get products associated with a company profile.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID
  ///
  /// Returns: List of Product objects
  Future<List<Product>> getCompanyProducts(
    Session session, {
    required int userId,
    required int companyProfileId,
  }) async {
    try {
      // Validate access to company profile
      await getCompanyProfile(
        session,
        userId: userId,
        companyProfileId: companyProfileId,
      );

      // Get products
      final products = await Product.db.find(
        session,
        where: (t) => t.companyProfileId.equals(companyProfileId),
        orderBy: (t) => t.name,
      );

      return products;
    } catch (e) {
      session.log('Failed to get company products: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Parses uploaded files JSON to a list of strings.
  ///
  /// Helper method for client to parse the uploadedFiles field.
  ///
  /// Parameters:
  /// - [uploadedFilesJson] - JSON string from CompanyProfile.uploadedFiles
  ///
  /// Returns: List of file references
  static List<String> parseUploadedFiles(String uploadedFilesJson) {
    try {
      final decoded = jsonDecode(uploadedFilesJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
