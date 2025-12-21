import 'dart:io';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:serverpod/serverpod.dart';
import 'platform_prompts.dart';
import 'ai_logging_service.dart';

/// Service for interacting with Google's Gemini AI models.
/// Handles both text and image generation for social media content.
class GeminiService {
  final GenerativeModel textModel;
  final GenerativeModel imageModel;
  final Session? _session;

  /// Creates a Gemini service with the provided API key
  GeminiService({
    required String apiKey,
    Session? session,
  })  : textModel = GenerativeModel(
          model: 'gemini-3-flash-preview',
          apiKey: apiKey,
        ),
        imageModel = GenerativeModel(
          model: 'gemini-2.5-flash-image',
          apiKey: apiKey,
        ),
        _session = session;

  /// Factory constructor that reads API key from environment
  factory GeminiService.fromEnvironment({Session? session}) {
    final apiKey = Platform.environment['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY environment variable is not set. '
        'Please set it to your Google AI API key.',
      );
    }
    return GeminiService(apiKey: apiKey, session: session);
  }

  /// Generates platform-specific social media content
  ///
  /// [platform] - The target platform (x, linkedin, instagram, facebook, pinterest)
  /// [companyInfo] - Information about the company/brand
  /// [productInfo] - Information about the product or service
  /// [userPrompt] - User's specific request for content
  /// [postId] - Optional post ID for logging purposes
  ///
  /// Returns the generated content as a String
  Future<String> generatePlatformContent({
    required String platform,
    required String companyInfo,
    required String productInfo,
    required String userPrompt,
    int? postId,
  }) async {
    final overallStartTime = DateTime.now();

    try {
      print('[GeminiService] Starting content generation for platform: $platform');

      // Build platform-specific prompt
      final systemPrompt = PlatformPrompts.getSystemPrompt(
        platform: platform,
        companyInfo: companyInfo,
        productInfo: productInfo,
      );
      final fullPrompt = '$systemPrompt\n\nUser request: $userPrompt';

      print('[GeminiService] Prompt length: ${fullPrompt.length} characters');
      print('[GeminiService] Calling Gemini API...');

      // Call Gemini API with timing
      final apiStartTime = DateTime.now();
      final response = await textModel.generateContent([Content.text(fullPrompt)]);
      final apiEndTime = DateTime.now();

      final apiDuration = apiEndTime.difference(apiStartTime);
      print('[GeminiService] API call completed in ${apiDuration.inMilliseconds}ms');

      // Extract response text
      final responseText = response.text ?? '';
      if (responseText.isEmpty) {
        throw Exception('Gemini returned empty response');
      }

      print('[GeminiService] Response length: ${responseText.length} characters');

      // Validate content length for platform
      if (!PlatformPrompts.validateContentLength(platform, responseText)) {
        final limit = PlatformPrompts.getCharacterLimit(platform);
        print('[GeminiService] WARNING: Content exceeds platform limit of $limit characters');
      }

      // Calculate timing metrics
      final overallEndTime = DateTime.now();
      final totalDuration = overallEndTime.difference(overallStartTime);
      final processingDuration = totalDuration - apiDuration;

      final timingBreakdown = {
        'total_ms': totalDuration.inMilliseconds,
        'api_call_ms': apiDuration.inMilliseconds,
        'processing_ms': processingDuration.inMilliseconds,
      };

      print('[GeminiService] Total duration: ${totalDuration.inMilliseconds}ms');
      print('[GeminiService] Processing overhead: ${processingDuration.inMilliseconds}ms');

      // Extract token usage if available
      int? tokensUsed;
      if (response.usageMetadata != null) {
        tokensUsed = (response.usageMetadata!.promptTokenCount ?? 0) +
            (response.usageMetadata!.candidatesTokenCount ?? 0);
        print('[GeminiService] Tokens used: $tokensUsed');
      }

      // Estimate cost
      final estimatedCost = AILoggingService.estimateCost(
        model: 'gemini-3-flash-preview',
        tokensUsed: tokensUsed,
      );
      if (estimatedCost != null) {
        print('[GeminiService] Estimated cost: \$${estimatedCost.toStringAsFixed(6)}');
      }

      // Log the interaction
      final logger = AILoggingService(session: _session);
      await logger.log(
        interactionType: 'initial_generation',
        prompt: fullPrompt,
        model: 'gemini-3-flash-preview',
        response: responseText,
        timingBreakdown: timingBreakdown,
        success: true,
        postId: postId,
        tokensUsed: tokensUsed,
        estimatedCostUsd: estimatedCost,
        parameters: {
          'platform': platform,
          'promptLength': fullPrompt.length,
          'responseLength': responseText.length,
        },
      );

      print('[GeminiService] Content generation completed successfully');
      return responseText;
    } catch (e, stackTrace) {
      final overallEndTime = DateTime.now();
      final totalDuration = overallEndTime.difference(overallStartTime);

      print('[GeminiService] ERROR: Content generation failed');
      print('[GeminiService] Error: $e');
      print('[GeminiService] Stack trace: $stackTrace');

      // Log the error
      final logger = AILoggingService(session: _session);
      await logger.log(
        interactionType: 'initial_generation',
        prompt: 'Platform: $platform, Request: $userPrompt',
        model: 'gemini-3-flash-preview',
        response: '',
        timingBreakdown: {
          'total_ms': totalDuration.inMilliseconds,
          'api_call_ms': 0,
          'processing_ms': 0,
        },
        success: false,
        postId: postId,
        errorMessage: e.toString(),
        parameters: {
          'platform': platform,
        },
      );

      rethrow;
    }
  }

  /// Edits existing content based on user feedback
  ///
  /// [platform] - The target platform
  /// [originalContent] - The existing content to edit
  /// [editRequest] - User's request for changes
  /// [companyInfo] - Company/brand information for context
  /// [productInfo] - Product/service information for context
  /// [postId] - Optional post ID for logging
  ///
  /// Returns the edited content as a String
  Future<String> editContent({
    required String platform,
    required String originalContent,
    required String editRequest,
    required String companyInfo,
    required String productInfo,
    int? postId,
  }) async {
    final overallStartTime = DateTime.now();

    try {
      print('[GeminiService] Starting content edit for platform: $platform');

      // Build edit prompt
      final platformGuide = PlatformPrompts.platformInstructions[platform.toLowerCase()] ??
          PlatformPrompts.platformInstructions['x']!;

      final editPrompt = '''
You are an expert social media content editor for ${platform}.

COMPANY INFORMATION:
$companyInfo

PRODUCT/SERVICE INFORMATION:
$productInfo

PLATFORM GUIDELINES:
$platformGuide

ORIGINAL CONTENT:
$originalContent

USER'S EDIT REQUEST:
$editRequest

Please edit the content according to the user's request while:
1. Maintaining platform best practices and character limits
2. Keeping the brand voice consistent
3. Ensuring the edited content is engaging and effective

Return ONLY the edited content, without explanations or meta-commentary.
''';

      print('[GeminiService] Edit prompt length: ${editPrompt.length} characters');
      print('[GeminiService] Calling Gemini API for edit...');

      // Call Gemini API
      final apiStartTime = DateTime.now();
      final response = await textModel.generateContent([Content.text(editPrompt)]);
      final apiEndTime = DateTime.now();

      final apiDuration = apiEndTime.difference(apiStartTime);
      print('[GeminiService] API call completed in ${apiDuration.inMilliseconds}ms');

      final editedContent = response.text ?? '';
      if (editedContent.isEmpty) {
        throw Exception('Gemini returned empty response for edit');
      }

      print('[GeminiService] Edited content length: ${editedContent.length} characters');

      // Calculate timing
      final overallEndTime = DateTime.now();
      final totalDuration = overallEndTime.difference(overallStartTime);

      final timingBreakdown = {
        'total_ms': totalDuration.inMilliseconds,
        'api_call_ms': apiDuration.inMilliseconds,
        'processing_ms': totalDuration.inMilliseconds - apiDuration.inMilliseconds,
      };

      // Extract token usage
      int? tokensUsed;
      if (response.usageMetadata != null) {
        tokensUsed = (response.usageMetadata!.promptTokenCount ?? 0) +
            (response.usageMetadata!.candidatesTokenCount ?? 0);
      }

      // Estimate cost
      final estimatedCost = AILoggingService.estimateCost(
        model: 'gemini-3-flash-preview',
        tokensUsed: tokensUsed,
      );

      // Log the interaction
      final logger = AILoggingService(session: _session);
      await logger.log(
        interactionType: 'edit_request',
        prompt: editPrompt,
        model: 'gemini-3-flash-preview',
        response: editedContent,
        timingBreakdown: timingBreakdown,
        success: true,
        postId: postId,
        tokensUsed: tokensUsed,
        estimatedCostUsd: estimatedCost,
        parameters: {
          'platform': platform,
          'originalLength': originalContent.length,
          'editedLength': editedContent.length,
        },
      );

      print('[GeminiService] Content edit completed successfully');
      return editedContent;
    } catch (e, stackTrace) {
      final overallEndTime = DateTime.now();
      final totalDuration = overallEndTime.difference(overallStartTime);

      print('[GeminiService] ERROR: Content edit failed');
      print('[GeminiService] Error: $e');

      // Log the error
      final logger = AILoggingService(session: _session);
      await logger.log(
        interactionType: 'edit_request',
        prompt: 'Edit request: $editRequest',
        model: 'gemini-3-flash-preview',
        response: '',
        timingBreakdown: {
          'total_ms': totalDuration.inMilliseconds,
          'api_call_ms': 0,
          'processing_ms': 0,
        },
        success: false,
        postId: postId,
        errorMessage: e.toString(),
      );

      rethrow;
    }
  }

  /// Generates a marketing image using Gemini
  ///
  /// [prompt] - Description of the desired image
  /// [platform] - Optional platform for platform-specific requirements
  /// [companyInfo] - Optional company/brand context
  /// [postId] - Optional post ID for logging
  ///
  /// Returns the generated image as Uint8List
  Future<Uint8List> generateMarketingImage({
    required String prompt,
    String? platform,
    String? companyInfo,
    int? postId,
  }) async {
    final overallStartTime = DateTime.now();

    try {
      print('[GeminiService] Starting image generation');

      // Build image generation prompt
      final imagePrompt = platform != null && companyInfo != null
          ? PlatformPrompts.getImageGenerationPrompt(
              platform: platform,
              contentDescription: prompt,
              companyInfo: companyInfo,
            )
          : prompt;

      print('[GeminiService] Image prompt length: ${imagePrompt.length} characters');
      print('[GeminiService] Calling Gemini API for image generation...');

      // Note: As of the current Gemini API, image generation is not directly supported
      // This is a placeholder for when the feature becomes available
      // For now, we'll throw an informative error
      throw UnimplementedError(
        'Image generation is not yet supported by the Gemini API. '
        'Consider using DALL-E, Stable Diffusion, or other image generation services.',
      );

      // Future implementation would look like:
      // final apiStartTime = DateTime.now();
      // final response = await imageModel.generateImage(imagePrompt);
      // final apiEndTime = DateTime.now();
      //
      // ... logging and return image data
    } catch (e, stackTrace) {
      final overallEndTime = DateTime.now();
      final totalDuration = overallEndTime.difference(overallStartTime);

      print('[GeminiService] ERROR: Image generation failed');
      print('[GeminiService] Error: $e');

      // Log the error
      final logger = AILoggingService(session: _session);
      await logger.log(
        interactionType: 'image_generation',
        prompt: prompt,
        model: 'gemini-3-flash-preview',
        response: '',
        timingBreakdown: {
          'total_ms': totalDuration.inMilliseconds,
          'api_call_ms': 0,
          'processing_ms': 0,
        },
        success: false,
        postId: postId,
        errorMessage: e.toString(),
      );

      rethrow;
    }
  }

  /// Generates multiple content variations for A/B testing
  ///
  /// [platform] - The target platform
  /// [companyInfo] - Company/brand information
  /// [productInfo] - Product/service information
  /// [userPrompt] - User's content request
  /// [variations] - Number of variations to generate (default: 3)
  /// [postId] - Optional post ID for logging
  ///
  /// Returns a list of content variations
  Future<List<String>> generateContentVariations({
    required String platform,
    required String companyInfo,
    required String productInfo,
    required String userPrompt,
    int variations = 3,
    int? postId,
  }) async {
    print('[GeminiService] Generating $variations content variations');

    final systemPrompt = PlatformPrompts.getSystemPrompt(
      platform: platform,
      companyInfo: companyInfo,
      productInfo: productInfo,
    );

    final variationsPrompt = '''
$systemPrompt

User request: $userPrompt

Please generate $variations different variations of this content, each with a slightly different approach or angle.
Separate each variation with "---VARIATION---" on its own line.

Each variation should:
1. Meet all platform requirements
2. Have a unique angle or hook
3. Be ready to post without modifications
4. Maintain consistent brand voice

Return ONLY the variations separated by ---VARIATION---, no other text.
''';

    try {
      final response = await textModel.generateContent([Content.text(variationsPrompt)]);
      final responseText = response.text ?? '';

      if (responseText.isEmpty) {
        throw Exception('Gemini returned empty response for variations');
      }

      // Split by separator
      final variationsList = responseText
          .split('---VARIATION---')
          .map((v) => v.trim())
          .where((v) => v.isNotEmpty)
          .toList();

      print('[GeminiService] Generated ${variationsList.length} variations');

      // If we didn't get the expected number, still return what we got
      if (variationsList.length != variations) {
        print('[GeminiService] WARNING: Expected $variations variations, got ${variationsList.length}');
      }

      return variationsList;
    } catch (e) {
      print('[GeminiService] ERROR: Failed to generate variations: $e');
      rethrow;
    }
  }

  /// Analyzes content quality and provides suggestions
  ///
  /// [platform] - The target platform
  /// [content] - The content to analyze
  ///
  /// Returns analysis and suggestions as a Map
  Future<Map<String, dynamic>> analyzeContent({
    required String platform,
    required String content,
  }) async {
    print('[GeminiService] Analyzing content for platform: $platform');

    final platformGuide = PlatformPrompts.platformInstructions[platform.toLowerCase()] ??
        PlatformPrompts.platformInstructions['x']!;

    final analysisPrompt = '''
You are a social media content analyst for ${platform}.

PLATFORM GUIDELINES:
$platformGuide

CONTENT TO ANALYZE:
$content

Please analyze this content and provide feedback in the following JSON format:
{
  "score": <0-100>,
  "strengths": ["strength1", "strength2", ...],
  "weaknesses": ["weakness1", "weakness2", ...],
  "suggestions": ["suggestion1", "suggestion2", ...],
  "characterCount": <number>,
  "withinLimits": <true/false>,
  "hashtagCount": <number>,
  "emojiCount": <number>
}

Provide specific, actionable feedback.
''';

    try {
      final response = await textModel.generateContent([Content.text(analysisPrompt)]);
      final responseText = response.text ?? '';

      if (responseText.isEmpty) {
        throw Exception('Gemini returned empty analysis');
      }

      // Try to parse JSON from response (Gemini might wrap it in markdown)
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(responseText);
      if (jsonMatch != null) {
        final jsonStr = jsonMatch.group(0)!;
        // Parse the JSON (would need to import dart:convert)
        // For now, return raw response
        return {'raw': responseText, 'parsed': jsonStr};
      }

      return {'raw': responseText};
    } catch (e) {
      print('[GeminiService] ERROR: Failed to analyze content: $e');
      rethrow;
    }
  }

  /// Generates marketing content for ALL platforms at once
  ///
  /// This is the main method for creating a complete social media campaign.
  /// It generates platform-specific text for each platform and optionally
  /// generates marketing images.
  ///
  /// Parameters:
  /// - [companyInfo] - Information about the company/brand
  /// - [productInfo] - Information about the product or service
  /// - [userPrompt] - User's request for content
  /// - [platforms] - List of platforms to generate content for (default: all 5)
  /// - [generateImage] - Whether to generate marketing image (default: true)
  /// - [imagePrompt] - Custom image prompt (optional, auto-generated if not provided)
  /// - [postId] - Optional post ID for logging
  ///
  /// Returns a Map with platform-specific content and optional image URL
  /// Example: {
  ///   'x': 'Tweet content...',
  ///   'linkedin': 'LinkedIn post...',
  ///   'instagram': 'Instagram caption...',
  ///   'facebook': 'Facebook post...',
  ///   'pinterest': 'Pinterest description...',
  ///   'imagePrompt': 'Generated image description',
  ///   'timings': {...}
  /// }
  Future<Map<String, dynamic>> generateCampaignContent({
    required String companyInfo,
    required String productInfo,
    required String userPrompt,
    List<String>? platforms,
    bool generateImage = true,
    String? imagePrompt,
    int? postId,
  }) async {
    final campaignStartTime = DateTime.now();
    final result = <String, dynamic>{};
    final timings = <String, dynamic>{};

    // Default to all 5 major platforms
    final targetPlatforms = platforms ?? ['x', 'linkedin', 'instagram', 'facebook', 'pinterest'];

    print('[GeminiService] Starting campaign content generation');
    print('[GeminiService] Platforms: ${targetPlatforms.join(', ')}');
    print('[GeminiService] Generate image: $generateImage');

    try {
      // Generate text content for each platform
      final platformContents = <String, String>{};

      for (final platform in targetPlatforms) {
        print('[GeminiService] Generating content for $platform...');
        final platformStartTime = DateTime.now();

        final content = await generatePlatformContent(
          platform: platform,
          companyInfo: companyInfo,
          productInfo: productInfo,
          userPrompt: userPrompt,
          postId: postId,
        );

        final platformDuration = DateTime.now().difference(platformStartTime);
        platformContents[platform] = content;
        timings['${platform}_ms'] = platformDuration.inMilliseconds;

        print('[GeminiService] ✓ $platform content generated (${platformDuration.inMilliseconds}ms)');
      }

      result.addAll(platformContents);

      // Generate image if requested
      if (generateImage) {
        print('[GeminiService] Generating marketing image...');
        final imageStartTime = DateTime.now();

        // Auto-generate image prompt based on content and company info
        final finalImagePrompt = imagePrompt ?? await _generateImagePrompt(
          companyInfo: companyInfo,
          productInfo: productInfo,
          userPrompt: userPrompt,
        );

        result['imagePrompt'] = finalImagePrompt;
        print('[GeminiService] Image prompt: $finalImagePrompt');

        // Note: Image generation using Gemini image model
        // For now, we'll return the prompt; actual image generation can be added
        // when implementing the full image generation pipeline
        final imageDuration = DateTime.now().difference(imageStartTime);
        timings['image_prompt_ms'] = imageDuration.inMilliseconds;

        print('[GeminiService] ✓ Image prompt generated (${imageDuration.inMilliseconds}ms)');
      }

      // Calculate total timing
      final totalDuration = DateTime.now().difference(campaignStartTime);
      timings['total_ms'] = totalDuration.inMilliseconds;
      timings['platforms_count'] = targetPlatforms.length;

      result['timings'] = timings;

      print('[GeminiService] ✅ Campaign content generation completed');
      print('[GeminiService] Total duration: ${totalDuration.inMilliseconds}ms');
      print('[GeminiService] Average per platform: ${totalDuration.inMilliseconds ~/ targetPlatforms.length}ms');

      return result;
    } catch (e) {
      print('[GeminiService] ERROR: Campaign generation failed: $e');
      rethrow;
    }
  }

  /// Generates an image description prompt based on campaign information
  Future<String> _generateImagePrompt({
    required String companyInfo,
    required String productInfo,
    required String userPrompt,
  }) async {
    final prompt = '''
You are a marketing image consultant. Based on the following campaign information,
create a detailed image generation prompt for a professional marketing image.

COMPANY: $companyInfo
PRODUCT/SERVICE: $productInfo
CAMPAIGN MESSAGE: $userPrompt

Generate a concise but detailed image prompt (2-3 sentences) that describes:
1. The main visual elements
2. The mood/atmosphere
3. Colors and style that align with the brand

Return ONLY the image prompt, no explanations.
''';

    try {
      final response = await textModel.generateContent([Content.text(prompt)]);
      return response.text?.trim() ?? 'Professional marketing image for $productInfo';
    } catch (e) {
      print('[GeminiService] Warning: Could not generate image prompt: $e');
      return 'Professional marketing image showcasing $productInfo for $companyInfo';
    }
  }

  /// Cleans up resources (if needed)
  void dispose() {
    // Currently no cleanup needed, but method provided for future use
  }
}
