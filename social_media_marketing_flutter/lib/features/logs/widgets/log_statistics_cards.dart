import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../providers/ai_logs_provider.dart';

/// Statistics cards displaying AI usage metrics
class LogStatisticsCards extends StatelessWidget {
  const LogStatisticsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AILogsProvider>(
      builder: (context, provider, child) {
        final stats = provider.statistics;

        if (provider.isLoading && stats == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final totalInteractions = stats?['totalInteractions'] as int? ?? 0;
        final totalCost = stats?['totalCost'] as double? ?? 0.0;
        final averageCost = stats?['averageCost'] as double? ?? 0.0;
        final successRate = stats?['successRate'] as double? ?? 0.0;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _StatCard(
              icon: Icons.view_list,
              title: 'Total Logs',
              value: totalInteractions.toString(),
              color: Colors.blue,
            ),
            _StatCard(
              icon: Icons.attach_money,
              title: 'Total Cost',
              value: _formatCost(totalCost),
              color: Colors.green,
            ),
            _StatCard(
              icon: Icons.trending_up,
              title: 'Avg Cost',
              value: _formatCost(averageCost),
              color: Colors.orange,
            ),
            _StatCard(
              icon: Icons.check_circle,
              title: 'Success Rate',
              value: '${(successRate * 100).toStringAsFixed(1)}%',
              color: successRate >= 0.95 ? Colors.green : Colors.orange,
            ),
          ],
        );
      },
    );
  }

  String _formatCost(double cost) {
    return '\$${cost.toStringAsFixed(4)}';
  }
}

/// Individual statistic card widget
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
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
}
