import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extension methods for common operations

/// BuildContext extensions
extension BuildContextX on BuildContext {
  /// Get current theme
  ThemeData get theme => Theme.of(this);

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if screen is small (mobile)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if screen is medium (tablet)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Check if screen is large (desktop)
  bool get isLargeScreen => screenWidth >= 1200;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }
}

/// DateTime extensions
extension DateTimeX on DateTime {
  /// Format as date only (e.g., "Jan 15, 2024")
  String get toDateString => DateFormat.yMMMd().format(this);

  /// Format as date and time (e.g., "Jan 15, 2024 3:45 PM")
  String get toDateTimeString => DateFormat.yMMMd().add_jm().format(this);

  /// Format as time only (e.g., "3:45 PM")
  String get toTimeString => DateFormat.jm().format(this);

  /// Format as relative time (e.g., "2 hours ago")
  String get toRelativeString {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'just now';
    }
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Check if date is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if date is in the future
  bool get isFuture => isAfter(DateTime.now());
}

/// String extensions
extension StringX on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$ellipsis';
  }

  /// Check if string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');
}

/// List extensions
extension ListX<T> on List<T> {
  /// Get first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;
}

/// Post status extensions
extension PostStatusX on String {
  /// Get color for post status
  Color getStatusColor(BuildContext context) {
    final colorScheme = context.colorScheme;
    switch (toLowerCase()) {
      case 'published':
      case 'succeeded':
        return Colors.green;
      case 'scheduled':
      case 'pending':
        return Colors.orange;
      case 'failed':
        return colorScheme.error;
      case 'draft':
        return Colors.grey;
      default:
        return colorScheme.onSurface;
    }
  }

  /// Get icon for post status
  IconData getStatusIcon() {
    switch (toLowerCase()) {
      case 'published':
      case 'succeeded':
        return Icons.check_circle;
      case 'scheduled':
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      case 'draft':
        return Icons.edit_note;
      default:
        return Icons.circle;
    }
  }
}

/// Platform extensions
extension PlatformX on String {
  /// Get color for social media platform
  Color getPlatformColor() {
    switch (toLowerCase()) {
      case 'x':
      case 'twitter':
        return const Color(0xFF1DA1F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'pinterest':
        return const Color(0xFFE60023);
      default:
        return Colors.grey;
    }
  }

  /// Get icon for social media platform
  IconData getPlatformIcon() {
    // Using material icons as placeholders
    // In production, you'd use custom icons or a package like font_awesome_flutter
    switch (toLowerCase()) {
      case 'x':
      case 'twitter':
        return Icons.tag; // Placeholder for X icon
      case 'linkedin':
        return Icons.work;
      case 'instagram':
        return Icons.photo_camera;
      case 'facebook':
        return Icons.thumb_up;
      case 'pinterest':
        return Icons.push_pin;
      default:
        return Icons.public;
    }
  }

  /// Get display name for platform
  String get platformDisplayName {
    switch (toLowerCase()) {
      case 'x':
        return 'X (Twitter)';
      case 'linkedin':
        return 'LinkedIn';
      case 'instagram':
        return 'Instagram';
      case 'facebook':
        return 'Facebook';
      case 'pinterest':
        return 'Pinterest';
      default:
        return capitalize;
    }
  }
}
