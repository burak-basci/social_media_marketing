import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/platform_constants.dart';
import '../providers/campaign_provider.dart';

/// Step 4: Schedule & Publish
/// Allows users to schedule or immediately publish their campaign
class Step4Schedule extends StatefulWidget {
  const Step4Schedule({super.key});

  @override
  State<Step4Schedule> createState() => _Step4ScheduleState();
}

class _Step4ScheduleState extends State<Step4Schedule> with SingleTickerProviderStateMixin {
  late TabController _previewTabController;

  @override
  void initState() {
    super.initState();
    final campaign = context.read<CampaignProvider>();
    final platforms = campaign.selectedPlatforms;
    _previewTabController = TabController(
      length: platforms.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _previewTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignProvider>(
      builder: (context, campaign, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Step 4: Schedule & Publish',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose when to publish your campaign and review the final content.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),

              // Publishing options
              _buildPublishingOptions(context, campaign),

              const SizedBox(height: 32),

              // Platform connections
              _buildPlatformConnections(context, campaign),

              const SizedBox(height: 32),

              // Preview section
              _buildPreviewSection(context, campaign),
            ],
          ),
        );
      },
    );
  }

  /// Build publishing options (Now vs Later)
  Widget _buildPublishingOptions(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Publishing Options',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Publish Now
            RadioListTile<bool>(
              value: true,
              groupValue: campaign.publishNow,
              onChanged: (value) {
                campaign.setPublishNow(value ?? true);
              },
              title: const Text('Publish Now'),
              subtitle: const Text('Post immediately to all selected platforms'),
              contentPadding: EdgeInsets.zero,
            ),

            // Schedule for Later
            RadioListTile<bool>(
              value: false,
              groupValue: campaign.publishNow,
              onChanged: (value) {
                campaign.setPublishNow(value ?? false);
              },
              title: const Text('Schedule for Later'),
              subtitle: const Text('Choose a specific date and time'),
              contentPadding: EdgeInsets.zero,
            ),

            // Date/Time picker (shown when Schedule for Later is selected)
            if (!campaign.publishNow) ...[
              const SizedBox(height: 16),
              _buildScheduleDateTime(context, campaign),
            ],
          ],
        ),
      ),
    );
  }

  /// Build schedule date/time picker
  Widget _buildScheduleDateTime(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final scheduleTime = campaign.scheduleTime;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _selectDate(context, campaign),
                  child: Text(
                    scheduleTime != null
                        ? DateFormat('EEEE, MMMM d, yyyy').format(scheduleTime)
                        : 'Select Date',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Time picker
          Row(
            children: [
              Icon(Icons.access_time, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _selectTime(context, campaign),
                  child: Text(
                    scheduleTime != null
                        ? DateFormat('h:mm a').format(scheduleTime)
                        : 'Select Time',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Show scheduled date/time summary
          if (scheduleTime != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Scheduled for ${DateFormat('EEEE, MMMM d, yyyy').format(scheduleTime)} at ${DateFormat('h:mm a').format(scheduleTime)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build platform connections list
  Widget _buildPlatformConnections(
    BuildContext context,
    CampaignProvider campaign,
  ) {
    final theme = Theme.of(context);
    final platforms = campaign.selectedPlatforms;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected Platforms',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Platform connection list
            ...platforms.map((platform) {
              final isConnected = campaign.platformConnections[platform] ?? false;
              const accountName = 'Connected'; // TODO: Get actual account name from connection

              return _buildPlatformConnectionItem(
                context,
                platform,
                isConnected,
                accountName,
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Build individual platform connection item
  Widget _buildPlatformConnectionItem(
    BuildContext context,
    String platform,
    bool isConnected,
    String? accountName,
  ) {
    final theme = Theme.of(context);
    final platformColor = PlatformConstants.getPlatformColor(platform);
    final platformIcon = PlatformConstants.getPlatformIcon(platform);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(platformIcon, color: platformColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isConnected && accountName != null)
                  Text(
                    accountName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          if (isConnected)
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Connected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Icon(Icons.warning, color: theme.colorScheme.error, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Not Connected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Build preview section
  Widget _buildPreviewSection(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final platforms = campaign.selectedPlatforms;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Post Preview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Platform tabs
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _previewTabController,
                isScrollable: true,
                tabs: platforms.map((platform) {
                  final platformIconData = PlatformConstants.getPlatformIcon(platform);
                  final platformColor = PlatformConstants.getPlatformColor(platform);

                  return Tab(
                    child: Row(
                      children: [
                        Icon(platformIconData, color: platformColor, size: 20),
                        const SizedBox(width: 8),
                        Text(platform),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Preview content
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _previewTabController,
                children: platforms.map((platform) {
                  return _buildPlatformPreview(context, campaign, platform);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build preview for a specific platform
  Widget _buildPlatformPreview(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) {
    final theme = Theme.of(context);
    final content = campaign.getContentForPlatform(platform);
    final characterCount = content?.length ?? 0;
    final characterLimit = PlatformConstants.getCharacterLimit(platform);
    final platformIconData = PlatformConstants.getPlatformIcon(platform);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock platform header
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: PlatformConstants.getPlatformColor(platform),
                  child: Icon(
                    platformIconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.selectedCompany?.name ?? 'Your Company',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Just now',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Post content
            Text(
              content ?? '',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            // Character count indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.text_fields,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  '$characterCount / $characterLimit',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Select date
  Future<void> _selectDate(BuildContext context, CampaignProvider campaign) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: campaign.scheduleTime ?? now.add(const Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      // Preserve existing time if set, otherwise use current time
      final existingTime = campaign.scheduleTime;
      final newDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        existingTime?.hour ?? TimeOfDay.now().hour,
        existingTime?.minute ?? TimeOfDay.now().minute,
      );
      campaign.setScheduleTime(newDateTime);
    }
  }

  /// Select time
  Future<void> _selectTime(BuildContext context, CampaignProvider campaign) async {
    final currentDateTime = campaign.scheduleTime ?? DateTime.now().add(const Duration(hours: 1));
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDateTime),
    );

    if (selectedTime != null) {
      // Preserve existing date if set, otherwise use current date
      final existingDate = campaign.scheduleTime ?? DateTime.now();
      final newDateTime = DateTime(
        existingDate.year,
        existingDate.month,
        existingDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );
      campaign.setScheduleTime(newDateTime);
    }
  }
}
