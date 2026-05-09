import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/platform_constants.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_status_chip.dart';
import '../widgets/platform_badges.dart';

/// Dialog showing full post details with edit capabilities.
class PostDetailDialog extends StatefulWidget {
  const PostDetailDialog({super.key, required this.post});
  final Post post;

  @override
  State<PostDetailDialog> createState() => _PostDetailDialogState();
}

class _PostDetailDialogState extends State<PostDetailDialog> {
  late TextEditingController _titleController;
  late Map<String, TextEditingController> _contentControllers;
  DateTime? _scheduleTime;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _scheduleTime = widget.post.scheduleTime;

    final provider = context.read<PostsProvider>();
    final content = provider.getPostContent(widget.post);
    final platforms = provider.getPostPlatforms(widget.post);

    _contentControllers = {};
    for (final platform in platforms) {
      _contentControllers[platform] =
          TextEditingController(text: content[platform] ?? '');
    }

    _titleController.addListener(_onChanged);
    for (final controller in _contentControllers.values) {
      controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _contentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() => _hasChanges = true);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<PostsProvider>();
    final platforms = provider.getPostPlatforms(widget.post);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        constraints: const BoxConstraints(maxWidth: 900),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom:
                      BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Beitragsdetails',
                            style: theme.textTheme.titleLarge),
                        const Gap.xs(),
                        PostStatusChip(status: widget.post.status),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => _handleClose(context),
                  ),
                ],
              ),
            ),

            // ── Content ─────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLG,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title / Headline block
                    _FieldLabel('Überschrift / Titel', context),
                    const Gap.xs(),
                    TextField(
                      controller: _titleController,
                      style: theme.textTheme.titleMedium,
                      decoration: _fieldDecoration(context,
                          hintText: 'Beitragstitel'),
                    ),
                    const SizedBox(height: 4),
                    _ModifierRow(controller: _titleController),
                    const Gap.lg(),

                    // Platforms
                    _FieldLabel('Plattformen', context),
                    const Gap.xs(),
                    PlatformBadges(
                        platforms: platforms, size: 24, spacing: 8),
                    const Gap.lg(),

                    // Schedule
                    _FieldLabel('Zeitplan', context),
                    const Gap.xs(),
                    OutlinedButton.icon(
                      onPressed: _pickScheduleTime,
                      icon: const Icon(Icons.schedule),
                      label: Text(
                        _scheduleTime != null
                            ? _formatDateTime(_scheduleTime!)
                            : 'Zeitplan festlegen',
                      ),
                    ),
                    const Gap.lg(),

                    // Platform content fields
                    _FieldLabel('Inhalt', context),
                    const Gap.md(),

                    ...platforms.map((platform) {
                      final controller = _contentControllers[platform]!;
                      final charLimit =
                          PlatformConstants.getCharacterLimit(platform);
                      final currentLength = controller.text.length;
                      final isOverLimit = currentLength > charLimit;

                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              PlatformBadge(platform: platform, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                PlatformConstants
                                    .getPlatformName(platform),
                                style: theme.textTheme.labelMedium,
                              ),
                            ]),
                            const Gap.xs(),
                            TextField(
                              controller: controller,
                              style: theme.textTheme.bodyMedium,
                              decoration: _fieldDecoration(
                                context,
                                hintText:
                                    'Inhalt für ${PlatformConstants.getPlatformName(platform)}',
                                errorText: isOverLimit
                                    ? 'Zeichenlimit überschritten'
                                    : null,
                              ),
                              maxLines: 6,
                            ),
                            const SizedBox(height: 4),
                            // Compact modifier row + counter
                            Row(children: [
                              _ModifierRow(controller: controller),
                              const Spacer(),
                              Text(
                                '$currentLength / $charLimit',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isOverLimit
                                      ? theme.colorScheme.error
                                      : theme.colorScheme
                                          .onSurfaceVariant,
                                  fontWeight: isOverLimit
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                            ]),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // ── Actions bar ──────────────────────────────────────────────────
            Container(
              padding: AppSpacing.paddingMD,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                    top: BorderSide(
                        color: theme.colorScheme.outlineVariant)),
              ),
              child: Row(
                children: [
                  if (widget.post.status != 'published')
                    OutlinedButton.icon(
                      onPressed: () => _handleDelete(context),
                      icon: const Icon(Icons.delete),
                      label: const Text('Löschen'),
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error),
                    ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => _handleDuplicate(context),
                    icon: const Icon(Icons.content_copy),
                    label: const Text('Duplizieren'),
                  ),
                  const Gap.md(),
                  if (widget.post.status == 'draft' ||
                      widget.post.status == 'scheduled')
                    FilledButton.icon(
                      onPressed: () => _handlePublishNow(context),
                      icon: const Icon(Icons.send),
                      label: const Text('Jetzt veröffentlichen'),
                    ),
                  const Gap.md(),
                  FilledButton.icon(
                    onPressed:
                        _hasChanges ? () => _handleSave(context) : null,
                    icon: provider.isUpdating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save),
                    label: const Text('Speichern'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  InputDecoration _fieldDecoration(BuildContext context,
      {String? hintText, String? errorText}) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hintText,
      errorText: errorText,
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
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }

  Future<void> _pickScheduleTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduleTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(_scheduleTime ?? DateTime.now()),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduleTime = DateTime(
          date.year, date.month, date.day, time.hour, time.minute);
      _hasChanges = true;
    });
  }

  String _formatDateTime(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}  '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Future<void> _handleSave(BuildContext context) async {
    final provider = context.read<PostsProvider>();
    final editedContent = {
      for (final e in _contentControllers.entries) e.key: e.value.text,
    };
    try {
      await provider.updatePost(
        postId: widget.post.id!,
        title: _titleController.text != widget.post.title
            ? _titleController.text
            : null,
        scheduleTime: _scheduleTime != widget.post.scheduleTime
            ? _scheduleTime
            : null,
        editedContent: editedContent,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gespeichert'), backgroundColor: Colors.green));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Löschen?'),
        content: const Text('Kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Abbrechen')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Löschen')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final provider = context.read<PostsProvider>();
    try {
      await provider.deletePost(widget.post.id!);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Gelöscht'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _handleDuplicate(BuildContext context) async {
    final provider = context.read<PostsProvider>();
    try {
      await provider.duplicatePost(widget.post.id!);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Dupliziert'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _handlePublishNow(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Jetzt veröffentlichen?'),
        content: const Text('Sofort auf allen Plattformen veröffentlichen?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Abbrechen')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Veröffentlichen')),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final provider = context.read<PostsProvider>();
    try {
      await provider.publishNow(widget.post.id!);
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Veröffentlicht'), backgroundColor: Colors.green));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red));
    }
  }

  void _handleClose(BuildContext context) {
    if (_hasChanges) {
      showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Ungespeicherte Änderungen'),
          content: const Text('Änderungen verwerfen?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Abbrechen')),
            FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                  Navigator.of(context).pop();
                },
                child: const Text('Verwerfen')),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }
}

