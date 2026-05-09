import 'package:flutter/material.dart';
import '../../../core/constants/platform_constants.dart';

/// Row of platform icons for a post.
///
/// Uses PlatformConstants for icons and colors.
class PlatformBadges extends StatelessWidget {
  const PlatformBadges({
    super.key,
    required this.platforms,
    this.size = 20,
    this.spacing = 4,
  });

  final List<String> platforms;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (platforms.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: platforms.map((platform) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: PlatformConstants.getPlatformColor(platform),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            PlatformConstants.getPlatformIcon(platform),
            size: size * 0.6,
            color: Colors.white,
          ),
        );
      }).toList(),
    );
  }
}

/// Larger platform badge with label
class PlatformBadge extends StatelessWidget {
  const PlatformBadge({
    super.key,
    required this.platform,
    this.size = 32,
    this.showLabel = true,
  });

  final String platform;
  final double size;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 8 : 4,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: PlatformConstants.getPlatformColor(platform).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: PlatformConstants.getPlatformColor(platform).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            PlatformConstants.getPlatformIcon(platform),
            size: size * 0.6,
            color: PlatformConstants.getPlatformColor(platform),
          ),
          if (showLabel) ...[
            const SizedBox(width: 6),
            Text(
              PlatformConstants.getPlatformName(platform),
              style: theme.textTheme.labelSmall?.copyWith(
                color: PlatformConstants.getPlatformColor(platform),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
