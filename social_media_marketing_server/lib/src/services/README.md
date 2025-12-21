# Gemini AI Services

This directory contains the Gemini AI integration services for social media content generation.

## Overview

The Gemini service provides intelligent content generation for multiple social media platforms using Google's Gemini AI models. It includes comprehensive logging, timing analysis, and cost estimation.

## Files

### 1. `gemini_service.dart`
Main service for interacting with Gemini AI.

**Features:**
- Platform-specific content generation
- Content editing based on user feedback
- Multiple content variations for A/B testing
- Content quality analysis
- Automatic timing tracking
- Token usage monitoring
- Cost estimation

**Models Used:**
- Text generation: `gemini-2.0-flash-exp`
- Image generation: `gemini-2.0-flash-exp` (placeholder - not yet implemented)

### 2. `platform_prompts.dart`
Platform-specific prompts and guidelines.

**Supported Platforms:**
- **X (Twitter)**: 280 char limit, punchy, hashtags
- **LinkedIn**: 1000-1500 chars, professional, insights
- **Instagram**: Visual-first, emoji-heavy, 5-10 hashtags
- **Facebook**: Conversational, engagement-focused
- **Pinterest**: SEO-optimized, keyword-rich, descriptive

**Features:**
- Character limit validation
- Platform-specific best practices
- Image generation prompts (for future use)
- Recommended content ranges

### 3. `ai_logging_service.dart`
Comprehensive logging for all AI interactions.

**Logging Levels:**
- `FULL`: Complete prompts, responses, timing, tokens, costs
- `TIMING`: Only metrics and metadata
- `ERRORS`: Only failures and errors
- `NONE`: Logging disabled

**Storage:**
- Database: `ai_interaction_log` table
- JSONL files: `logs/llm_interactions_YYYYMMDD.jsonl`

**Analytics:**
- Timing pattern analysis (avg, median, p95, p99)
- Cost tracking and breakdown by model
- Token usage statistics
- Per-post interaction history

### 4. `example_usage.dart`
Comprehensive usage examples and documentation.

## Setup

### 1. Install Dependencies

Dependencies are already added to `pubspec.yaml`:
```yaml
dependencies:
  google_generative_ai: ^0.4.6
  http: ^1.2.2
```

Run:
```bash
dart pub get
```

### 2. Get Gemini API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create or select a project
3. Generate an API key
4. Copy the API key

### 3. Set Environment Variables

**Required:**
```bash
export GEMINI_API_KEY="your-api-key-here"
```

**Optional:**
```bash
export LLM_LOGGING_LEVEL="FULL"  # FULL, TIMING, ERRORS, or NONE
```

**In Docker/docker-compose.yaml:**
```yaml
services:
  server:
    environment:
      - GEMINI_API_KEY=${GEMINI_API_KEY}
      - LLM_LOGGING_LEVEL=FULL
```

## Quick Start

### Basic Usage

```dart
import 'package:serverpod/serverpod.dart';
import '../services/gemini_service.dart';

class MyEndpoint extends Endpoint {
  Future<String> generate(Session session) async {
    final gemini = GeminiService.fromEnvironment(session: session);

    return await gemini.generatePlatformContent(
      platform: 'x',
      companyInfo: 'Tech startup building AI tools',
      productInfo: 'Social media automation platform',
      userPrompt: 'Announce our new feature launch',
    );
  }
}
```

### Advanced Usage with Database

```dart
Future<Post> createPost(
  Session session,
  int orgId,
  String platform,
  String prompt,
) async {
  // Fetch context
  final org = await Organization.db.findById(session, orgId);

  // Initialize service
  final gemini = GeminiService.fromEnvironment(session: session);

  // Create post
  final post = await Post.db.insertRow(
    session,
    Post(
      userId: session.auth.authenticatedUserId!,
      organizationId: orgId,
      platform: platform,
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  // Generate content
  final content = await gemini.generatePlatformContent(
    platform: platform,
    companyInfo: org!.description,
    productInfo: '',
    userPrompt: prompt,
    postId: post.id,  // For logging
  );

  // Update post
  return await Post.db.updateRow(
    session,
    post.copyWith(content: content, updatedAt: DateTime.now()),
  );
}
```

