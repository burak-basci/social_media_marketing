import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/platform_constants.dart';
import '../providers/campaign_provider.dart';

/// Step 2: AI Content Generation
/// Allows users to enter a prompt and select platforms for AI content generation
class Step2AIGeneration extends StatefulWidget {
  const Step2AIGeneration({super.key});

  @override
  State<Step2AIGeneration> createState() => _Step2AIGenerationState();
}

class _Step2AIGenerationState extends State<Step2AIGeneration> {
  final _promptController = TextEditingController();
  final int _maxCharacters = 500;

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignProvider>(
      builder: (context, campaign, child) {
        // Update controller if campaign prompt changes
        if (_promptController.text != campaign.prompt) {
          _promptController.text = campaign.prompt;
        }

        // Check if currently generating
        final isGenerating = campaign.isGenerating;

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Step 2: AI Content Generation',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Describe your campaign message and select platforms for AI-powered content generation.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),

              if (isGenerating)
                _buildProgressView(context, campaign)
              else ...[
                // Campaign Message Input
                _buildPromptSection(context, campaign),

                const SizedBox(height: 32),

                // Platform Selection
                _buildPlatformSelection(context, campaign),

                const SizedBox(height: 32),

                // Image Generation Toggle
                _buildImageToggle(context, campaign),

                const SizedBox(height: 32),

                // Estimated Time
                _buildEstimatedTime(context, campaign),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Build campaign prompt section
  Widget _buildPromptSection(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final characterCount = _promptController.text.length;
    final isOverLimit = characterCount > _maxCharacters;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campaign Message',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Multi-line text input
            TextField(
              controller: _promptController,
              maxLines: 6,
              maxLength: _maxCharacters,
              decoration: InputDecoration(
                hintText:
                    'Example: "Launch announcement for our new AI-powered analytics platform that helps businesses make data-driven decisions faster. Highlight ease of use and 50% time savings."',
                border: const OutlineInputBorder(),
                counterText: '', // Hide default counter
              ),
              onChanged: (value) {
                campaign.updateCampaignPrompt(value);
                setState(() {}); // Update character counter
              },
            ),

            const SizedBox(height: 8),

            // Character counter
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$characterCount / $_maxCharacters',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverLimit ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build platform selection grid
  Widget _buildPlatformSelection(
    BuildContext context,
    CampaignProvider campaign,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Platforms',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Platform checkboxes
            ...PlatformConstants.supportedPlatforms.map((platformName) {
              final isConnected = campaign.isPlatformConnected(platformName);
              final isSelected = campaign.selectedPlatforms.contains(platformName);

              return _buildPlatformCheckbox(
                context,
                platformName,
                isConnected,
                isSelected,
                null, // accountName - not implemented yet
                () {
                  if (isConnected) {
                    campaign.togglePlatform(platformName);
                  } else {
                    _showConnectPlatformDialog(context, platformName);
                  }
                },
                () => _navigateToConnectPlatform(context, platformName),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Build individual platform checkbox
  Widget _buildPlatformCheckbox(
    BuildContext context,
    String platformName,
    bool isConnected,
    bool isSelected,
    String? accountName,
    VoidCallback onToggle,
    VoidCallback onConnect,
  ) {
    final theme = Theme.of(context);
    final platformColor = PlatformConstants.getPlatformColor(platformName);
    final platformIcon = PlatformConstants.getPlatformIcon(platformName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: isSelected,
            onChanged: isConnected ? (value) => onToggle() : null,
          ),

          // Platform icon
          Icon(
            platformIcon,
            color: isConnected ? platformColor : theme.colorScheme.outline,
            size: 24,
          ),
          const SizedBox(width: 12),

          // Platform name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platformName,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isConnected ? null : theme.colorScheme.outline,
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

          // Connection status
          if (isConnected)
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
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
                Icon(
                  Icons.cancel,
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onConnect,
                  child: const Text('Connect'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Build image generation toggle
  Widget _buildImageToggle(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Checkbox(
              value: campaign.generateImage,
              onChanged: (value) {
                campaign.setGenerateImage(value ?? false);
              },
            ),
            const SizedBox(width: 12),
            Icon(Icons.image, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generate marketing image prompt',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI will create a detailed prompt for generating a marketing image',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build estimated time section
  Widget _buildEstimatedTime(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final platformCount = campaign.selectedPlatforms.length;
    final imageCount = campaign.generateImage ? 1 : 0;
    final totalTasks = platformCount + imageCount;

    // Estimate ~10 seconds per platform + ~5 seconds for image prompt
    final estimatedSeconds = (platformCount * 10) + (imageCount * 5);

    if (totalTasks == 0) return const SizedBox.shrink();

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              Icons.schedule,
              color: theme.colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Text(
              'Estimated generation time: ~$estimatedSeconds seconds',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build progress view during generation
  Widget _buildProgressView(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final generationProgress = campaign.platformStatus;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Generating Content with AI...',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Platform status list
            ...generationProgress.entries.map((entry) {
              final platformName = entry.key;
              final statusObj = entry.value;
              return _buildPlatformStatus(context, platformName, statusObj);
            }).toList(),

            const SizedBox(height: 24),

            // Overall progress indicator
            const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }

  /// Build platform generation status
  Widget _buildPlatformStatus(
    BuildContext context,
    String platformName,
    PlatformGenerationStatus statusObj,
  ) {
    final theme = Theme.of(context);
    final platformColor = PlatformConstants.getPlatformColor(platformName);
    final platformIconData = PlatformConstants.getPlatformIcon(platformName);

    final status = statusObj.status;

    IconData statusIcon;
    Color statusColor;
    String statusText;

    switch (status) {
      case 'pending':
        statusIcon = Icons.pending;
        statusColor = theme.colorScheme.outline;
        statusText = 'pending...';
        break;
      case 'generating':
        statusIcon = Icons.sync;
        statusColor = theme.colorScheme.primary;
        statusText = 'generating...';
        break;
      case 'completed':
        statusIcon = Icons.check_circle;
        statusColor = Colors.green;
        statusText = 'completed';
        break;
      case 'error':
        statusIcon = Icons.error;
        statusColor = theme.colorScheme.error;
        final errorMsg = statusObj.error ?? 'unknown';
        statusText = 'error: $errorMsg';
        break;
      default:
        statusIcon = Icons.help;
        statusColor = theme.colorScheme.outline;
        statusText = status;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(platformIconData, color: platformColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              platformName,
              style: theme.textTheme.bodyLarge,
            ),
          ),
          if (status == 'generating')
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Show connect platform dialog
  void _showConnectPlatformDialog(BuildContext context, String platformName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect $platformName'),
        content: Text(
          'You need to connect your $platformName account before generating content for this platform.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToConnectPlatform(context, platformName);
            },
            child: const Text('Connect Now'),
          ),
        ],
      ),
    );
  }

  /// Navigate to platform connection screen
  void _navigateToConnectPlatform(BuildContext context, String platformName) {
    Navigator.of(context).pushNamed('/connect-platform', arguments: platformName);
  }
}
