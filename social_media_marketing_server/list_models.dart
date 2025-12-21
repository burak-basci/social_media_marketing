/// List available Gemini models
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = 'AIzaSyByMkTwi_Zab4KgRh9SBg6g6j1P1xz2gRs';

  print('Fetching available Gemini models...\n');

  final response = await http.get(
    Uri.parse('https://generativelanguage.googleapis.com/v1beta/models?key=$apiKey'),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final models = data['models'] as List;

    print('Available models for generateContent:');
    for (final model in models) {
      final name = model['name'] as String;
      final supportedMethods = model['supportedGenerationMethods'] as List?;

      if (supportedMethods != null && supportedMethods.contains('generateContent')) {
        print('  ✓ ${name.replaceAll('models/', '')}');
      }
    }
  } else {
    print('Error: ${response.statusCode}');
    print(response.body);
  }
}