// ─── Shared widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, this.context);
  final String text;
  final BuildContext context;

  @override
  Widget build(BuildContext ctx) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            letterSpacing: 0.4,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

/// Compact row of text-modifier icon buttons.
class _ModifierRow extends StatelessWidget {
  const _ModifierRow({required this.controller});
  final TextEditingController controller;

  void _insert(String text) {
    final sel = controller.selection;
    final current = controller.text;
    if (sel.isValid && sel.start >= 0) {
      final updated = current.replaceRange(sel.start, sel.end, text);
      controller.value = TextEditingValue(
        text: updated,
        selection: TextSelection.collapsed(offset: sel.start + text.length),
      );
    } else {
      controller.text = current + text;
      controller.selection =
          TextSelection.collapsed(offset: controller.text.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _IconBtn(Icons.tag, '#hashtag', color, () => _insert('#')),
        _IconBtn(Icons.alternate_email, '@erwähnung', color,
            () => _insert('@')),
        _IconBtn(Icons.emoji_emotions_outlined, 'Emoji', color,
            () => _showEmoji(context)),
        _IconBtn(Icons.link, 'Link', color, () => _insert(' https://')),
        _IconBtn(Icons.format_list_bulleted, 'Aufzählung', color,
            () => _insert('\n• ')),
      ],
    );
  }

  void _showEmoji(BuildContext context) {
    const emojis = [
      '🚀', '💡', '✨', '🎯', '💼', '📈', '🙌', '👏', '❤️', '🔥',
      '⭐', '💪', '🎉', '👍', '😊', '🌟', '💰', '🛍️', '📱', '🌐',
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
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
                    _insert(e);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(e, style: const TextStyle(fontSize: 22)),
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
}

class _IconBtn extends StatelessWidget {
  const _IconBtn(this.icon, this.tooltip, this.color, this.onTap);
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
