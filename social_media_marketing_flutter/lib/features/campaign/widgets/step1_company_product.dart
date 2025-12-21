import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:social_media_marketing_client/social_media_marketing_client.dart';
import '../providers/campaign_provider.dart';
import '../providers/company_provider.dart';

/// Step 1: Company & Product Selection
/// Allows users to select or create a company and product for the campaign
class Step1CompanyProduct extends StatefulWidget {
  const Step1CompanyProduct({super.key});

  @override
  State<Step1CompanyProduct> createState() => _Step1CompanyProductState();
}

class _Step1CompanyProductState extends State<Step1CompanyProduct> {
  @override
  void initState() {
    super.initState();
    // Load companies when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyProvider = context.read<CompanyProvider>();
      final campaignProvider = context.read<CampaignProvider>();

      // Load companies in both providers
      companyProvider.loadCompanies();
      campaignProvider.loadCompanyProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CampaignProvider, CompanyProvider>(
      builder: (context, campaign, companyProvider, child) {
        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Step 1: Company & Product Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select your company profile and product/service for this campaign.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 32),

              // Company Selector
              _buildCompanySelector(context, campaign, companyProvider),

              const SizedBox(height: 32),

              // Product Selector (enabled only when company is selected)
              _buildProductSelector(context, campaign, companyProvider),
            ],
          ),
        );
      },
    );
  }

  /// Build company selector section
  Widget _buildCompanySelector(
    BuildContext context,
    CampaignProvider campaign,
    CompanyProvider companyProvider,
  ) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Company Profile',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Company dropdown and create button
            Row(
              children: [
                Expanded(
                  child: companyProvider.isLoading || campaign.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Select Company',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          value: campaign.selectedCompanyId,
                          items: campaign.companies
                              .map((company) => DropdownMenuItem(
                                    value: company.id,
                                    child: Text(company.name),
                                  ))
                              .toList(),
                          onChanged: (companyId) async {
                            if (companyId != null) {
                              final company = campaign.companies.firstWhere(
                                (c) => c.id == companyId,
                              );
                              await campaign.selectCompany(company);
                            }
                          },
                        ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => _showCreateCompanyDialog(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Create New'),
                ),
              ],
            ),

            // Selected company details
            if (campaign.selectedCompany != null) ...[
              const SizedBox(height: 24),
              _buildCompanyDetails(context, campaign.selectedCompany!),
            ],
          ],
        ),
      ),
    );
  }

  /// Build company details section
  Widget _buildCompanyDetails(BuildContext context, CompanyProfile company) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected: ${company.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (company.description != null) ...[
            _buildDetailRow(Icons.description, 'Description', company.description!),
            const SizedBox(height: 8),
          ],
          if (company.brandVoice != null) ...[
            _buildDetailRow(Icons.record_voice_over, 'Brand Voice', company.brandVoice!),
            const SizedBox(height: 8),
          ],
          if (company.targetAudience != null) ...[
            _buildDetailRow(Icons.people, 'Target Audience', company.targetAudience!),
            const SizedBox(height: 8),
          ],
          if (company.industry != null) ...[
            _buildDetailRow(Icons.category, 'Industry', company.industry!),
            const SizedBox(height: 8),
          ],
          if (company.uploadedFiles != null && company.uploadedFiles!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.attach_file, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  'Files:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: company.uploadedFiles!.map((file) {
                return Chip(
                  avatar: const Icon(Icons.insert_drive_file, size: 16),
                  label: Text(file),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build detail row with icon
  Widget _buildDetailRow(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label:',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build product selector section
  Widget _buildProductSelector(
    BuildContext context,
    CampaignProvider campaign,
    CompanyProvider companyProvider,
  ) {
    final theme = Theme.of(context);
    final isEnabled = campaign.selectedCompany != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.inventory_2,
                  color: isEnabled ? theme.colorScheme.primary : theme.colorScheme.outline,
                ),
                const SizedBox(width: 12),
                Text(
                  'Product/Service',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? null : theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product dropdown and add button
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      labelText: 'Select Product',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    value: campaign.selectedProductId,
                    items: isEnabled && campaign.products.isNotEmpty
                        ? campaign.products
                            .map((product) => DropdownMenuItem(
                                  value: product.id,
                                  child: Text(product.name),
                                ))
                            .toList()
                        : [],
                    onChanged: isEnabled
                        ? (productId) {
                            if (productId != null) {
                              final product = campaign.products.firstWhere(
                                (p) => p.id == productId,
                              );
                              campaign.selectProduct(product);
                            } else {
                              campaign.selectProduct(null);
                            }
                          }
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: isEnabled ? () => _showAddProductDialog(context, campaign) : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product'),
                ),
              ],
            ),

            // Selected product details
            if (campaign.selectedProduct != null) ...[
              const SizedBox(height: 24),
              _buildProductDetails(context, campaign.selectedProduct!),
            ],
          ],
        ),
      ),
    );
  }

  /// Build product details section
  Widget _buildProductDetails(BuildContext context, Product product) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected: ${product.name}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          if (product.description != null) ...[
            _buildDetailRow(Icons.description, 'Description', product.description!),
            const SizedBox(height: 8),
          ],
          if (product.keyFeatures != null && product.keyFeatures!.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.star, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Features:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...product.keyFeatures!.map((feature) => Padding(
                            padding: const EdgeInsets.only(left: 8, top: 2),
                            child: Text('• $feature', style: theme.textTheme.bodyMedium),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          if (product.targetAudience != null) ...[
            _buildDetailRow(Icons.people, 'Target Audience', product.targetAudience!),
            const SizedBox(height: 8),
          ],
          if (product.category != null) ...[
            _buildDetailRow(Icons.category, 'Category', product.category!),
          ],
        ],
      ),
    );
  }

  /// Show create company dialog
  void _showCreateCompanyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CreateCompanyDialog(),
    );
  }

  /// Show add product dialog
  void _showAddProductDialog(BuildContext context, CampaignProvider campaign) {
    if (campaign.selectedCompanyId == null) return;

    showDialog(
      context: context,
      builder: (context) => AddProductDialog(companyId: campaign.selectedCompanyId!),
    );
  }
}

