import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/platform_constants.dart';
import '../providers/campaign_provider.dart';

/// Step 3: Review & Edit Content
/// Allows users to review and edit AI-generated content for each platform
class Step3ReviewEdit extends StatefulWidget {
  const Step3ReviewEdit({super.key});

  @override
  State<Step3ReviewEdit> createState() => _Step3ReviewEditState();
}

class _Step3ReviewEditState extends State<Step3ReviewEdit> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, TextEditingController> _contentControllers = {};
  final TextEditingController _imagePromptController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final campaign = context.read<CampaignProvider>();
    final platforms = campaign.selectedPlatforms;
    _tabController = TabController(
      length: platforms.length,
      vsync: this,
    );

    // Initialize controllers for each platform
    for (final platform in platforms) {
      final content = campaign.getGeneratedContent(platform);
      _contentControllers[platform] = TextEditingController(text: content);
    }

    // Initialize image prompt controller
    _imagePromptController.text = campaign.generatedImagePrompt ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final controller in _contentControllers.values) {
      controller.dispose();
    }
    _imagePromptController.dispose();
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
                'Step 3: Review & Edit Content',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Review and customize the AI-generated content for each platform.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),

              // Platform tabs
              if (campaign.selectedPlatforms.isNotEmpty) ...[
                _buildPlatformTabs(context, campaign),
                const SizedBox(height: 24),

                // Content editor for selected platform
                _buildPlatformContent(context, campaign),

                const SizedBox(height: 32),
              ],

              // Image prompt section
              if (campaign.generateImage) _buildImagePromptSection(context, campaign),
            ],
          ),
        );
      },
    );
  }

  /// Build platform tabs
  Widget _buildPlatformTabs(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final platforms = campaign.selectedPlatforms;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: platforms.map((platform) {
          final platformIcon = PlatformConstants.getPlatformIcon(platform);
          final platformColor = PlatformConstants.getPlatformColor(platform);

          return Tab(
            child: Row(
              children: [
                Icon(platformIcon, color: platformColor, size: 20),
                const SizedBox(width: 8),
                Text(platform),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Build platform content editor
  Widget _buildPlatformContent(BuildContext context, CampaignProvider campaign) {
    final platforms = campaign.selectedPlatforms;
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: platforms.map((platform) {
          return _buildContentEditor(context, campaign, platform);
        }).toList(),
      ),
    );
  }

  /// Build content editor for a specific platform
  Widget _buildContentEditor(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) {
    final theme = Theme.of(context);
    final controller = _contentControllers[platform]!;
    final characterLimit = PlatformConstants.getCharacterLimit(platform);
    final currentLength = controller.text.length;
    final isOverLimit = currentLength > characterLimit;
    final hasBeenEdited = campaign.hasBeenEdited(platform);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with platform info
            Row(
              children: [
                Icon(
                  PlatformConstants.getPlatformIcon(platform),
                  color: PlatformConstants.getPlatformColor(platform),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$platform Content',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasBeenEdited)
                  Chip(
                    label: const Text('Edited'),
                    avatar: const Icon(Icons.edit, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Content editor
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Edit your content here...',
                  errorText: isOverLimit
                      ? 'Content exceeds $platform character limit'
                      : null,
                ),
                onChanged: (value) {
                  campaign.updateContent(platform, value);
                  setState(() {}); // Update character counter
                },
              ),
            ),

            const SizedBox(height: 16),

            // Character counter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Action buttons
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: campaign.isRegenerating
                          ? null
                          : () => _regenerateContent(context, campaign, platform),
                      icon: campaign.isRegenerating
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh),
                      label: const Text('Regenerate'),
                    ),
                    const SizedBox(width: 8),
                    if (hasBeenEdited)
                      OutlinedButton.icon(
                        onPressed: () => _revertToOriginal(context, campaign, platform),
                        icon: const Icon(Icons.undo),
                        label: const Text('Revert to AI'),
                      ),
                  ],
                ),

                // Character counter
                Text(
                  '$currentLength / $characterLimit',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isOverLimit
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isOverLimit ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),

            // Warning if over limit
            if (isOverLimit) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your content exceeds the character limit for $platform. Please shorten it before publishing.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Show both versions if edited
            if (hasBeenEdited) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('View AI Original'),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      campaign.getOriginalContent(platform) ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Build image prompt section
  Widget _buildImagePromptSection(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final hasBeenEdited = campaign.imagePromptEdited;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.image, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Marketing Image Prompt',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (hasBeenEdited)
                  Chip(
                    label: const Text('Edited'),
                    avatar: const Icon(Icons.edit, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This prompt can be used with AI image generation tools like DALL-E, Midjourney, or Stable Diffusion.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),

            // Image prompt editor
            TextField(
              controller: _imagePromptController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'AI-generated image prompt...',
              ),
              onChanged: (value) {
                campaign.updateImagePrompt(value);
              },
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: campaign.isRegenerating
                      ? null
                      : () => _regenerateImagePrompt(context, campaign),
                  icon: campaign.isRegenerating
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                ),
                const SizedBox(width: 8),
                if (hasBeenEdited)
                  OutlinedButton.icon(
                    onPressed: () => _revertImagePromptToOriginal(context, campaign),
                    icon: const Icon(Icons.undo),
                    label: const Text('Revert to AI'),
                  ),
              ],
            ),

            // Show original if edited
            if (hasBeenEdited) ...[
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('View AI Original'),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      campaign.originalImagePrompt ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Placeholder for future image upload
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.dividerColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cloud_upload,
                    size: 48,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Generated Image (Coming Soon)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Use the prompt above to generate an image, then upload it here',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Regenerate content for a specific platform
  Future<void> _regenerateContent(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) async {
    try {
      await campaign.regeneratePlatform(platform);
      // Update controller with new content
      _contentControllers[platform]!.text = campaign.getGeneratedContent(platform) ?? '';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$platform content regenerated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to regenerate: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Revert to original AI-generated content
  void _revertToOriginal(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) {
    campaign.revertToOriginal(platform);
    _contentControllers[platform]!.text = campaign.getGeneratedContent(platform) ?? '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$platform content reverted to AI original'),
      ),
    );
  }

  /// Regenerate image prompt
  Future<void> _regenerateImagePrompt(
    BuildContext context,
    CampaignProvider campaign,
  ) async {
    try {
      await campaign.regenerateImagePrompt();
      // Update controller with new prompt
      _imagePromptController.text = campaign.generatedImagePrompt ?? '';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image prompt regenerated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to regenerate: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Revert image prompt to original
  void _revertImagePromptToOriginal(
    BuildContext context,
    CampaignProvider campaign,
  ) {
    campaign.revertImagePromptToOriginal();
    _imagePromptController.text = campaign.generatedImagePrompt ?? '';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image prompt reverted to AI original'),
      ),
    );
  }
}
