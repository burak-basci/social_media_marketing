import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_spacing.dart';
import '../../posts/widgets/post_status_chip.dart';
import '../../posts/widgets/platform_badges.dart';
import '../../posts/providers/posts_provider.dart';
import '../../posts/screens/post_detail_dialog.dart';

/// Compact post card for calendar view.
///
/// Shows:
/// - Time
/// - Title
/// - Platform badges
/// - Status chip
/// - Click to open post detail dialog
class CalendarPostCard extends StatelessWidget {
  const CalendarPostCard({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final postsProvider = context.watch<PostsProvider>();
    final platforms = postsProvider.getPostPlatforms(post);
    final time = post.scheduleTime ?? post.createdAt;
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: () => _openPostDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Row(
            children: [
              // Time
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  timeFormat.format(time),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Gap.md(),

              // Post details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      post.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Gap.xs(),

                    // Platforms and Status
                    Row(
                      children: [
                        PlatformBadges(
                          platforms: platforms,
                          size: 16,
                          spacing: 4,
                        ),
                        const Gap.sm(),
                        PostStatusChip(
                          status: post.status,
                          compact: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Gap.sm(),

              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openPostDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PostDetailDialog(post: post),
    );
  }
}
