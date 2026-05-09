import 'package:flutter/material.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/platform_constants.dart';
import '../../../core/utils/extensions.dart';
import 'connection_status_badge.dart';

/// Card displaying platform connection information
class PlatformConnectionCard extends StatelessWidget {
  const PlatformConnectionCard({
    super.key,
    required this.platform,
    required this.isConnected,
    this.connection,
    required this.onDisconnect,
  });

  final String platform;
  final bool isConnected;
  final SocialMediaConnection? connection;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final platformColor = PlatformConstants.getPlatformColor(platform);
    final platformIcon = PlatformConstants.getPlatformIcon(platform);
    final platformName = PlatformConstants.getPlatformName(platform);

    return Card(
      elevation: AppSpacing.cardElevation,
      child: InkWell(
        borderRadius: AppSpacing.borderRadiusLG,
        onTap: isConnected ? null : () {
          // Show info about connecting in Postiz
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Connect $platformName in Postiz, then sync here',
              ),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Padding(
          padding: AppSpacing.paddingLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Platform icon and name
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isConnected
                          ? platformColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: AppSpacing.borderRadiusMD,
                    ),
                    child: Icon(
                      platformIcon,
                      color: isConnected ? platformColor : Colors.grey,
                      size: AppSpacing.iconLG,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          platformName,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        ConnectionStatusBadge(isConnected: isConnected),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              const Divider(),
              const SizedBox(height: AppSpacing.sm),

              // Connection details or not connected message
              if (isConnected && connection != null) ...[
                _buildConnectionDetails(context),
              ] else ...[
                _buildNotConnectedMessage(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account username
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: AppSpacing.iconSM,
              color: context.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '@${connection!.platformUsername}',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.sm),

        // Last synced time
        if (connection!.lastUsed != null) ...[
          Row(
            children: [
              Icon(
                Icons.sync,
                size: AppSpacing.iconSM,
                color: context.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Synced ${connection!.lastUsed!.toRelativeString}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ] else ...[
          const SizedBox(height: AppSpacing.md),
        ],

        // Disconnect button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onDisconnect,
            icon: const Icon(Icons.link_off, size: AppSpacing.iconSM),
            label: const Text('Disconnect'),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.colorScheme.error,
              side: BorderSide(color: context.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotConnectedMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Not connected',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Connect this account in Postiz, then sync here',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
