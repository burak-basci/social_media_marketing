/// Test full campaign generation for all platforms
import 'dart:convert';
import 'lib/src/services/gemini_service.dart';

void main() async {
  print('=== TESTING FULL CAMPAIGN GENERATION ===\n');

  final apiKey = 'AIzaSyByMkTwi_Zab4KgRh9SBg6g6j1P1xz2gRs';
  final gemini = GeminiService(apiKey: apiKey);

  print('Company: AI-powered marketing automation platform');
  print('Product: Social media content generator');
  print('Prompt: Announce our new AI feature that saves 10 hours per week\n');
  print('Generating content for: X, LinkedIn, Instagram, Facebook, Pinterest');
  print('With image prompt generation\n');
  print('─' * 80);
  print('');

  try {
    final result = await gemini.generateCampaignContent(
      companyInfo: 'AI-powered marketing automation platform focused on helping small businesses scale their social media presence',
      productInfo: 'Social media content generator that uses AI to create platform-specific posts with images',
      userPrompt: 'Announce our new AI feature that saves users 10 hours per week on content creation',
      generateImage: true,
    );

    print('\n' + '═' * 80);
    print('CAMPAIGN GENERATION RESULTS');
    print('═' * 80 + '\n');

    // Display content for each platform
    final platforms = ['x', 'linkedin', 'instagram', 'facebook', 'pinterest'];
    for (final platform in platforms) {
      if (result.containsKey(platform)) {
        print('┌─ ${platform.toUpperCase()} ${'─' * (73 - platform.length)}');
        print('│');
        final content = result[platform] as String;
        for (final line in content.split('\n')) {
          print('│ $line');
        }
        print('│');
        print('└' + '─' * 78);
        print('');
      }
    }

    // Display image prompt
    if (result.containsKey('imagePrompt')) {
      print('┌─ IMAGE PROMPT ' + '─' * 63);
      print('│');
      print('│ ${result['imagePrompt']}');
      print('│');
      print('└' + '─' * 78);
      print('');
    }

    // Display timing breakdown
    if (result.containsKey('timings')) {
      final timings = result['timings'] as Map<String, dynamic>;
      print('┌─ PERFORMANCE METRICS ' + '─' * 56);
      print('│');
      print('│ Total time: ${timings['total_ms']}ms');
      print('│ Platforms: ${timings['platforms_count']}');
      print('│ Average per platform: ${timings['total_ms'] ~/ timings['platforms_count']}ms');
      print('│');
      print('│ Per-platform breakdown:');
      for (final platform in platforms) {
        final key = '${platform}_ms';
        if (timings.containsKey(key)) {
          print('│   - $platform: ${timings[key]}ms');
        }
      }
      if (timings.containsKey('image_prompt_ms')) {
        print('│   - Image prompt: ${timings['image_prompt_ms']}ms');
      }
      print('│');
      print('└' + '─' * 78);
    }

    print('\n✅ Campaign generation SUCCESSFUL!\n');
  } catch (e, stackTrace) {
    print('\n❌ Campaign generation FAILED!');
    print('Error: $e');
    print('\nStack trace:');
    print(stackTrace);
  } finally {
    gemini.dispose();
  }
}
