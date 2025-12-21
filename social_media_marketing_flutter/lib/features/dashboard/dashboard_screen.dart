import 'package:flutter/material.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/extensions.dart';
import '../../shared/layouts/main_layout.dart';

/// Main dashboard screen showing overview stats
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0,
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Dashboard',
              style: context.textTheme.headlineLarge,
            ),
            const Gap.xs(),
            Text(
              'Welcome back! Here\'s an overview of your social media campaigns.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const Gap.xl(),

            // Stats cards
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _buildStatCard(
                  context,
                  icon: Icons.post_add,
                  title: 'Total Posts',
                  value: '0',
                  color: Colors.blue,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.schedule,
                  title: 'Scheduled',
                  value: '0',
                  color: Colors.orange,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.check_circle,
                  title: 'Published',
                  value: '0',
                  color: Colors.green,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.error,
                  title: 'Failed',
                  value: '0',
                  color: Colors.red,
                ),
              ],
            ),
            const Gap.xl(),

            // Quick actions
            Text(
              'Quick Actions',
              style: context.textTheme.titleLarge,
            ),
            const Gap.md(),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _buildActionCard(
                  context,
                  icon: Icons.auto_awesome,
                  title: 'Create Campaign',
                  description: 'Generate AI-powered content',
                  onTap: () {
                    // TODO: Navigate to campaign creation
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.calendar_month,
                  title: 'View Calendar',
                  description: 'Manage scheduled posts',
                  onTap: () {
                    // TODO: Navigate to calendar
                  },
                ),
                _buildActionCard(
                  context,
                  icon: Icons.link,
                  title: 'Connect Platforms',
                  description: 'Link social media accounts',
                  onTap: () {
                    // TODO: Navigate to connections
                  },
                ),
              ],
            ),
            const Gap.xl(),

            // Recent activity placeholder
            Text(
              'Recent Activity',
              style: context.textTheme.titleLarge,
            ),
            const Gap.md(),
            Card(
              child: Padding(
                padding: AppSpacing.paddingLG,
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const Gap.md(),
                      Text(
                        'No recent activity',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const Gap.xs(),
                      Text(
                        'Create your first campaign to get started',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: AppSpacing.paddingMD,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    child: Icon(icon, color: color, size: AppSpacing.iconMD),
                  ),
                  const Spacer(),
                  Text(
                    value,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap.sm(),
              Text(
                title,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 250,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: AppSpacing.borderRadiusMD,
          child: Padding(
            padding: AppSpacing.paddingMD,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: context.colorScheme.primary,
                  size: AppSpacing.iconLG,
                ),
                const Gap.md(),
                Text(
                  title,
                  style: context.textTheme.titleMedium,
                ),
                const Gap.xs(),
                Text(
                  description,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