/// Create Company Dialog
class CreateCompanyDialog extends StatefulWidget {
  const CreateCompanyDialog({super.key});

  @override
  State<CreateCompanyDialog> createState() => _CreateCompanyDialogState();
}

class _CreateCompanyDialogState extends State<CreateCompanyDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _brandVoiceController = TextEditingController();
  final _targetAudienceController = TextEditingController();
  final _industryController = TextEditingController();
  final List<String> _uploadedFiles = [];
  bool _isUploading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _brandVoiceController.dispose();
    _targetAudienceController.dispose();
    _industryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Company'),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Company Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter company name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Brand Voice
                TextFormField(
                  controller: _brandVoiceController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Voice',
                    hintText: 'e.g., Professional, Friendly, Casual',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Target Audience
                TextFormField(
                  controller: _targetAudienceController,
                  decoration: const InputDecoration(
                    labelText: 'Target Audience',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Industry
                TextFormField(
                  controller: _industryController,
                  decoration: const InputDecoration(
                    labelText: 'Industry',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // File Upload
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _isUploading ? null : _pickFiles,
                      icon: _isUploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.upload_file),
                      label: const Text('Upload Documents'),
                    ),
                    if (_uploadedFiles.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _uploadedFiles.map((file) {
                          return Chip(
                            label: Text(file),
                            onDeleted: () {
                              setState(() {
                                _uploadedFiles.remove(file);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveCompany,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _pickFiles() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt', 'md', 'markdown'],
      );

      if (result != null) {
        setState(() {
          _uploadedFiles.addAll(result.files.map((file) => file.name));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking files: $e')),
        );
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _saveCompany() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final companyProvider = context.read<CompanyProvider>();
      final campaignProvider = context.read<CampaignProvider>();

      final newCompany = await companyProvider.createCompany(
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        brandVoice: _brandVoiceController.text.isEmpty ? null : _brandVoiceController.text,
        targetAudience:
            _targetAudienceController.text.isEmpty ? null : _targetAudienceController.text,
        industry: _industryController.text.isEmpty ? null : _industryController.text,
        uploadedFiles: _uploadedFiles.isEmpty ? null : _uploadedFiles,
      );

      if (mounted && newCompany != null) {
        // Reload companies in CampaignProvider to include the new company
        await campaignProvider.loadCompanyProfiles();

        // Auto-select the newly created company
        await campaignProvider.selectCompany(newCompany);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company created successfully')),
        );
      } else if (mounted && newCompany == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create company')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating company: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}

/// Add Product Dialog
class AddProductDialog extends StatefulWidget {
  final int companyId;

  const AddProductDialog({
    super.key,
    required this.companyId,
  });

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetAudienceController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<String> _keyFeatures = [];
  final _featureController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAudienceController.dispose();
    _categoryController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Product'),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Product Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Key Features
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Key Features',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _featureController,
                            decoration: const InputDecoration(
                              hintText: 'Add a feature',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            if (_featureController.text.isNotEmpty) {
                              setState(() {
                                _keyFeatures.add(_featureController.text);
                                _featureController.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    if (_keyFeatures.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _keyFeatures.map((feature) {
                          return Chip(
                            label: Text(feature),
                            onDeleted: () {
                              setState(() {
                                _keyFeatures.remove(feature);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Target Audience
                TextFormField(
                  controller: _targetAudienceController,
                  decoration: const InputDecoration(
                    labelText: 'Target Audience',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _saveProduct,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final companyProvider = context.read<CompanyProvider>();
      await companyProvider.addProduct(
        companyId: widget.companyId,
        name: _nameController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        keyFeatures: _keyFeatures.isEmpty ? null : _keyFeatures,
        targetAudience:
            _targetAudienceController.text.isEmpty ? null : _targetAudienceController.text,
        category: _categoryController.text.isEmpty ? null : _categoryController.text,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding product: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
