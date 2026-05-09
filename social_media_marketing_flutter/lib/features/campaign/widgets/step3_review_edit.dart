import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/platform_constants.dart';
import '../providers/campaign_provider.dart';

/// Step 3: Review & Edit Content
/// Desktop: form on the left, live Vorschau on the right.
/// Mobile: edit form only (Vorschau is a separate tab – no duplicate at bottom).
class Step3ReviewEdit extends StatefulWidget {
  const Step3ReviewEdit({super.key});

  @override
  State<Step3ReviewEdit> createState() => _Step3ReviewEditState();
}

class _Step3ReviewEditState extends State<Step3ReviewEdit>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, TextEditingController> _headlineControllers = {};
  final Map<String, TextEditingController> _contentControllers = {};
  final TextEditingController _imagePromptController = TextEditingController();
  int _previewTabIndex = 0;

  @override
  void initState() {
    super.initState();
    final campaign = context.read<CampaignProvider>();
    final platforms = campaign.selectedPlatforms;
    _tabController = TabController(length: platforms.length, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() => _previewTabIndex = _tabController.index);
        }
      });

    for (final platform in platforms) {
      final content = campaign.getGeneratedContent(platform);
      _contentControllers[platform] =
          TextEditingController(text: content ?? '');
      // Headline is stored as first line of content if available
      final firstLine = (content ?? '').split('\n').first;
      _headlineControllers[platform] = TextEditingController(
        text: firstLine.length <= 100 ? firstLine : '',
      );
    }
    _imagePromptController.text = campaign.generatedImagePrompt ?? '';
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (final c in _contentControllers.values) {
      c.dispose();
    }
    for (final c in _headlineControllers.values) {
      c.dispose();
    }
    _imagePromptController.dispose();
    super.dispose();
  }

  // ─── Layout ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignProvider>(
      builder: (context, campaign, _) {
        final isDesktop = MediaQuery.of(context).size.width >= 900;

        if (isDesktop) {
          return _buildDesktopLayout(context, campaign);
        } else {
          return _buildMobileLayout(context, campaign);
        }
      },
    );
  }

  /// Desktop: [Form 60%] | [Vorschau 40%]
  Widget _buildDesktopLayout(
      BuildContext context, CampaignProvider campaign) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Form pane
        Expanded(
          flex: 6,
          child: _buildFormPane(context, campaign),
        ),
        const SizedBox(width: 24),
        // Preview pane – fixed, does NOT scroll with the form
        SizedBox(
          width: 320,
          child: _buildPreviewPane(context, campaign),
        ),
      ],
    );
  }

  /// Mobile: form only (preview is accessible via the Vorschau tab elsewhere)
  Widget _buildMobileLayout(BuildContext context, CampaignProvider campaign) {
    return _buildFormPane(context, campaign);
  }

  // ─── Form pane ─────────────────────────────────────────────────────────────

  Widget _buildFormPane(BuildContext context, CampaignProvider campaign) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 700),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Inhalt überarbeiten',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Überarbeite und passe den KI-generierten Inhalt für jede Plattform an.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),

          // Platform tabs
          if (campaign.selectedPlatforms.isNotEmpty) ...[
            _buildPlatformTabs(context, campaign),
            const SizedBox(height: 16),
            _buildPlatformContent(context, campaign),
          ],

          // Image prompt
          if (campaign.generateImage) ...[
            const SizedBox(height: 24),
            _buildImagePromptSection(context, campaign),
          ],
        ],
      ),
    );
  }

  // ─── Platform tabs ─────────────────────────────────────────────────────────

  Widget _buildPlatformTabs(
      BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: campaign.selectedPlatforms.map((platform) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PlatformConstants.getPlatformIcon(platform),
                  color: PlatformConstants.getPlatformColor(platform),
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(platform),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Platform content editor ───────────────────────────────────────────────

  Widget _buildPlatformContent(
      BuildContext context, CampaignProvider campaign) {
    return SizedBox(
      height: 560,
      child: TabBarView(
        controller: _tabController,
        children: campaign.selectedPlatforms.map((platform) {
          return _buildContentEditor(context, campaign, platform);
        }).toList(),
      ),
    );
  }

  Widget _buildContentEditor(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) {
    final theme = Theme.of(context);
    final contentController = _contentControllers[platform]!;
    final headlineController = _headlineControllers[platform]!;
    final charLimit = PlatformConstants.getCharacterLimit(platform);
    final currentLength = contentController.text.length;
    final isOverLimit = currentLength > charLimit;
    final hasBeenEdited = campaign.hasBeenEdited(platform);

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                Icon(
                  PlatformConstants.getPlatformIcon(platform),
                  color: PlatformConstants.getPlatformColor(platform),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$platform Content',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (hasBeenEdited)
                  Chip(
                    label: const Text('Bearbeitet'),
                    avatar: const Icon(Icons.edit, size: 14),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 4),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Headline block ─────────────────────────────────────────────
            Text(
              'Überschrift',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: headlineController,
              style: theme.textTheme.titleMedium,
              decoration: InputDecoration(
                hintText: 'Überschrift für $platform …',
                hintStyle: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
              ),
              onChanged: (_) => setState(() {}),
            ),
            // Modifier toolbar for headline
            const SizedBox(height: 4),
            _buildModifierToolbar(
              context: context,
              controller: headlineController,
              isRegenerating: campaign.isRegenerating,
              onRegenerate: null, // headline doesn't have separate regen
              onRevert: null,
              hasBeenEdited: false,
              compact: true,
            ),

            const SizedBox(height: 14),

            // ── Body content ────────────────────────────────────────────────
            Text(
              'Text',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Inhalt hier bearbeiten …',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorText: isOverLimit
                      ? 'Zeichenlimit überschritten'
                      : null,
                  contentPadding: const EdgeInsets.all(12),
                ),
                onChanged: (v) {
                  campaign.updateContent(platform, v);
                  setState(() {});
                },
              ),
            ),

            // ── Modifier toolbar for body text ──────────────────────────────
            const SizedBox(height: 6),
            _buildModifierToolbar(
              context: context,
              controller: contentController,
              isRegenerating: campaign.isRegenerating,
              onRegenerate: () =>
                  _regenerateContent(context, campaign, platform),
              onRevert: hasBeenEdited
                  ? () => _revertToOriginal(context, campaign, platform)
                  : null,
              hasBeenEdited: hasBeenEdited,
              charCount: currentLength,
              charLimit: charLimit,
              isOverLimit: isOverLimit,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Compact modifier toolbar ──────────────────────────────────────────────

  Widget _buildModifierToolbar({
    required BuildContext context,
    required TextEditingController controller,
    required bool isRegenerating,
    required VoidCallback? onRegenerate,
    required VoidCallback? onRevert,
    required bool hasBeenEdited,
    bool compact = false,
    int? charCount,
    int? charLimit,
    bool isOverLimit = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text insert modifiers (compact icon buttons)
        _ModifierButton(
          icon: Icons.tag,
          tooltip: 'Hashtag einfügen',
          onTap: () => _insertText(controller, '#'),
        ),
        _ModifierButton(
          icon: Icons.alternate_email,
          tooltip: 'Erwähnung einfügen',
          onTap: () => _insertText(controller, '@'),
        ),
        _ModifierButton(
          icon: Icons.emoji_emotions_outlined,
          tooltip: 'Emoji einfügen',
          onTap: () => _showEmojiPicker(context, controller),
        ),
        if (!compact) ...[
          _ModifierButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Aufzählung',
            onTap: () => _insertText(controller, '\n• '),
          ),
          _ModifierButton(
            icon: Icons.link,
            tooltip: 'Link einfügen',
            onTap: () => _insertText(controller, ' https://'),
          ),
        ],

        // Spacer to push action buttons right
        const Spacer(),

        // Regenerate
        if (onRegenerate != null)
          _ModifierButton(
            icon: isRegenerating ? Icons.hourglass_empty : Icons.refresh,
            tooltip: 'Neu generieren',
            onTap: isRegenerating ? null : onRegenerate,
            color: theme.colorScheme.primary,
          ),

        // Revert
        if (onRevert != null)
          _ModifierButton(
            icon: Icons.undo,
            tooltip: 'Auf KI-Version zurücksetzen',
            onTap: onRevert,
          ),

        // Character counter
        if (charCount != null && charLimit != null) ...[
          const SizedBox(width: 8),
          Text(
            '$charCount / $charLimit',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isOverLimit
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight:
                  isOverLimit ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  // ─── Image prompt section ──────────────────────────────────────────────────

  Widget _buildImagePromptSection(
      BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final hasBeenEdited = campaign.imagePromptEdited;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.image, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text('Bild-Prompt', style: theme.textTheme.titleMedium),
                ),
                if (hasBeenEdited)
                  Chip(
                    label: const Text('Bearbeitet'),
                    avatar: const Icon(Icons.edit, size: 14),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    labelPadding:
                        const EdgeInsets.symmetric(horizontal: 4),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Dieser Prompt kann für KI-Bildgeneratoren (DALL·E, Midjourney …) verwendet werden.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imagePromptController,
              maxLines: 4,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'KI-generierter Bild-Prompt …',
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              onChanged: campaign.updateImagePrompt,
            ),
            const SizedBox(height: 6),
            // Modifier toolbar for image prompt
            _buildModifierToolbar(
              context: context,
              controller: _imagePromptController,
              isRegenerating: campaign.isRegenerating,
              onRegenerate: () =>
                  _regenerateImagePrompt(context, campaign),
              onRevert: hasBeenEdited
                  ? () => _revertImagePromptToOriginal(context, campaign)
                  : null,
              hasBeenEdited: hasBeenEdited,
            ),
          ],
        ),
      ),
    );
  }

  // ─── Vorschau (Preview) pane ───────────────────────────────────────────────

  Widget _buildPreviewPane(BuildContext context, CampaignProvider campaign) {
    final theme = Theme.of(context);
    final platforms = campaign.selectedPlatforms;
    if (platforms.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentPlatform =
        _previewTabIndex < platforms.length ? platforms[_previewTabIndex] : '';
    final content = _contentControllers[currentPlatform]?.text ?? '';
    final headline = _headlineControllers[currentPlatform]?.text ?? '';

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vorschau header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility_outlined,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Vorschau',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const Spacer(),
                if (platforms.isNotEmpty)
                  Text(
                    currentPlatform,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),

          // Mock post card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildPostMockup(
                  context, currentPlatform, headline, content),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostMockup(
    BuildContext context,
    String platform,
    String headline,
    String content,
  ) {
    final theme = Theme.of(context);
    final platformColor = PlatformConstants.getPlatformColor(platform);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Platform bar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: platformColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(PlatformConstants.getPlatformIcon(platform),
                    color: platformColor, size: 18),
                const SizedBox(width: 8),
                Text(
                  platform,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: platformColor,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fake avatar row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          platformColor.withValues(alpha: 0.2),
                      child: Icon(Icons.business,
                          size: 18, color: platformColor),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ihr Unternehmen',
                            style: theme.textTheme.labelMedium),
                        Text('Gerade eben',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                  ],
                ),
                if (headline.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    headline,
                    style: theme.textTheme.titleSmall,
                  ),
                ],
                if (content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    content.length > 280
                        ? '${content.substring(0, 280)}…'
                        : content,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                if (content.isEmpty && headline.isEmpty)
                  Text(
                    'Kein Inhalt verfügbar.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                const SizedBox(height: 12),
                // Image placeholder
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: theme.colorScheme.outlineVariant,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  void _insertText(TextEditingController controller, String text) {
    final selection = controller.selection;
    final currentText = controller.text;
    if (selection.isValid && selection.start >= 0) {
      final newText = currentText.replaceRange(
          selection.start, selection.end, text);
      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: selection.start + text.length),
      );
    } else {
      controller.text = currentText + text;
      controller.selection = TextSelection.collapsed(
          offset: controller.text.length);
    }
    setState(() {});
  }

  void _showEmojiPicker(
      BuildContext context, TextEditingController controller) {
    // Simple emoji quick-insert sheet
    const emojis = [
      '🚀', '💡', '✨', '🎯', '💼', '📈', '🙌', '👏', '❤️', '🔥',
      '⭐', '💪', '🎉', '👍', '😊', '🌟', '💰', '🛍️', '📱', '🌐',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Emoji einfügen',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: emojis.map((e) {
                return InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    Navigator.of(context).pop();
                    _insertText(controller, e);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child:
                        Text(e, style: const TextStyle(fontSize: 22)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ─── Content regeneration ──────────────────────────────────────────────────

  Future<void> _regenerateContent(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) async {
    try {
      await campaign.regeneratePlatform(platform);
      _contentControllers[platform]!.text =
          campaign.getGeneratedContent(platform) ?? '';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$platform Inhalt neu generiert'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _revertToOriginal(
    BuildContext context,
    CampaignProvider campaign,
    String platform,
  ) {
    campaign.revertToOriginal(platform);
    _contentControllers[platform]!.text =
        campaign.getGeneratedContent(platform) ?? '';
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$platform auf KI-Original zurückgesetzt')),
    );
  }

  Future<void> _regenerateImagePrompt(
    BuildContext context,
    CampaignProvider campaign,
  ) async {
    try {
      await campaign.regenerateImagePrompt();
      _imagePromptController.text = campaign.generatedImagePrompt ?? '';
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bild-Prompt neu generiert'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  void _revertImagePromptToOriginal(
    BuildContext context,
    CampaignProvider campaign,
  ) {
    campaign.revertImagePromptToOriginal();
    _imagePromptController.text = campaign.generatedImagePrompt ?? '';
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bild-Prompt zurückgesetzt')),
    );
  }
}

// ─── Reusable compact modifier button ─────────────────────────────────────────

class _ModifierButton extends StatelessWidget {
  const _ModifierButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ??
        theme.colorScheme.onSurface.withValues(alpha: onTap != null ? 0.7 : 0.3);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          child: Icon(icon, size: 17, color: effectiveColor),
        ),
      ),
    );
  }
}
