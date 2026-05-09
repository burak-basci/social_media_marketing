import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../../../core/constants/app_spacing.dart';
import '../providers/calendar_provider.dart';
import '../widgets/calendar_view.dart';
import '../widgets/day_posts_list.dart';

/// Calendar screen showing posts in a calendar view.
///
/// Features:
/// - Calendar with event markers
/// - Posts list for selected date
/// - Month navigation
/// - Today button
/// - Loading states
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 2,
      child: ChangeNotifierProvider(
        create: (_) => CalendarProvider(),
        child: const _CalendarScreenContent(),
      ),
    );
  }
}

class _CalendarScreenContent extends StatelessWidget {
  const _CalendarScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<CalendarProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: AppSpacing.paddingLG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 32,
                    color: theme.colorScheme.primary,
                  ),
                  const Gap.md(),
                  Text(
                    'Calendar',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Refresh button
                  IconButton(
                    onPressed: provider.isLoading ? null : provider.refreshPosts,
                    icon: provider.isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
              const Gap.xs(),
              Text(
                'View and manage your scheduled posts',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Error message
        if (provider.hasError)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: AppSpacing.paddingMD,
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: theme.colorScheme.error,
                    ),
                    const Gap.md(),
                    Expanded(
                      child: Text(
                        provider.error ?? 'An error occurred',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: theme.colorScheme.error,
                      ),
                      onPressed: provider.clearError,
                    ),
                  ],
                ),
              ),
            ),
          ),

        if (provider.hasError) const Gap.md(),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Responsive layout: side-by-side on wide screens, stacked on narrow
                final isWideScreen = constraints.maxWidth > 1200;

                if (isWideScreen) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Calendar (left side)
                      Flexible(
                        flex: 3,
                        child: CalendarView(),
                      ),

                      const Gap.lg(),

                      // Posts list (right side)
                      Flexible(
                        flex: 2,
                        child: DayPostsList(),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      // Calendar (top)
                      const CalendarView(),

                      const Gap.lg(),

                      // Posts list (bottom)
                      const Expanded(
                        child: DayPostsList(),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),

        const Gap.lg(),
      ],
    );
  }
}