## API Reference

### GeminiService

#### Constructor
```dart
GeminiService({required String apiKey, Session? session})
GeminiService.fromEnvironment({Session? session})
```

#### Methods

##### generatePlatformContent()
Generate platform-specific social media content.

```dart
Future<String> generatePlatformContent({
  required String platform,      // 'x', 'linkedin', 'instagram', 'facebook', 'pinterest'
  required String companyInfo,   // Company/brand description
  required String productInfo,   // Product/service description
  required String userPrompt,    // User's content request
  int? postId,                   // Optional for logging
})
```

##### editContent()
Edit existing content based on user feedback.

```dart
Future<String> editContent({
  required String platform,
  required String originalContent,
  required String editRequest,
  required String companyInfo,
  required String productInfo,
  int? postId,
})
```

##### generateContentVariations()
Generate multiple variations for A/B testing.

```dart
Future<List<String>> generateContentVariations({
  required String platform,
  required String companyInfo,
  required String productInfo,
  required String userPrompt,
  int variations = 3,
  int? postId,
})
```

##### analyzeContent()
Analyze content quality and get suggestions.

```dart
Future<Map<String, dynamic>> analyzeContent({
  required String platform,
  required String content,
})
```

### AILoggingService

#### Static Methods

##### getLogsForPost()
Retrieve all AI interactions for a specific post.

```dart
static Future<List<AIInteractionLog>> getLogsForPost({
  required Session session,
  required int postId,
})
```

##### getRecentLogs()
Get recent logs with optional error filtering.

```dart
static Future<List<AIInteractionLog>> getRecentLogs({
  required Session session,
  int limit = 100,
  bool onlyErrors = false,
})
```

##### analyzeTimingPatterns()
Analyze timing metrics across recent interactions.

```dart
static Future<Map<String, dynamic>> analyzeTimingPatterns({
  required Session session,
  int limit = 1000,
})

// Returns: {
//   'count': 1000,
//   'average_ms': 1234,
//   'median_ms': 1100,
//   'p95_ms': 2000,
//   'p99_ms': 2500,
//   'min_ms': 500,
//   'max_ms': 3000,
// }
```

##### getCostAnalysis()
Get cost breakdown and usage statistics.

```dart
static Future<Map<String, dynamic>> getCostAnalysis({
  required Session session,
  DateTime? since,
})

// Returns: {
//   'totalCost': 12.34,
//   'totalTokens': 1000000,
//   'totalInteractions': 500,
//   'modelBreakdown': {
//     'gemini-2.5-flash': {
//       'count': 500,
//       'cost': 12.34,
//       'tokens': 1000000,
//     }
//   },
//   'period': 'since 2025-01-01T00:00:00.000Z'
// }
```

## Platform Guidelines

### X (Twitter)
- **Limit**: 280 characters
- **Style**: Punchy, concise
- **Hashtags**: 1-3
- **Emojis**: 1-2 max
- **Best for**: News, announcements, quick updates

### LinkedIn
- **Optimal**: 1000-1500 characters
- **Style**: Professional, insightful
- **Hashtags**: 3-5
- **Best for**: Thought leadership, industry insights

### Instagram
- **Optimal**: 200-500 characters
- **Style**: Visual, engaging
- **Hashtags**: 5-10 (up to 30)
- **Emojis**: 3-8
- **Best for**: Lifestyle, behind-the-scenes, visual storytelling

### Facebook
- **Optimal**: 100-400 characters
- **Style**: Conversational, community-focused
- **Hashtags**: 1-3 (optional)
- **Best for**: Engagement, community building

### Pinterest
- **Description**: 400-500 characters
- **Style**: SEO-optimized, descriptive
- **Hashtags**: 3-5
- **Best for**: Visual discovery, how-tos, inspiration

## Logging

### Log Levels

Set via `LLM_LOGGING_LEVEL` environment variable:

**FULL** (default):
- Complete prompts and responses
- All timing metrics
- Token counts and costs
- Saved to both database and JSONL files

