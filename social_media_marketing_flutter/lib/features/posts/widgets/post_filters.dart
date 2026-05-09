import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/platform_constants.dart';
import '../providers/posts_provider.dart';

/// Post filters widget with status, platform, date range, and search.
class PostFilters extends StatefulWidget {
  const PostFilters({super.key});

  @override
  State<PostFilters> createState() => _PostFiltersState();
}

class _PostFiltersState extends State<PostFilters> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<PostsProvider>();
    _searchController.text = provider.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostsProvider>();
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: AppSpacing.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search posts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          provider.setSearchQuery('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              onChanged: (value) => provider.setSearchQuery(value),
            ),
            const Gap.md(),

            // Status filters
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap.xs(),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          _buildStatusChip(context, 'draft', 'Draft'),
                          _buildStatusChip(context, 'scheduled', 'Scheduled'),
                          _buildStatusChip(context, 'published', 'Published'),
                          _buildStatusChip(context, 'failed', 'Failed'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap.md(),

            // Platform filters
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Platforms',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap.xs(),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: PlatformConstants.supportedPlatforms.map((platform) {
                    return _buildPlatformChip(context, platform);
                  }).toList(),
                ),
              ],
            ),
            const Gap.md(),

            // Date range and clear filters
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDateRangePicker(context),
                    icon: const Icon(Icons.date_range, size: 18),
                    label: Text(
                      provider.startDate != null || provider.endDate != null
                          ? '${_formatDate(provider.startDate)} - ${_formatDate(provider.endDate)}'
                          : 'Date Range',
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ),
                if (provider.hasActiveFilters) ...[
                  const Gap.sm(),
                  OutlinedButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      provider.clearFilters();
                    },
                    icon: const Icon(Icons.clear, size: 18),
                    label: Text(
                      'Clear',
                      style: theme.textTheme.labelMedium,
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status, String label) {
    final provider = context.watch<PostsProvider>();
    final isSelected = provider.statusFilter.contains(status);
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => provider.toggleStatusFilter(status),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildPlatformChip(BuildContext context, String platform) {
    final provider = context.watch<PostsProvider>();
    final isSelected = provider.platformFilter.contains(platform);
    final theme = Theme.of(context);
    final platformColor = PlatformConstants.getPlatformColor(platform);

    return FilterChip(
      avatar: Icon(
        PlatformConstants.getPlatformIcon(platform),
        size: 16,
        color: isSelected ? platformColor : theme.colorScheme.onSurfaceVariant,
      ),
      label: Text(PlatformConstants.getPlatformName(platform)),
      selected: isSelected,
      onSelected: (_) => provider.togglePlatformFilter(platform),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      selectedColor: platformColor.withValues(alpha: 0.15),
      checkmarkColor: platformColor,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: isSelected ? platformColor : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final provider = context.read<PostsProvider>();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: provider.startDate != null && provider.endDate != null
          ? DateTimeRange(
              start: provider.startDate!,
              end: provider.endDate!,
            )
          : null,
    );

    if (picked != null) {
      provider.setDateRange(picked.start, picked.end);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.month}/${date.day}/${date.year}';
  }
}
