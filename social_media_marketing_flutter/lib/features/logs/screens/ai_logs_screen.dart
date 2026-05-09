import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/layouts/main_layout.dart';
import '../providers/ai_logs_provider.dart';
import '../widgets/log_statistics_cards.dart';
import '../widgets/log_filters.dart';
import '../widgets/log_data_table.dart';

/// AI Logs screen showing AI interaction history and analytics
class AILogsScreen extends StatelessWidget {
  const AILogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AILogsProvider(),
      child: const _AILogsScreenContent(),
    );
  }
}

class _AILogsScreenContent extends StatelessWidget {
  const _AILogsScreenContent();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 6,
      child: SingleChildScrollView(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Logs',
                      style: context.textTheme.headlineLarge,
                    ),
                    const Gap.xs(),
                    Text(
                      'Track AI interactions, costs, and performance',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                // Refresh button
                Consumer<AILogsProvider>(
                  builder: (context, provider, child) {
                    return IconButton(
                      onPressed: provider.isLoading ? null : provider.refresh,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh',
                    );
                  },
                ),
              ],
            ),
            const Gap.xl(),

            // Statistics cards
            const LogStatisticsCards(),
            const Gap.xl(),

            // Filters
            const LogFilters(),
            const Gap.xl(),

            // Logs table header
            Text(
              'Interaction Logs',
              style: context.textTheme.titleLarge,
            ),
            const Gap.md(),

            // Data table
            const LogDataTable(),
          ],
        ),
      ),
    );
  }
}
