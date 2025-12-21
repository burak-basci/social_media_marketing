import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Product endpoint for managing products within company profiles.
///
/// Provides CRUD operations for products that are used to generate
/// targeted marketing content. Products belong to company profiles.
///
/// Example usage from client:
/// ```dart
/// // List all products for a company
/// final products = await client.product.listProducts(
///   userId: currentUser.id,
///   companyProfileId: 1,
/// );
///
/// // Create new product
/// final product = await client.product.createProduct(
///   userId: currentUser.id,
///   companyProfileId: 1,
///   name: 'Premium Widget',
///   description: 'High-quality widget for professionals',
///   targetAudience: 'Business professionals, age 30-50',
///   keyFeatures: ['Durable', 'Easy to use', 'Cost-effective'],
/// );
/// ```
class ProductEndpoint extends Endpoint {
  /// Lists all products for a company profile.
  ///
  /// Returns products filtered by company profile ID. Also validates
  /// that the user has access to this company profile.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID
  ///
  /// Returns: List of Product objects
  ///
  /// Throws:
  /// - [Exception] if user doesn't have access to company profile
  Future<List<Product>> listProducts(
    Session session, {
    required int userId,
    required int companyProfileId,
  }) async {
    try {
      session.log('Listing products for company profile $companyProfileId');

      // Validate access to company profile
      await _validateCompanyProfileAccess(session, userId, companyProfileId);

      // Find all products for this company profile
      final products = await Product.db.find(
        session,
        where: (t) => t.companyProfileId.equals(companyProfileId),
        orderBy: (t) => t.name,
      );

      session.log('Found ${products.length} products');
      return products;
    } catch (e) {
      session.log('Failed to list products: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets a single product by ID.
  ///
  /// Validates that the user has access to the company profile
  /// that owns this product.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID to retrieve
  ///
  /// Returns: Product object
  ///
  /// Throws:
  /// - [Exception] if product not found
  /// - [Exception] if access denied
  Future<Product> getProduct(
    Session session, {
    required int userId,
    required int productId,
  }) async {
    try {
      session.log('Getting product $productId');

      // Get product
      final product = await Product.db.findById(session, productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      // Validate access to company profile
      await _validateCompanyProfileAccess(
        session,
        userId,
        product.companyProfileId,
      );

      return product;
    } catch (e) {
      session.log('Failed to get product: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Creates a new product.
  ///
  /// Creates a product within a company profile. The user must have
  /// access to the company profile.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [companyProfileId] - Company profile ID this product belongs to
  /// - [name] - Product name (required)
  /// - [description] - Product description (optional)
  /// - [targetAudience] - Target audience description (optional)
  /// - [keyFeatures] - List of key features (optional)
  /// - [category] - Product category (optional)
  ///
  /// Returns: Created Product object
  ///
  /// Throws:
  /// - [Exception] if validation fails
  /// - [Exception] if user doesn't have access to company profile
  Future<Product> createProduct(
    Session session, {
    required int userId,
    required int companyProfileId,
    required String name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
  }) async {
    try {
      session.log('Creating product: $name');

      // Validate input
      if (name.trim().isEmpty) {
        throw Exception('Product name cannot be empty');
      }

      // Validate access to company profile
      await _validateCompanyProfileAccess(session, userId, companyProfileId);

      // Check for duplicate name within company profile
      final existing = await Product.db.findFirstRow(
        session,
        where: (t) =>
            t.companyProfileId.equals(companyProfileId) &
            t.name.equals(name.trim()),
      );

      if (existing != null) {
        throw Exception('Product with this name already exists in this company profile');
      }

      // Create product (keyFeatures is now List<String>? directly)
      final product = await Product.db.insertRow(
        session,
        Product(
          companyProfileId: companyProfileId,
          name: name.trim(),
          description: description?.trim(),
          targetAudience: targetAudience?.trim(),
          keyFeatures: keyFeatures,
          category: category?.trim(),
          createdAt: DateTime.now(),
        ),
      );

      session.log('Product created: ${product.id}');
      return product;
    } catch (e) {
      session.log('Failed to create product: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Updates an existing product.
  ///
  /// Updates specified fields of a product. The user must have access
  /// to the company profile that owns this product.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID to update
  /// - [name] - New product name (optional)
  /// - [description] - New description (optional)
  /// - [targetAudience] - New target audience (optional)
  /// - [keyFeatures] - New key features list (optional)
  /// - [category] - New product category (optional)
  ///
  /// Returns: Updated Product object
  ///
  /// Throws:
  /// - [Exception] if product not found or access denied
  /// - [Exception] if validation fails
  Future<Product> updateProduct(
    Session session, {
    required int userId,
    required int productId,
    String? name,
    String? description,
    String? targetAudience,
    List<String>? keyFeatures,
    String? category,
  }) async {
    try {
      session.log('Updating product $productId');

      // Get existing product
      final product = await Product.db.findById(session, productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      // Validate access to company profile
      await _validateCompanyProfileAccess(
        session,
        userId,
        product.companyProfileId,
      );

      // Validate name if provided
      if (name != null && name.trim().isEmpty) {
        throw Exception('Product name cannot be empty');
      }

      // Check for duplicate name if changing name
      if (name != null && name.trim() != product.name) {
        final existing = await Product.db.findFirstRow(
          session,
          where: (t) =>
              t.companyProfileId.equals(product.companyProfileId) &
              t.name.equals(name.trim()) &
              t.id.notEquals(productId),
        );

        if (existing != null) {
          throw Exception('Product with this name already exists in this company profile');
        }
      }

      // Update product (keyFeatures is now List<String>? directly)
      final updatedProduct = await Product.db.updateRow(
        session,
        product.copyWith(
          name: name?.trim() ?? product.name,
          description: description?.trim() ?? product.description,
          targetAudience: targetAudience?.trim() ?? product.targetAudience,
          keyFeatures: keyFeatures ?? product.keyFeatures,
          category: category?.trim() ?? product.category,
        ),
      );

      session.log('Product updated: ${updatedProduct.id}');
      return updatedProduct;
    } catch (e) {
      session.log('Failed to update product: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Deletes a product.
  ///
  /// Deletes a product. This operation cannot be undone.
  ///
  /// Note: This will fail if there are posts referencing this product
  /// due to foreign key constraints.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID to delete
  ///
  /// Returns: Success message
  ///
  /// Throws:
  /// - [Exception] if product not found or access denied
  /// - [Exception] if there are dependent posts
  Future<String> deleteProduct(
    Session session, {
    required int userId,
    required int productId,
  }) async {
    try {
      session.log('Deleting product $productId');

      // Get product
      final product = await Product.db.findById(session, productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      // Validate access to company profile
      await _validateCompanyProfileAccess(
        session,
        userId,
        product.companyProfileId,
      );

      // Check for dependent posts
      final posts = await Post.db.find(
        session,
        where: (t) => t.productId.equals(productId),
        limit: 1,
      );

      if (posts.isNotEmpty) {
        throw Exception(
          'Cannot delete product: It has associated posts. '
          'Please delete or update posts first.',
        );
      }

      // Delete product
      await Product.db.deleteRow(session, product);

      session.log('Product deleted: $productId');
      return 'Product deleted successfully';
    } catch (e) {
      session.log('Failed to delete product: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Gets all posts that use this product.
  ///
  /// Convenience method to get posts associated with a product.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [productId] - Product ID
  ///
  /// Returns: List of Post objects
  Future<List<Post>> getProductPosts(
    Session session, {
    required int userId,
    required int productId,
  }) async {
    try {
      // Validate access to product (which validates company profile access)
      await getProduct(session, userId: userId, productId: productId);

      // Get posts
      final posts = await Post.db.find(
        session,
        where: (t) => t.productId.equals(productId),
        orderBy: (t) => t.createdAt,
        orderDescending: true,
      );

      return posts;
    } catch (e) {
      session.log('Failed to get product posts: $e', level: LogLevel.error);
      rethrow;
    }
  }

  // ==========================================================================
  // PRIVATE HELPER METHODS
  // ==========================================================================

  /// Validates that user has access to a company profile.
  ///
  /// Checks that the company profile exists and belongs to the user's
  /// organization.
  ///
  /// Throws [Exception] if validation fails.
  Future<void> _validateCompanyProfileAccess(
    Session session,
    int userId,
    int companyProfileId,
  ) async {
    // Get user to find organization ID
    final user = await User.db.findById(session, userId);
    if (user == null) {
      throw Exception('User not found');
    }

    // Get company profile
    final companyProfile = await CompanyProfile.db.findById(
      session,
      companyProfileId,
    );

    if (companyProfile == null) {
      throw Exception('Company profile not found');
    }

    // Validate organization match
    if (companyProfile.organizationId != user.organizationId) {
      throw Exception('Access denied: Company profile belongs to different organization');
    }
  }

  /// Parses key features JSON to a list of strings.
  ///
  /// Helper method for client to parse the keyFeatures field.
  ///
  /// Parameters:
  /// - [keyFeaturesJson] - JSON string from Product.keyFeatures
  ///
  /// Returns: List of feature strings
  static List<String> parseKeyFeatures(String keyFeaturesJson) {
    try {
      final decoded = jsonDecode(keyFeaturesJson);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Converts a list of features to JSON.
  ///
  /// Helper method for client to prepare data for API calls.
  ///
  /// Parameters:
  /// - [features] - List of feature strings
  ///
  /// Returns: JSON encoded string
  static String encodeKeyFeatures(List<String> features) {
    return jsonEncode(features);
  }
}
