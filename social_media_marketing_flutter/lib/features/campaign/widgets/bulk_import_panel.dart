import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/campaign_provider.dart';

/// Fixed Bulk Import panel shown on Desktop alongside the campaign wizard form.
/// It does NOT scroll with the form — it is independently scrollable.
///
/// Allows users to paste or type multiple post drafts (one per line or separated
/// by blank lines), preview them as a list, select one, and inject it into the
/// campaign prompt field.
class BulkImportPanel extends StatefulWidget {
  const BulkImportPanel({super.key});

  @override
  State<BulkImportPanel> createState() => _BulkImportPanelState();
}

class _BulkImportPanelState extends State<BulkImportPanel> {
  final TextEditingController _pasteController = TextEditingController();
  List<_ImportedItem> _items = [];
  int? _selectedIndex;
  bool _showInput = true;

  @override
  void dispose() {
    _pasteController.dispose();
    super.dispose();
  }

  /// Parse the pasted text into individual items.
  /// Items are separated by blank lines OR by newlines (one per line).
  void _parseInput() {
    final raw = _pasteController.text.trim();
    if (raw.isEmpty) return;

    final blocks = raw.split(RegExp(r'\n\s*\n'));
    final parsed = blocks
        .map((b) => b.trim())
        .where((b) => b.isNotEmpty)
        .map((b) => _ImportedItem(content: b))
        .toList();

    setState(() {
      _items = parsed;
      _selectedIndex = parsed.isNotEmpty ? 0 : null;
      _showInput = false;
    });
  }

  void _useSelected(BuildContext context) {
    if (_selectedIndex == null || _selectedIndex! >= _items.length) return;
    final content = _items[_selectedIndex!].content;
    context.read<CampaignProvider>().updateCampaignPrompt(content);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Content imported into campaign prompt.'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _reset() {
    setState(() {
      _items = [];
      _selectedIndex = null;
      _pasteController.clear();
      _showInput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.dividerColor, width: 1),
        ),
        // Use a Column with a fixed header and a scrollable body so the panel
        // itself is fixed-position (does not scroll with the form).
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.upload_file, color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Bulk Import',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_items.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 18),
                      tooltip: 'Reset',
                      onPressed: _reset,
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),

            // ── Body (independently scrollable) ─────────────────────────
            Expanded(
              child: _showInput
                  ? _buildInputView(context, theme)
                  : _buildListView(context, theme),
            ),

            // ── Footer: action button ────────────────────────────────────
            if (!_showInput && _items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: FilledButton.icon(
                  onPressed: _selectedIndex != null
                      ? () => _useSelected(context)
                      : null,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Use Selected'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputView(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Paste your post drafts below.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Separate multiple items with a blank line.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Paste area
          Expanded(
            child: TextField(
              controller: _pasteController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText:
                    'Post draft 1…\n\nPost draft 2…\n\nPost draft 3…',
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      _pasteController.text = data!.text!;
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.content_paste, size: 16),
                  label: const Text('Paste'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _pasteController.text.trim().isEmpty
                      ? null
                      : _parseInput,
                  icon: const Icon(Icons.list, size: 16),
                  label: const Text('Parse'),
                  style: FilledButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView(BuildContext context, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        final isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () => setState(() => _selectedIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primaryContainer.withValues(alpha: 0.8)
                  : theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 16,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Draft ${index + 1}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${item.content.length} chars',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.content.length > 120
                      ? '${item.content.substring(0, 120)}…'
                      : item.content,
                  style: theme.textTheme.bodySmall,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ImportedItem {
  final String content;
  const _ImportedItem({required this.content});
}
