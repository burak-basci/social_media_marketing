import 'package:flutter/material.dart';

/// Status chip widget with color-coded status indicators.
///
/// Status colors:
/// - draft: grey (neutral)
/// - scheduled: blue (primary)
/// - published: green (success)
/// - failed: red (error)
class PostStatusChip extends StatelessWidget {
  const PostStatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  final String status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusData = _getStatusData(theme);

    return Chip(
      label: Text(
        statusData.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: statusData.textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: statusData.backgroundColor,
      side: BorderSide.none,
      padding: compact
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 0)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: compact ? VisualDensity.compact : null,
    );
  }

  _StatusData _getStatusData(ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'draft':
        return _StatusData(
          label: 'Draft',
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          textColor: theme.colorScheme.onSurfaceVariant,
        );

      case 'scheduled':
        return _StatusData(
          label: 'Scheduled',
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          textColor: theme.colorScheme.primary,
        );

      case 'publishing':
        return _StatusData(
          label: 'Publishing',
          backgroundColor: theme.colorScheme.secondary.withValues(alpha: 0.1),
          textColor: theme.colorScheme.secondary,
        );

      case 'published':
        return _StatusData(
          label: 'Published',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          textColor: Colors.green.shade700,
        );

      case 'failed':
        return _StatusData(
          label: 'Failed',
          backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
          textColor: theme.colorScheme.error,
        );

      default:
        return _StatusData(
          label: status,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          textColor: theme.colorScheme.onSurfaceVariant,
        );
    }
  }
}

class _StatusData {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  _StatusData({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });
}
