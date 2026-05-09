import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/platform_constants.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/layouts/main_layout.dart';
import '../providers/connections_provider.dart';
import '../widgets/platform_connection_card.dart';

/// Connections screen showing social media platform connections
class ConnectionsScreen extends StatelessWidget {
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 4,
      child: Consumer<ConnectionsProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: _buildHeader(context, provider),
              ),

              // Info card about Postiz integration
              SliverToBoxAdapter(
                child: _buildInfoCard(context),
              ),

              // Error message
              if (provider.hasError)
                SliverToBoxAdapter(
                  child: _buildErrorCard(context, provider),
                ),

              // Loading state
              if (provider.isLoading && !provider.hasConnections)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              // Empty state
              else if (!provider.hasConnections && !provider.isLoading)
                SliverFillRemaining(
                  child: _buildEmptyState(context, provider),
                )
              // Connections grid
              else
                SliverPadding(
                  padding: AppSpacing.paddingLG,
                  sliver: _buildConnectionsGrid(context, provider),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ConnectionsProvider provider) {
    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Platform Connections',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  provider.hasConnections
                      ? '${provider.connectedCount} of ${PlatformConstants.supportedPlatforms.length} platforms connected'
                      : 'No platforms connected yet',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Sync button
          FilledButton.icon(
            onPressed: provider.isSyncing
                ? null
                : () => _handleSync(context, provider),
            icon: provider.isSyncing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync),
            label: Text(provider.isSyncing ? 'Syncing...' : 'Sync from Postiz'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
      margin: AppSpacing.paddingLG,
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: context.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: context.colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.colorScheme.primary,
            size: AppSpacing.iconLG,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Platform Connections',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Connect your social media accounts in Postiz, then use the "Sync from Postiz" button to import them here. Once connected, you can publish posts to these platforms.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, ConnectionsProvider provider) {
    return Container(
      margin: AppSpacing.paddingLG.copyWith(top: 0),
      padding: AppSpacing.paddingMD,
      decoration: BoxDecoration(
        color: context.colorScheme.errorContainer,
        borderRadius: AppSpacing.borderRadiusLG,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: context.colorScheme.error,
            size: AppSpacing.iconLG,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              provider.error!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: provider.clearError,
            color: context.colorScheme.onErrorContainer,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ConnectionsProvider provider) {
    return Center(
      child: Padding(
        padding: AppSpacing.paddingXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.link_off,
              size: 64,
              color: context.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Connections Yet',
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Connect your social media accounts in Postiz',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: provider.isSyncing
                  ? null
                  : () => _handleSync(context, provider),
              icon: const Icon(Icons.sync),
              label: const Text('Sync from Postiz'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionsGrid(
    BuildContext context,
    ConnectionsProvider provider,
  ) {
    // Determine grid columns based on screen width
    final crossAxisCount = context.isLargeScreen
        ? 3
        : context.isMediumScreen
            ? 2
            : 1;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 1.5,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final platform = PlatformConstants.supportedPlatforms[index];
          final isConnected = provider.isPlatformConnected(platform);
          final connection = provider.getConnectionForPlatform(platform);

          return PlatformConnectionCard(
            platform: platform,
            isConnected: isConnected,
            connection: connection,
            onDisconnect: () => _handleDisconnect(
              context,
              provider,
              connection!,
            ),
          );
        },
        childCount: PlatformConstants.supportedPlatforms.length,
      ),
    );
  }

  Future<void> _handleSync(
    BuildContext context,
    ConnectionsProvider provider,
  ) async {
    try {
      await provider.syncFromPostiz();

      if (context.mounted) {
        context.showSnackBar('Successfully synced connections from Postiz');
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          'Failed to sync: ${e.toString()}',
          isError: true,
        );
      }
    }
  }

  Future<void> _handleDisconnect(
    BuildContext context,
    ConnectionsProvider provider,
    SocialMediaConnection connection,
  ) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Platform'),
        content: Text(
          'Are you sure you want to disconnect ${PlatformConstants.getPlatformName(connection.platform)}?\n\n'
          'Note: This only removes the connection from our system. '
          'To fully revoke access, disconnect in Postiz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colorScheme.error,
            ),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await provider.disconnectPlatform(connection.id!);

      if (context.mounted) {
        context.showSnackBar(
          '${PlatformConstants.getPlatformName(connection.platform)} disconnected',
        );
      }
    } catch (e) {
      if (context.mounted) {
        context.showSnackBar(
          'Failed to disconnect: ${e.toString()}',
          isError: true,
        );
      }
    }
  }
}
