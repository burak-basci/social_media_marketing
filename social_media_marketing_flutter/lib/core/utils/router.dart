import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/campaign/screens/campaign_wizard_screen.dart';
import '../../features/calendar/screens/calendar_screen.dart';
import '../../features/connections/screens/connections_screen.dart';
import '../../features/logs/screens/ai_logs_screen.dart';
import '../../features/posts/screens/posts_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../shared/layouts/main_layout.dart';
import '../../services/auth_service.dart';

/// Application router configuration
class AppRouter {
  static GoRouter get router => _router;

  // Simple in-memory auth state (replace with proper state management later)
  static bool _isAuthenticated = false;

  static void login() => _isAuthenticated = true;

  static Future<void> logout() async {
    _isAuthenticated = false;
    await AuthService.clearSession();
  }

  static bool get isAuthenticated => _isAuthenticated;

  static final _router = GoRouter(
    initialLocation: AppRoutes.login,
    redirect: (context, state) async {
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      // Check authentication status from AuthService
      final isAuthenticated = await AuthService.isAuthenticated();

      // If not authenticated and trying to access protected route, redirect to login
      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      // If authenticated and trying to access auth routes, redirect to dashboard
      if (isAuthenticated && isAuthRoute) {
        // Update router state
        _isAuthenticated = true;
        return AppRoutes.dashboard;
      }

      // Sync router state
      _isAuthenticated = isAuthenticated;

      // No redirect needed
      return null;
    },
    routes: [
      // Authentication routes (no transition animations)
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),

      // Main app routes (no transition animations)
      GoRoute(
        path: AppRoutes.dashboard,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.campaign,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CampaignWizardScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CalendarScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.posts,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const PostsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.connections,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const ConnectionsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.logs,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const AILogsScreen(),
        ),
      ),
    ],
  );
}

/// Placeholder screen for routes that haven't been implemented yet
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.title,
    required this.selectedIndex,
  });

  final String title;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: selectedIndex,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This page is under construction',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
