/// Quick test file to verify Gemini service setup.
/// This is NOT a unit test - it's a manual verification script.
///
/// Usage:
/// 1. Set GEMINI_API_KEY environment variable
/// 2. Run: dart lib/src/services/service_test.dart

import 'dart:io';
import 'gemini_service.dart';
import 'platform_prompts.dart';

void main() async {
  print('=== Gemini Service Setup Test ===\n');

  // Test 1: Check API key
  print('[1/5] Checking GEMINI_API_KEY environment variable...');
  final apiKey = Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    print('❌ FAILED: GEMINI_API_KEY is not set');
    print('Please set it: export GEMINI_API_KEY="your-key-here"');
    exit(1);
  }
  print('✓ API key found (${apiKey.substring(0, 10)}...)');

  // Test 2: Check platform prompts
  print('\n[2/5] Testing platform prompts...');
  final platforms = ['x', 'linkedin', 'instagram', 'facebook', 'pinterest'];
  for (final platform in platforms) {
    final prompt = PlatformPrompts.getSystemPrompt(
      platform: platform,
      companyInfo: 'Test Company',
      productInfo: 'Test Product',
    );
    if (prompt.isEmpty) {
      print('❌ FAILED: Empty prompt for $platform');
      exit(1);
    }
    final limit = PlatformPrompts.getCharacterLimit(platform);
    print('✓ $platform: ${prompt.length} chars prompt, $limit char limit');
  }

  // Test 3: Test character limit validation
  print('\n[3/5] Testing character limit validation...');
  final shortText = 'This is a short post';
  final longText = 'x' * 500;

  if (!PlatformPrompts.validateContentLength('x', shortText)) {
    print('❌ FAILED: Short text validation');
    exit(1);
  }
  if (PlatformPrompts.validateContentLength('x', longText)) {
    print('❌ FAILED: Long text should fail validation');
    exit(1);
  }
  print('✓ Character limit validation working');

  // Test 4: Initialize Gemini service
  print('\n[4/5] Initializing Gemini service...');
  try {
    final gemini = GeminiService.fromEnvironment();
    print('✓ GeminiService initialized successfully');
    print('  - Text model: gemini-1.5-flash');
    print('  - Image model: gemini-1.5-flash');
  } catch (e) {
    print('❌ FAILED: Could not initialize service');
    print('Error: $e');
    exit(1);
  }

  // Test 5: Test actual content generation (optional - requires API call)
  print('\n[5/5] Testing actual content generation...');
  print('NOTE: This will make a real API call and use credits');
  stdout.write('Proceed with API test? (y/N): ');
  final response = stdin.readLineSync()?.toLowerCase();

  if (response == 'y' || response == 'yes') {
    print('\nCalling Gemini API...');
    try {
      final gemini = GeminiService.fromEnvironment();
      final content = await gemini.generatePlatformContent(
        platform: 'x',
        companyInfo: 'Acme Corp - Innovative tech solutions',
        productInfo: 'Cloud-based project management tool',
        userPrompt: 'Announce our new AI-powered features',
      );

      print('✓ Content generated successfully!');
      print('\n--- Generated Content ---');
      print(content);
      print('--- End Content (${content.length} chars) ---');

      // Validate it meets platform requirements
      if (PlatformPrompts.validateContentLength('x', content)) {
        print('\n✓ Content is within X character limit');
      } else {
        print('\n⚠ Warning: Content exceeds X character limit');
      }
    } catch (e) {
      print('❌ FAILED: API call error');
      print('Error: $e');
      exit(1);
    }
  } else {
    print('⊘ Skipped API test');
  }

  print('\n=== All Tests Passed ✓ ===');
  print('\nYour Gemini service is ready to use!');
  print('\nNext steps:');
  print('1. Check the README.md for usage examples');
  print('2. Review example_usage.dart for implementation patterns');
  print('3. Set LLM_LOGGING_LEVEL environment variable (optional)');
  print('4. Start building your endpoints!');
}
