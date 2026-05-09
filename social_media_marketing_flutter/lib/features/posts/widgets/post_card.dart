import 'package:flutter/material.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../core/constants/app_spacing.dart';
import 'post_status_chip.dart';
import 'platform_badges.dart';

/// Compact card showing post information.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.platforms,
    required this.content,
    this.onTap,
    this.onEdit,
    this.onDuplicate,
    this.onPublishNow,
    this.onDelete,
  });

  final Post post;
  final List<String> platforms;
  final Map<String, String> content;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onPublishNow;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get first platform's content for preview
    final previewContent = _getPreviewContent();

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSpacing.borderRadiusMD,
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title, Status, Actions
              Row(
                children: [
                  Expanded(
                    child: Text(
                      post.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap.sm(),
                  PostStatusChip(
                    status: post.status,
                    compact: true,
                  ),
                  const Gap.xs(),
                  _buildActionsMenu(context),
                ],
              ),
              const Gap.sm(),

              // Platform badges
              PlatformBadges(platforms: platforms),
              const Gap.sm(),

              // Schedule time or published time
              Row(
                children: [
                  Icon(
                    _getTimeIcon(),
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const Gap.xs(),
                  Text(
                    _getTimeText(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Gap.sm(),

              // Content preview
              if (previewContent.isNotEmpty)
                Text(
                  previewContent,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionsMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20),
      padding: EdgeInsets.zero,
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              Gap.sm(),
              Text('View/Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              Icon(Icons.content_copy, size: 18),
              Gap.sm(),
              Text('Duplicate'),
            ],
          ),
        ),
        if (post.status == 'draft' || post.status == 'scheduled')
          const PopupMenuItem(
            value: 'publish',
            child: Row(
              children: [
                Icon(Icons.send, size: 18),
                Gap.sm(),
                Text('Publish Now'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              Gap.sm(),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit?.call();
            break;
          case 'duplicate':
            onDuplicate?.call();
            break;
          case 'publish':
            onPublishNow?.call();
            break;
          case 'delete':
            onDelete?.call();
            break;
        }
      },
    );
  }

  IconData _getTimeIcon() {
    switch (post.status) {
      case 'scheduled':
        return Icons.schedule;
      case 'published':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      default:
        return Icons.access_time;
    }
  }

  String _getTimeText() {
    if (post.publishedAt != null) {
      return 'Published ${_formatDateTime(post.publishedAt!)}';
    } else if (post.scheduleTime != null) {
      return 'Scheduled for ${_formatDateTime(post.scheduleTime!)}';
    } else {
      return 'Created ${_formatDateTime(post.createdAt)}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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
      return 'Just now';
    }
  }

  String _getPreviewContent() {
    if (content.isEmpty) return '';

    // Get first platform's content
    final firstContent = content.values.first;
    if (firstContent.length <= 100) {
      return firstContent;
    }

    return '${firstContent.substring(0, 100)}...';
  }
}
