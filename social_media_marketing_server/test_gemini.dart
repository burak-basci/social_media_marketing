/// Quick test script to verify Gemini integration
import 'dart:io';
import 'lib/src/services/gemini_service.dart';
import 'lib/src/services/platform_prompts.dart';

void main() async {
  print('=== Testing Gemini Service ===\n');

  // Set API key
  final apiKey = 'AIzaSyByMkTwi_Zab4KgRh9SBg6g6j1P1xz2gRs';

  print('[1/4] Testing service initialization...');
  final gemini = GeminiService(apiKey: apiKey);
  print('✓ Service initialized\n');

  print('[2/4] Testing single platform content generation (X/Twitter)...');
  try {
    final content = await gemini.generatePlatformContent(
      platform: 'x',
      companyInfo: 'Tech startup focused on AI-powered marketing automation',
      productInfo: 'Social media marketing platform that uses AI to create engaging content',
      userPrompt: 'Announce our new AI content generation feature with excitement',
    );
    print('✓ Content generated successfully');
    print('Generated content for X:');
    print('---');
    print(content);
    print('---\n');
  } catch (e) {
    print('✗ Failed to generate content: $e\n');
    exit(1);
  }

  print('[3/4] Testing platform character limits...');
  final platforms = ['x', 'linkedin', 'instagram', 'facebook', 'pinterest'];
  for (final platform in platforms) {
    final limit = PlatformPrompts.getCharacterLimit(platform);
    print('  $platform: $limit characters');
  }
  print('');

  print('[4/4] Testing content variations...');
  try {
    final variations = await gemini.generateContentVariations(
      platform: 'linkedin',
      companyInfo: 'Tech startup focused on AI-powered marketing automation',
      productInfo: 'Social media marketing platform that uses AI to create engaging content',
      userPrompt: 'Share a professional update about our growth',
      variations: 2,
    );
    print('✓ Generated ${variations.length} variations');
    for (var i = 0; i < variations.length; i++) {
      print('Variation ${i + 1}:');
      print(variations[i]);
      print('---');
    }
  } catch (e) {
    print('✗ Failed to generate variations: $e\n');
  }

  print('\n✅ All tests completed!');
}