**TIMING**:
- Timing metrics only
- Token counts and costs
- Prompt/response lengths (not full text)
- Useful for performance monitoring

**ERRORS**:
- Only failed interactions
- Full error details
- Minimal overhead

**NONE**:
- Logging completely disabled
- Maximum performance

### Log Files

**Location**: `logs/llm_interactions_YYYYMMDD.jsonl`

**Format**: One JSON object per line (JSONL)

**Example entry**:
```json
{
  "timestamp": "2025-12-20T10:30:45.123Z",
  "interactionType": "initial_generation",
  "model": "gemini-2.5-flash",
  "success": true,
  "timingBreakdown": {
    "total_ms": 1234,
    "api_call_ms": 1100,
    "processing_ms": 134
  },
  "postId": 42,
  "prompt": "...",
  "response": "...",
  "tokensUsed": 1500,
  "estimatedCost": 0.000225
}
```

## Cost Estimation

The service automatically estimates costs based on Gemini pricing:

**Gemini 2.5 Flash** (approximate):
- Input: $0.075 per 1M tokens
- Output: $0.30 per 1M tokens
- Blended estimate: $0.15 per 1M tokens

**Example costs**:
- Short tweet (~50 tokens): $0.000008
- LinkedIn post (~300 tokens): $0.000045
- Long blog (~1000 tokens): $0.00015

Monitor actual costs using:
```dart
final analysis = await AILoggingService.getCostAnalysis(
  session: session,
  since: DateTime.now().subtract(Duration(days: 30)),
);
print('Monthly cost: \$${analysis['totalCost']}');
```

## Performance

**Typical response times** (p50):
- X tweet: 800-1200ms
- LinkedIn post: 1200-1800ms
- Multiple variations: 2000-3000ms

Monitor performance:
```dart
final timing = await AILoggingService.analyzeTimingPatterns(
  session: session,
);
print('P95 latency: ${timing['p95_ms']}ms');
```

## Error Handling

All methods can throw:
- `GenerativeAIException`: Gemini API errors
- `Exception`: Configuration errors (missing API key, etc.)

```dart
try {
  final content = await gemini.generatePlatformContent(...);
} on GenerativeAIException catch (e) {
  print('Gemini API error: ${e.message}');
  // Handle API-specific errors
} on Exception catch (e) {
  print('General error: $e');
  // Handle configuration errors
}
```

## Best Practices

1. **Always use Session**: Pass session to services for proper logging
2. **Set postId**: Include postId when generating/editing content for better tracking
3. **Monitor costs**: Regularly check cost analysis
4. **Use appropriate logging level**: Production should use TIMING or ERRORS
5. **Handle errors gracefully**: Always wrap service calls in try-catch
6. **Validate content**: Check character limits before publishing
7. **Test platforms**: Different platforms need different approaches
8. **Cache when possible**: Avoid regenerating identical content

## Troubleshooting

### "GEMINI_API_KEY environment variable is not set"
**Solution**: Set the environment variable:
```bash
export GEMINI_API_KEY="your-key-here"
```

### "Gemini returned empty response"
**Possible causes**:
- API rate limiting
- Invalid API key
- Content policy violation
- Network issues

**Solution**: Check API key, verify content, check logs

### "Content exceeds platform limit"
**Solution**: The service logs a warning but returns content anyway. Ask user to edit or regenerate with "make it shorter" instruction.

### High costs
**Solution**:
- Use TIMING logging level in production
- Cache generated content
- Limit variation count
- Monitor via getCostAnalysis()

## Future Enhancements

- Image generation support (when Gemini API supports it)
- Content scheduling integration
- Multi-modal content (image + text)
- Sentiment analysis
- Engagement prediction
- Content calendar generation
- Hashtag suggestions
- Audience targeting recommendations

## Support

For issues or questions:
1. Check the logs: `logs/llm_interactions_*.jsonl`
2. Check database logs: `ai_interaction_log` table
3. Review error messages in console
4. Verify environment variables
5. Check Gemini API status: [status.cloud.google.com](https://status.cloud.google.com/)

## License

Part of the Social Media Marketing Serverpod application.
