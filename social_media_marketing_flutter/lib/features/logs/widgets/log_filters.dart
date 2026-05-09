import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/extensions.dart';
import '../providers/ai_logs_provider.dart';

/// Filter controls for AI logs
class LogFilters extends StatelessWidget {
  const LogFilters({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AILogsProvider>(
      builder: (context, provider, child) {
        return Card(
          child: Padding(
            padding: AppSpacing.paddingMD,
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Interaction type dropdown
                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<String?>(
                    initialValue: provider.selectedInteractionType,
                    decoration: const InputDecoration(
                      labelText: 'Interaction Type',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: null,
                        child: Text('All Types'),
                      ),
                      DropdownMenuItem(
                        value: 'initial_generation',
                        child: Text('Initial Generation'),
                      ),
                      DropdownMenuItem(
                        value: 'edit_request',
                        child: Text('Edit Request'),
                      ),
                      DropdownMenuItem(
                        value: 'image_generation',
                        child: Text('Image Generation'),
                      ),
                    ],
                    onChanged: (value) => provider.setInteractionType(value),
                  ),
                ),

                // Date range picker
                SizedBox(
                  width: 300,
                  child: _DateRangePicker(
                    startDate: provider.startDate,
                    endDate: provider.endDate,
                    onChanged: (start, end) =>
                        provider.setDateRange(start, end),
                  ),
                ),

                // Clear filters button
                if (provider.selectedInteractionType != null ||
                    provider.startDate != null ||
                    provider.endDate != null)
                  OutlinedButton.icon(
                    onPressed: provider.clearFilters,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Filters'),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Date range picker widget
class _DateRangePicker extends StatelessWidget {
  const _DateRangePicker({
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final void Function(DateTime?, DateTime?) onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDateRangePicker(context),
      borderRadius: AppSpacing.borderRadiusMD,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date Range',
          border: OutlineInputBorder(),
          isDense: true,
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          _formatDateRange(),
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }

  String _formatDateRange() {
    if (startDate == null && endDate == null) {
      return 'All Time';
    }

    final formatter = DateFormat.yMMMd();

    if (startDate != null && endDate != null) {
      return '${formatter.format(startDate!)} - ${formatter.format(endDate!)}';
    } else if (startDate != null) {
      return 'From ${formatter.format(startDate!)}';
    } else {
      return 'Until ${formatter.format(endDate!)}';
    }
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: startDate != null && endDate != null
          ? DateTimeRange(start: startDate!, end: endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context),
          child: child!,
        );
      },
    );

    if (result != null) {
      onChanged(result.start, result.end);
    }
  }
}
