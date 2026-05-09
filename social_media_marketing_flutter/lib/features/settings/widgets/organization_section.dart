import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_spacing.dart';
import '../providers/settings_provider.dart';

/// Organization settings section (admin only)
class OrganizationSection extends StatefulWidget {
  const OrganizationSection({super.key});

  @override
  State<OrganizationSection> createState() => _OrganizationSectionState();
}

class _OrganizationSectionState extends State<OrganizationSection> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _organizationNameController;
  late TextEditingController _postizApiKeyController;
  late TextEditingController _geminiApiKeyController;
  bool _hasChanges = false;
  bool _showPostizKey = false;
  bool _showGeminiKey = false;

  @override
  void initState() {
    super.initState();
    _organizationNameController = TextEditingController();
    _postizApiKeyController = TextEditingController();
    _geminiApiKeyController = TextEditingController();

    // Load initial values
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<SettingsProvider>();
      if (provider.organization != null) {
        _organizationNameController.text = provider.organization!.name;
        _postizApiKeyController.text = provider.organization!.postizApiKey ?? '';
        _geminiApiKeyController.text = provider.organization!.geminiApiKey ?? '';
      }
    });

    // Add listeners to track changes
    _organizationNameController.addListener(_onFieldChanged);
    _postizApiKeyController.addListener(_onFieldChanged);
    _geminiApiKeyController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _organizationNameController.removeListener(_onFieldChanged);
    _postizApiKeyController.removeListener(_onFieldChanged);
    _geminiApiKeyController.removeListener(_onFieldChanged);
    _organizationNameController.dispose();
    _postizApiKeyController.dispose();
    _geminiApiKeyController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final provider = context.read<SettingsProvider>();
    final hasChanges = provider.organization != null &&
        (_organizationNameController.text != provider.organization!.name ||
            _postizApiKeyController.text !=
                (provider.organization!.postizApiKey ?? '') ||
            _geminiApiKeyController.text !=
                (provider.organization!.geminiApiKey ?? ''));

    if (hasChanges != _hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<SettingsProvider>();
    final success = await provider.updateOrganization(
      organizationName: _organizationNameController.text,
      postizApiKey: _postizApiKeyController.text.isNotEmpty
          ? _postizApiKeyController.text
          : null,
      geminiApiKey: _geminiApiKeyController.text.isNotEmpty
          ? _geminiApiKeyController.text
          : null,
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        _hasChanges = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Organization settings updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to update organization settings'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<SettingsProvider>(
      builder: (context, provider, child) {
        // Only show for admin users
        if (!provider.isAdmin) {
          return const SizedBox.shrink();
        }

        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.organization == null) {
          return Card(
            child: Padding(
              padding: AppSpacing.paddingLG,
              child: Center(
                child: Text(
                  'Failed to load organization settings',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: AppSpacing.paddingLG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
                  children: [
                    Icon(
                      Icons.business_outlined,
                      size: AppSpacing.iconMD,
                      color: theme.colorScheme.primary,
                    ),
                    const Gap.sm(),
                    Text(
                      'Organization Settings',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Gap.sm(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: AppSpacing.borderRadiusSM,
                      ),
                      child: Text(
                        'ADMIN ONLY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap.md(),
                const Divider(),
                const Gap.md(),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Organization Name field
                      TextFormField(
                        controller: _organizationNameController,
                        decoration: const InputDecoration(
                          labelText: 'Organization Name',
                          hintText: 'Enter organization name',
                          prefixIcon: Icon(Icons.business),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Organization name is required';
                          }
                          return null;
                        },
                      ),
                      const Gap.lg(),

                      // API Keys section
                      Text(
                        'API Keys',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap.sm(),
                      Text(
                        'Configure API keys for external services',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Gap.md(),

                      // Postiz API Key field
                      TextFormField(
                        controller: _postizApiKeyController,
                        obscureText: !_showPostizKey,
                        decoration: InputDecoration(
                          labelText: 'Postiz API Key',
                          hintText: 'Enter Postiz API key',
                          prefixIcon: const Icon(Icons.key),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPostizKey
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPostizKey = !_showPostizKey;
                              });
                            },
                            tooltip: _showPostizKey ? 'Hide key' : 'Show key',
                          ),
                        ),
                      ),
                      const Gap.md(),

                      // Gemini API Key field
                      TextFormField(
                        controller: _geminiApiKeyController,
                        obscureText: !_showGeminiKey,
                        decoration: InputDecoration(
                          labelText: 'Gemini API Key',
                          hintText: 'Enter Gemini API key',
                          prefixIcon: const Icon(Icons.key),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showGeminiKey
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _showGeminiKey = !_showGeminiKey;
                              });
                            },
                            tooltip: _showGeminiKey ? 'Hide key' : 'Show key',
                          ),
                        ),
                      ),
                      const Gap.lg(),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed:
                              _hasChanges && !provider.isSaving ? _handleSave : null,
                          icon: provider.isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(provider.isSaving ? 'Saving...' : 'Save Changes'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
