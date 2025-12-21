import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_routes.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/router.dart';

/// Main layout with navigation rail for authenticated screens
class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
  });

  final Widget child;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Navigation rail
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) => _handleNavigation(context, index),
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: AppSpacing.paddingVerticalMD,
              child: Column(
                children: [
                  Icon(
                    Icons.campaign,
                    size: AppSpacing.iconLG,
                    color: context.colorScheme.primary,
                  ),
                  const Gap.xs(),
                  Text(
                    'SMM',
                    style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: AppSpacing.paddingVerticalMD,
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _handleLogout(context),
                    tooltip: 'Logout',
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.auto_awesome_outlined),
                selectedIcon: Icon(Icons.auto_awesome),
                label: Text('Campaign'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month),
                label: Text('Calendar'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.article_outlined),
                selectedIcon: Icon(Icons.article),
                label: Text('Posts'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.link_outlined),
                selectedIcon: Icon(Icons.link),
                label: Text('Connections'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: Text('Logs'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),

          // Main content
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dashboard);
      case 1:
        context.go(AppRoutes.campaign);
      case 2:
        context.go(AppRoutes.calendar);
      case 3:
        context.go(AppRoutes.posts);
      case 4:
        context.go(AppRoutes.connections);
      case 5:
        context.go(AppRoutes.settings);
      case 6:
        context.go(AppRoutes.logs);
    }
  }

  void _handleLogout(BuildContext context) {
    AppRouter.logout();
    context.go(AppRoutes.login);
  }
}
