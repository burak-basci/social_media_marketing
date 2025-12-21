import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/gemini_service.dart';

/// Campaign endpoint for generating AI-powered social media content.
///
/// Provides methods for:
/// - Generating multi-platform campaigns with AI
/// - Regenerating content for individual platforms
/// - Managing campaign creation workflow
///
/// Example usage from client:
/// ```dart
/// final result = await client.campaign.generateCampaign(
///   request: CampaignRequest(
///     companyProfileId: 1,
///     productId: 2,
///     userPrompt: 'Launch announcement for new product',
///     selectedPlatforms: ['x', 'linkedin', 'instagram'],
///     generateImage: true,
///   ),
/// );
/// ```
class CampaignEndpoint extends Endpoint {
  /// Generates a complete campaign with AI content for all selected platforms.
  ///
  /// This is the main method for the Campaign Creation Wizard. It:
  /// 1. Validates user has access to the company profile
  /// 2. Loads company and product information
  /// 3. Calls Gemini AI to generate platform-specific content
  /// 4. Creates a draft Post in the database
  /// 5. Logs all AI interactions
  /// 6. Optionally generates image prompt
  ///
  /// Parameters:
  /// - [userId] - Current user ID (from session)
  /// - [companyProfileId] - Company profile to use for brand context
  /// - [productId] - Optional product for targeted content
  /// - [userPrompt] - User's content request/description
  /// - [selectedPlatforms] - List of platforms (x, linkedin, instagram, facebook, pinterest)
  /// - [generateImage] - Whether to generate image prompt (default: true)
  /// - [title] - Optional post title (auto-generated if not provided)
  ///
  /// Returns: CampaignGenerationResult with all generated content and post ID
  ///
  /// Throws:
  /// - [Exception] if user doesn't have access to company profile
  /// - [Exception] if company profile or product not found
  /// - [Exception] if AI generation fails
  Future<CampaignGenerationResult> generateCampaign(
    Session session, {
    required int userId,
    required int companyProfileId,
    int? productId,
    required String userPrompt,
    required List<String> selectedPlatforms,
    bool generateImage = true,
    String? title,
  }) async {
    final startTime = DateTime.now();

    try {
      session.log('Starting campaign generation for user $userId');

      // Validate input
      if (selectedPlatforms.isEmpty) {
        throw Exception('At least one platform must be selected');
      }
      if (userPrompt.trim().isEmpty) {
        throw Exception('User prompt cannot be empty');
      }

      // Load company profile and validate access
      final companyProfile = await CompanyProfile.db.findById(
        session,
        companyProfileId,
      );

      if (companyProfile == null) {
        throw Exception('Company profile not found');
      }

      // Validate user has access to this company profile (via organization)
      final user = await User.db.findById(session, userId);
      if (user == null) {
        throw Exception('User not found');
      }

      if (user.organizationId != companyProfile.organizationId) {
        throw Exception('Access denied: User does not belong to this organization');
      }

      // Load product if specified
      Product? product;
      if (productId != null) {
        product = await Product.db.findById(session, productId);
        if (product == null) {
          throw Exception('Product not found');
        }
        if (product.companyProfileId != companyProfileId) {
          throw Exception('Product does not belong to this company profile');
        }
      }

      // Build company and product info strings for AI
      final companyInfo = _buildCompanyInfo(companyProfile);
      final productInfo = product != null ? _buildProductInfo(product) : 'General brand content';

      session.log('Company: ${companyProfile.name}');
      session.log('Product: ${product?.name ?? 'None'}');
      session.log('Platforms: ${selectedPlatforms.join(', ')}');

      // Generate content for all platforms using Gemini
      final geminiService = GeminiService.fromEnvironment(session: session);

      // Create draft post first to get post ID for logging
      final draftPost = await Post.db.insertRow(
        session,
        Post(
          organizationId: user.organizationId,
          userId: userId,
          companyProfileId: companyProfileId,
          productId: productId,
          title: title ?? _generateTitle(userPrompt),
          userPrompt: userPrompt,
          aiGeneratedContent: jsonEncode({}), // Will be updated
          selectedPlatforms: jsonEncode(selectedPlatforms),
          status: 'draft',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );

      session.log('Created draft post: ${draftPost.id}');

      // Generate campaign content
      final campaignResult = await geminiService.generateCampaignContent(
        companyInfo: companyInfo,
        productInfo: productInfo,
        userPrompt: userPrompt,
        platforms: selectedPlatforms,
        generateImage: generateImage,
        postId: draftPost.id,
      );

      // Extract platform contents
      final platformContents = <String, String>{};
      for (final platform in selectedPlatforms) {
        if (campaignResult.containsKey(platform)) {
          platformContents[platform] = campaignResult[platform] as String;
        }
      }

      // Update post with generated content
      final updatedPost = await Post.db.updateRow(
        session,
        draftPost.copyWith(
          aiGeneratedContent: jsonEncode(platformContents),
          updatedAt: DateTime.now(),
        ),
      );

      final totalDuration = DateTime.now().difference(startTime);
      session.log('Campaign generation completed in ${totalDuration.inMilliseconds}ms');

      return CampaignGenerationResult(
        postId: updatedPost.id!,
        platformContents: platformContents,
        imagePrompt: campaignResult['imagePrompt'] as String?,
        timings: campaignResult['timings'] as Map<String, dynamic>?,
        success: true,
      );
    } catch (e, stackTrace) {
      session.log('Campaign generation failed: $e', level: LogLevel.error);
      session.log('Stack trace: $stackTrace', level: LogLevel.error);

      return CampaignGenerationResult(
        postId: 0,
        platformContents: {},
        success: false,
        errorMessage: e.toString(),
      );
    }
  }

  /// Regenerates content for a single platform.
  ///
  /// Used when user wants to regenerate or edit content for one platform
  /// without affecting other platforms.
  ///
  /// Parameters:
  /// - [userId] - Current user ID (for validation)
  /// - [postId] - Existing post ID
  /// - [platform] - Platform to regenerate (x, linkedin, etc.)
  /// - [newPrompt] - Optional new prompt (uses original if not provided)
  ///
  /// Returns: PlatformContent with updated content
  ///
  /// Throws:
  /// - [Exception] if post not found or access denied
  /// - [Exception] if platform not in selected platforms
  Future<PlatformContent> regeneratePlatform(
    Session session, {
    required int userId,
    required int postId,
    required String platform,
    String? newPrompt,
  }) async {
    try {
      session.log('Regenerating content for platform: $platform');

      // Load post and validate access
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        throw Exception('Post not found');
      }

      // Validate user has access
      if (post.userId != userId) {
        throw Exception('Access denied: Post does not belong to this user');
      }

      // Validate platform is in selected platforms
      final selectedPlatforms = (jsonDecode(post.selectedPlatforms) as List)
          .map((e) => e as String)
          .toList();

      if (!selectedPlatforms.contains(platform)) {
        throw Exception('Platform $platform is not selected for this post');
      }

      // Load company profile
      final companyProfile = await CompanyProfile.db.findById(
        session,
        post.companyProfileId,
      );
      if (companyProfile == null) {
        throw Exception('Company profile not found');
      }

      // Load product if exists
      Product? product;
      if (post.productId != null) {
        product = await Product.db.findById(session, post.productId!);
      }

      // Build context strings
      final companyInfo = _buildCompanyInfo(companyProfile);
      final productInfo = product != null ? _buildProductInfo(product) : 'General brand content';
      final prompt = newPrompt ?? post.userPrompt;

      // Generate new content for this platform
      final geminiService = GeminiService.fromEnvironment(session: session);
      final newContent = await geminiService.generatePlatformContent(
        platform: platform,
        companyInfo: companyInfo,
        productInfo: productInfo,
        userPrompt: prompt,
        postId: postId,
      );

      // Update post with new content for this platform
      final currentContent = jsonDecode(post.aiGeneratedContent) as Map<String, dynamic>;
      currentContent[platform] = newContent;

      await Post.db.updateRow(
        session,
        post.copyWith(
          aiGeneratedContent: jsonEncode(currentContent),
          updatedAt: DateTime.now(),
        ),
      );

      session.log('Platform content regenerated successfully');

      return PlatformContent(
        platform: platform,
        content: newContent,
        regenerated: true,
      );
    } catch (e) {
      session.log('Platform regeneration failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  /// Edits existing platform content based on user feedback.
  ///
  /// Uses AI to edit content while maintaining platform best practices.
  ///
  /// Parameters:
  /// - [userId] - Current user ID
  /// - [postId] - Existing post ID
  /// - [platform] - Platform to edit
  /// - [editRequest] - User's edit instructions (e.g., "make it shorter", "add emoji")
  ///
  /// Returns: PlatformContent with edited content
  Future<PlatformContent> editPlatformContent(
    Session session, {
    required int userId,
    required int postId,
    required String platform,
    required String editRequest,
  }) async {
    try {
      session.log('Editing content for platform: $platform');

      // Load post and validate
      final post = await Post.db.findById(session, postId);
      if (post == null) {
        throw Exception('Post not found');
      }

      if (post.userId != userId) {
        throw Exception('Access denied');
      }

      // Get current content for platform
      final currentContent = jsonDecode(post.aiGeneratedContent) as Map<String, dynamic>;
      final platformContent = currentContent[platform] as String?;

      if (platformContent == null) {
        throw Exception('No content found for platform $platform');
      }

      // Load context
      final companyProfile = await CompanyProfile.db.findById(
        session,
        post.companyProfileId,
      );
      if (companyProfile == null) {
        throw Exception('Company profile not found');
      }

      Product? product;
      if (post.productId != null) {
        product = await Product.db.findById(session, post.productId!);
      }

      final companyInfo = _buildCompanyInfo(companyProfile);
      final productInfo = product != null ? _buildProductInfo(product) : 'General brand content';

      // Call Gemini to edit content
      final geminiService = GeminiService.fromEnvironment(session: session);
      final editedContent = await geminiService.editContent(
        platform: platform,
        originalContent: platformContent,
        editRequest: editRequest,
        companyInfo: companyInfo,
        productInfo: productInfo,
        postId: postId,
      );

      // Update post
      currentContent[platform] = editedContent;
      await Post.db.updateRow(
        session,
        post.copyWith(
          aiGeneratedContent: jsonEncode(currentContent),
          updatedAt: DateTime.now(),
        ),
      );

      return PlatformContent(
        platform: platform,
        content: editedContent,
        regenerated: false,
      );
    } catch (e) {
      session.log('Content edit failed: $e', level: LogLevel.error);
      rethrow;
    }
  }

  // ==========================================================================
  // PRIVATE HELPER METHODS
  // ==========================================================================

  /// Builds company information string for AI context.
  String _buildCompanyInfo(CompanyProfile profile) {
    final buffer = StringBuffer();
    buffer.writeln('Company: ${profile.name}');

    if (profile.description != null && profile.description!.isNotEmpty) {
      buffer.writeln('Description: ${profile.description}');
    }

    if (profile.brandVoice != null && profile.brandVoice!.isNotEmpty) {
      buffer.writeln('Brand Voice: ${profile.brandVoice}');
    }

    return buffer.toString();
  }

  /// Builds product information string for AI context.
  String _buildProductInfo(Product product) {
    final buffer = StringBuffer();
    buffer.writeln('Product: ${product.name}');

    if (product.description != null && product.description!.isNotEmpty) {
      buffer.writeln('Description: ${product.description}');
    }

    if (product.targetAudience != null && product.targetAudience!.isNotEmpty) {
      buffer.writeln('Target Audience: ${product.targetAudience}');
    }

    // Handle key features (now List<String>? instead of JSON)
    if (product.keyFeatures != null && product.keyFeatures!.isNotEmpty) {
      buffer.writeln('Key Features:');
      for (final feature in product.keyFeatures!) {
        buffer.writeln('  - $feature');
      }
    }

    return buffer.toString();
  }

  /// Generates a post title from user prompt.
  String _generateTitle(String prompt) {
    // Take first 50 characters of prompt as title
    final title = prompt.trim().split('\n').first;
    return title.length > 50 ? '${title.substring(0, 47)}...' : title;
  }
}

// ==========================================================================
// DATA TRANSFER OBJECTS
// ==========================================================================

/// Result from campaign generation.
class CampaignGenerationResult {
  final int postId;
  final Map<String, String> platformContents;
  final String? imagePrompt;
  final Map<String, dynamic>? timings;
  final bool success;
  final String? errorMessage;

  CampaignGenerationResult({
    required this.postId,
    required this.platformContents,
    this.imagePrompt,
    this.timings,
    required this.success,
    this.errorMessage,
  });

  Map<String, dynamic> toJson() => {
        'postId': postId,
        'platformContents': platformContents,
        'imagePrompt': imagePrompt,
        'timings': timings,
        'success': success,
        'errorMessage': errorMessage,
      };
}

/// Platform-specific content.
class PlatformContent {
  final String platform;
  final String content;
  final bool regenerated;

  PlatformContent({
    required this.platform,
    required this.content,
    required this.regenerated,
  });

  Map<String, dynamic> toJson() => {
        'platform': platform,
        'content': content,
        'regenerated': regenerated,
      };
}
