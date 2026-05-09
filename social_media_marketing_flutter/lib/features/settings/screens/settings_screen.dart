import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../core/constants/app_spacing.dart';
import '../providers/settings_provider.dart';
import '../widgets/user_profile_section.dart';
import '../widgets/organization_section.dart';
import '../widgets/change_password_section.dart';
import '../widgets/danger_zone_section.dart';

/// Settings screen for user profile, organization, and account settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load settings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MainLayout(
      selectedIndex: 5,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: Consumer<SettingsProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                // App bar
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  expandedHeight: 120,
                  backgroundColor: theme.colorScheme.surface,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Settings',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    titlePadding: const EdgeInsets.only(
                      left: AppSpacing.lg,
                      bottom: AppSpacing.md,
                    ),
                    expandedTitleScale: 1.3,
                  ),
                  actions: [
                    // Refresh button
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: provider.isLoading
                          ? null
                          : () => provider.loadSettings(),
                      tooltip: 'Refresh settings',
                    ),
                    const Gap.horizontal(AppSpacing.sm),
                  ],
                ),

                // Error banner
                if (provider.hasError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: AppSpacing.paddingMD,
                      child: Container(
                        padding: AppSpacing.paddingMD,
                        decoration: BoxDecoration(
                          color: Colors.red.withAlpha(25),
                          borderRadius: AppSpacing.borderRadiusMD,
                          border: Border.all(
                            color: Colors.red.withAlpha(128),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const Gap.sm(),
                            Expanded(
                              child: Text(
                                provider.error ?? 'An error occurred',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: provider.clearError,
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // User Profile Section
                      const UserProfileSection(),
                      const Gap.lg(),

                      // Organization Section (admin only)
                      if (provider.isAdmin) ...[
                        const OrganizationSection(),
                        const Gap.lg(),
                      ],

                      // Change Password Section
                      const ChangePasswordSection(),
                      const Gap.lg(),

                      // Danger Zone Section
                      const DangerZoneSection(),
                      const Gap.xl(),

                      // Footer info
                      Center(
                        child: Text(
                          'Social Media Marketing Platform',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Gap.sm(),
                      Center(
                        child: Text(
                          'Version 1.0.0',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const Gap.xl(),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
