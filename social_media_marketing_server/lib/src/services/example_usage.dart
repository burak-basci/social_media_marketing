/// Example usage of the GeminiService for social media content generation.
///
/// This file demonstrates how to use the Gemini AI service in your endpoints.
///
/// SETUP INSTRUCTIONS:
///
/// 1. Set the GEMINI_API_KEY environment variable:
///    ```bash
///    export GEMINI_API_KEY="your-api-key-here"
///    ```
///
///    Get your API key from: https://makersuite.google.com/app/apikey
///
/// 2. (Optional) Set the logging level:
///    ```bash
///    export LLM_LOGGING_LEVEL="FULL"  # Options: FULL, TIMING, ERRORS, NONE
///    ```
///
/// BASIC USAGE EXAMPLE:
///
/// ```dart
/// import 'package:serverpod/serverpod.dart';
/// import '../services/gemini_service.dart';
///
/// class ContentEndpoint extends Endpoint {
///   Future<String> generateContent(
///     Session session,
///     String platform,
///     String userPrompt,
///   ) async {
///     try {
///       // Initialize the Gemini service with session for logging
///       final geminiService = GeminiService.fromEnvironment(session: session);
///
///       // Generate content
///       final content = await geminiService.generatePlatformContent(
///         platform: platform,
///         companyInfo: 'Acme Corp - Innovative tech solutions',
///         productInfo: 'Cloud-based project management tool',
///         userPrompt: userPrompt,
///       );
///
///       return content;
///     } catch (e) {
///       print('Error generating content: $e');
///       rethrow;
///     }
///   }
/// }
/// ```
///
/// ADVANCED USAGE EXAMPLE:
///
/// ```dart
/// import 'package:serverpod/serverpod.dart';
/// import '../services/gemini_service.dart';
/// import '../generated/organization.dart';
/// import '../generated/product.dart';
/// import '../generated/post.dart';
///
/// class AdvancedContentEndpoint extends Endpoint {
///   /// Generate initial content for a post
///   Future<Post> generatePost(
///     Session session,
///     int organizationId,
///     int productId,
///     String platform,
///     String userPrompt,
///   ) async {
///     // Fetch organization and product data
///     final organization = await Organization.db.findById(session, organizationId);
///     final product = await Product.db.findById(session, productId);
///
///     if (organization == null || product == null) {
///       throw Exception('Organization or Product not found');
///     }
///
///     // Initialize Gemini service
///     final geminiService = GeminiService.fromEnvironment(session: session);
///
///     // Create post record
///     final post = Post(
///       userId: session.auth.authenticatedUserId!,
///       organizationId: organizationId,
///       platform: platform,
///       status: 'draft',
///       createdAt: DateTime.now(),
///       updatedAt: DateTime.now(),
///     );
///
///     final savedPost = await Post.db.insertRow(session, post);
///
///     // Generate content with post ID for logging
///     final content = await geminiService.generatePlatformContent(
///       platform: platform,
///       companyInfo: organization.description ?? organization.name,
///       productInfo: product.description ?? product.name,
///       userPrompt: userPrompt,
///       postId: savedPost.id,
///     );
///
///     // Update post with generated content
///     final updatedPost = savedPost.copyWith(
///       content: content,
///       updatedAt: DateTime.now(),
///     );
///
///     return await Post.db.updateRow(session, updatedPost);
///   }
///
///   /// Edit existing post content
///   Future<Post> editPost(
///     Session session,
///     int postId,
///     String editRequest,
///   ) async {
///     final post = await Post.db.findById(session, postId);
///     if (post == null) {
///       throw Exception('Post not found');
///     }
///
///     // Fetch organization and product for context
///     final organization = await Organization.db.findById(session, post.organizationId);
///     final product = post.productId != null
///         ? await Product.db.findById(session, post.productId!)
///         : null;
///
///     final geminiService = GeminiService.fromEnvironment(session: session);
///
///     final editedContent = await geminiService.editContent(
///       platform: post.platform,
///       originalContent: post.content,
///       editRequest: editRequest,
///       companyInfo: organization?.description ?? '',
///       productInfo: product?.description ?? '',
///       postId: post.id,
///     );
///
///     final updatedPost = post.copyWith(
///       content: editedContent,
///       updatedAt: DateTime.now(),
///     );
///
///     return await Post.db.updateRow(session, updatedPost);
///   }
///
///   /// Generate multiple variations for A/B testing
///   Future<List<String>> generateVariations(
///     Session session,
///     int organizationId,
///     int productId,
///     String platform,
///     String userPrompt,
///     int count,
///   ) async {
///     final organization = await Organization.db.findById(session, organizationId);
///     final product = await Product.db.findById(session, productId);
///
///     if (organization == null || product == null) {
///       throw Exception('Organization or Product not found');
///     }
///
///     final geminiService = GeminiService.fromEnvironment(session: session);
///
///     return await geminiService.generateContentVariations(
///       platform: platform,
///       companyInfo: organization.description ?? organization.name,
///       productInfo: product.description ?? product.name,
///       userPrompt: userPrompt,
///       variations: count,
///     );
///   }
/// }
/// ```
///
/// LOGGING USAGE:
///
/// ```dart
/// import '../services/ai_logging_service.dart';
///
/// class LoggingEndpoint extends Endpoint {
///   /// Get logs for a specific post
///   Future<List<AIInteractionLog>> getPostLogs(
///     Session session,
///     int postId,
///   ) async {
///     return await AILoggingService.getLogsForPost(
///       session: session,
///       postId: postId,
///     );
///   }
///
///   /// Get recent error logs
///   Future<List<AIInteractionLog>> getRecentErrors(
///     Session session,
///     int limit,
///   ) async {
///     return await AILoggingService.getRecentLogs(
///       session: session,
///       limit: limit,
///       onlyErrors: true,
///     );
///   }
///
///   /// Analyze AI performance metrics
///   Future<Map<String, dynamic>> getTimingAnalysis(
///     Session session,
///   ) async {
///     return await AILoggingService.analyzeTimingPatterns(
///       session: session,
///       limit: 1000,
///     );
///   }
///
///   /// Get cost analysis
///   Future<Map<String, dynamic>> getCostAnalysis(
///     Session session,
///     DateTime? since,
///   ) async {
///     return await AILoggingService.getCostAnalysis(
///       session: session,
///       since: since,
///     );
///   }
/// }
/// ```
///
/// ERROR HANDLING:
///
/// ```dart
/// try {
///   final content = await geminiService.generatePlatformContent(
///     platform: 'x',
///     companyInfo: companyInfo,
///     productInfo: productInfo,
///     userPrompt: userPrompt,
///   );
///   return content;
/// } on GenerativeAIException catch (e) {
///   // Gemini API specific errors
///   print('Gemini API error: ${e.message}');
///   throw Exception('AI service error: ${e.message}');
/// } on Exception catch (e) {
///   // General errors (missing API key, etc.)
///   print('Error: $e');
///   rethrow;
/// }
/// ```
///
/// SUPPORTED PLATFORMS:
/// - 'x' (Twitter/X)
/// - 'linkedin'
/// - 'instagram'
/// - 'facebook'
/// - 'pinterest'
///
/// ENVIRONMENT VARIABLES:
/// - GEMINI_API_KEY (required): Your Google AI API key
/// - LLM_LOGGING_LEVEL (optional): FULL, TIMING, ERRORS, or NONE (default: FULL)
///
/// LOG FILES:
/// - Database: All logs stored in ai_interaction_log table
/// - JSONL Files: logs/llm_interactions_YYYYMMDD.jsonl
///
/// PRICING CONSIDERATIONS:
/// The service automatically estimates costs based on token usage.
/// Approximate Gemini 2.5 Flash pricing:
/// - Input: ~$0.075 per 1M tokens
/// - Output: ~$0.30 per 1M tokens
/// - Blended estimate: ~$0.15 per 1M tokens
///
/// Monitor costs using AILoggingService.getCostAnalysis()

library example_usage;
