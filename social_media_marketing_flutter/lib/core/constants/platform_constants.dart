import 'package:flutter/material.dart';

/// Platform-specific constants for social media platforms.
///
/// Provides character limits, display names, colors, and helper methods
/// for all supported social media platforms.
class PlatformConstants {
  // Private constructor to prevent instantiation
  PlatformConstants._();

  /// Character limits for each platform
  static const Map<String, int> characterLimits = {
    'x': 280,
    'linkedin': 3000,
    'instagram': 2200,
    'facebook': 63206,
    'pinterest': 500,
  };

  /// Display names for platforms
  static const Map<String, String> platformNames = {
    'x': 'X (Twitter)',
    'linkedin': 'LinkedIn',
    'instagram': 'Instagram',
    'facebook': 'Facebook',
    'pinterest': 'Pinterest',
  };

  /// Platform brand colors
  static const Map<String, Color> platformColors = {
    'x': Color(0xFF000000), // Black
    'linkedin': Color(0xFF0077B5), // LinkedIn Blue
    'instagram': Color(0xFFE4405F), // Instagram Pink/Red
    'facebook': Color(0xFF1877F2), // Facebook Blue
    'pinterest': Color(0xFFE60023), // Pinterest Red
  };

  /// Platform icons (Material Icons)
  static final Map<String, IconData> platformIcons = {
    'x': Icons.close, // X icon
    'linkedin': Icons.work,
    'instagram': Icons.camera_alt,
    'facebook': Icons.facebook,
    'pinterest': Icons.push_pin,
  };

  /// List of all supported platforms
  static const List<String> supportedPlatforms = [
    'x',
    'linkedin',
    'instagram',
    'facebook',
    'pinterest',
  ];

  /// Gets the character limit for a specific platform
  ///
  /// Returns the character limit or a default of 280 if platform not found
  static int getCharacterLimit(String platform) {
    return characterLimits[platform.toLowerCase()] ?? 280;
  }

  /// Gets the display name for a platform
  ///
  /// Returns the display name or the platform key if not found
  static String getPlatformName(String platform) {
    return platformNames[platform.toLowerCase()] ?? platform;
  }

  /// Gets the brand color for a platform
  ///
  /// Returns the brand color or gray if platform not found
  static Color getPlatformColor(String platform) {
    return platformColors[platform.toLowerCase()] ?? Colors.grey;
  }

  /// Gets the Material icon for a platform
  ///
  /// Returns the IconData or Icons.public if platform not found
  static IconData getPlatformIcon(String platform) {
    return platformIcons[platform.toLowerCase()] ?? Icons.public;
  }

  /// Checks if a platform is supported
  static bool isPlatformSupported(String platform) {
    return supportedPlatforms.contains(platform.toLowerCase());
  }

  /// Validates content length for a platform
  ///
  /// Returns true if content is within the platform's character limit
  static bool isContentValid(String platform, String content) {
    final limit = getCharacterLimit(platform);
    return content.length <= limit;
  }

  /// Calculates remaining characters for a platform
  ///
  /// Returns the number of characters remaining (can be negative if over limit)
  static int getRemainingCharacters(String platform, String content) {
    final limit = getCharacterLimit(platform);
    return limit - content.length;
  }

  /// Gets a human-readable character count status
  ///
  /// Returns a string like "250/280" or "300/280 (over by 20)"
  static String getCharacterCountStatus(String platform, String content) {
    final limit = getCharacterLimit(platform);
    final count = content.length;

    if (count <= limit) {
      return '$count/$limit';
    } else {
      final over = count - limit;
      return '$count/$limit (over by $over)';
    }
  }

  /// Platform-specific content formatting guidelines
  static const Map<String, String> contentGuidelines = {
    'x': 'Concise and engaging. Use hashtags strategically (1-2 recommended).',
    'linkedin': 'Professional tone. First 2-3 lines are crucial for engagement.',
    'instagram': 'Visual-first. Use emojis and line breaks for readability.',
    'facebook': 'Conversational and engaging. Can be longer form.',
    'pinterest': 'Descriptive and keyword-rich. Focus on benefits.',
  };

  /// Gets content guidelines for a platform
  static String? getContentGuidelines(String platform) {
    return contentGuidelines[platform.toLowerCase()];
  }

  /// Recommended hashtag counts per platform
  static const Map<String, int> recommendedHashtagCounts = {
    'x': 2,
    'linkedin': 3,
    'instagram': 10,
    'facebook': 2,
    'pinterest': 5,
  };

  /// Gets recommended hashtag count for a platform
  static int getRecommendedHashtagCount(String platform) {
    return recommendedHashtagCounts[platform.toLowerCase()] ?? 2;
  }
}
