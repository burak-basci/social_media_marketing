import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../providers/ai_logs_provider.dart';

/// Data table displaying AI logs
class LogDataTable extends StatelessWidget {
  const LogDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AILogsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.logs.isEmpty) {
          return const Center(
            child: Padding(
              padding: AppSpacing.paddingXL,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (provider.hasError) {
          return Center(
            child: Padding(
              padding: AppSpacing.paddingXL,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: context.colorScheme.error,
                  ),
                  const Gap.md(),
                  Text(
                    provider.error ?? 'An error occurred',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Gap.md(),
                  ElevatedButton(
                    onPressed: provider.refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (provider.logs.isEmpty) {
          return Center(
            child: Padding(
              padding: AppSpacing.paddingXL,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: context.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const Gap.md(),
                  Text(
                    'No logs found',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Gap.xs(),
                  Text(
                    'Create a campaign to generate AI logs',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // Table
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: context.screenWidth - AppSpacing.lg * 2,
                  ),
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Timestamp')),
                      DataColumn(label: Text('Type')),
                      DataColumn(label: Text('Model')),
                      DataColumn(label: Text('Prompt')),
                      DataColumn(label: Text('Tokens')),
                      DataColumn(label: Text('Cost')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: provider.logs
                        .map((log) => _buildDataRow(context, log))
                        .toList(),
                  ),
                ),
              ),
            ),

            // Load more button
            if (provider.hasMore)
              Padding(
                padding: AppSpacing.paddingMD,
                child: provider.isLoadingMore
                    ? const CircularProgressIndicator()
                    : OutlinedButton(
                        onPressed: provider.loadMore,
                        child: const Text('Load More'),
                      ),
              ),
          ],
        );
      },
    );
  }

  DataRow _buildDataRow(BuildContext context, AIInteractionLog log) {
    return DataRow(
      cells: [
        // Timestamp
        DataCell(
          Text(
            DateFormat('MMM dd, HH:mm').format(log.createdAt),
            style: context.textTheme.bodySmall,
          ),
        ),

        // Type
        DataCell(
          _TypeChip(type: log.interactionType),
        ),

        // Model
        DataCell(
          Text(
            _getModelDisplayName(log.model),
            style: context.textTheme.bodySmall,
          ),
        ),

        // Prompt (truncated, click to expand)
        DataCell(
          _PromptCell(prompt: log.prompt),
        ),

        // Tokens
        DataCell(
          Text(
            log.tokensUsed?.toString() ?? 'N/A',
            style: context.textTheme.bodySmall,
          ),
        ),

        // Cost
        DataCell(
          Text(
            _formatCost(log.estimatedCostUsd),
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Status
        DataCell(
          _StatusChip(success: log.success),
        ),
      ],
    );
  }

  String _getModelDisplayName(String model) {
    // Simplify model names for display
    if (model.contains('gemini')) {
      return 'Gemini';
    } else if (model.contains('gpt')) {
      return 'GPT';
    }
    return model;
  }

  String _formatCost(double? cost) {
    if (cost == null) return 'N/A';
    return '\$${cost.toStringAsFixed(4)}';
  }
}

/// Chip displaying interaction type with color coding
class _TypeChip extends StatelessWidget {
  const _TypeChip({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppSpacing.borderRadiusSM,
      ),
      child: Text(
        _getTypeDisplayName(),
        style: context.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case 'initial_generation':
        return Colors.blue;
      case 'edit_request':
        return Colors.orange;
      case 'image_generation':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getTypeDisplayName() {
    switch (type) {
      case 'initial_generation':
        return 'Initial';
      case 'edit_request':
        return 'Edit';
      case 'image_generation':
        return 'Image';
      default:
        return type;
    }
  }
}

/// Chip displaying success status
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.success});

  final bool success;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          success ? Icons.check_circle : Icons.error,
          size: 16,
          color: success ? Colors.green : Colors.red,
        ),
        const Gap.xs(),
        Text(
          success ? 'Success' : 'Failed',
          style: context.textTheme.bodySmall?.copyWith(
            color: success ? Colors.green : Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// Prompt cell with truncation and expand dialog
class _PromptCell extends StatelessWidget {
  const _PromptCell({required this.prompt});

  final String prompt;

  @override
  Widget build(BuildContext context) {
    final truncated = prompt.length > 50
        ? '${prompt.substring(0, 50)}...'
        : prompt;

    return InkWell(
      onTap: prompt.length > 50
          ? () => _showFullPrompt(context)
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              truncated,
              style: context.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (prompt.length > 50) ...[
            const Gap.xs(),
            Icon(
              Icons.open_in_new,
              size: 14,
              color: context.colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }

  void _showFullPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Full Prompt'),
        content: SingleChildScrollView(
          child: SelectableText(prompt),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
