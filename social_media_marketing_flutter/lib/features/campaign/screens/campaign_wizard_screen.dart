import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../providers/campaign_provider.dart';
import '../widgets/step_indicator.dart';
import '../widgets/step1_company_product.dart';
import '../widgets/step2_ai_generation.dart';
import '../widgets/step3_review_edit.dart';
import '../widgets/step4_schedule.dart';
import '../widgets/bulk_import_panel.dart';

/// Main Campaign Creation Wizard Screen
/// Manages the 4-step process: Company/Product → AI Generation → Review/Edit → Schedule/Publish
class CampaignWizardScreen extends StatefulWidget {
  const CampaignWizardScreen({super.key});

  @override
  State<CampaignWizardScreen> createState() => _CampaignWizardScreenState();
}

class _CampaignWizardScreenState extends State<CampaignWizardScreen> {
  bool _hasUnsavedChanges = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop == true && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Consumer<CampaignProvider>(
        builder: (context, campaign, child) {
          _hasUnsavedChanges = campaign.currentStep > 0;

          final isDesktop = MediaQuery.of(context).size.width >= 900;

          return MainLayout(
            selectedIndex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isDesktop
                  ? _buildDesktopLayout(context, campaign)
                  : _buildMobileLayout(context, campaign),
            ),
          );
        },
      ),
    );
  }

  /// Desktop: Form panel (left, rounded all sides) + fixed Bulk Import panel (right)
  Widget _buildDesktopLayout(BuildContext context, CampaignProvider campaign) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: scrollable form wrapped in a fully-rounded card
        Expanded(
          flex: 3,
          child: _buildFormPanel(context, campaign),
        ),

        const SizedBox(width: 16),

        // Right: fixed Bulk Import panel (does NOT scroll with the form)
        const SizedBox(
          width: 320,
          child: BulkImportPanel(),
        ),
      ],
    );
  }

  /// Mobile: only the form panel (no Bulk Import sidebar)
  Widget _buildMobileLayout(BuildContext context, CampaignProvider campaign) {
    return _buildFormPanel(context, campaign);
  }

  /// The wizard form: StepIndicator + scrollable content + navigation buttons,
  /// wrapped in a ClipRRect so ALL corners (top AND bottom) are rounded.
  Widget _buildFormPanel(BuildContext context, CampaignProvider campaign) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Step indicator at the top
            StepIndicator(
              currentStep: campaign.currentStep,
              totalSteps: 4,
            ),

            // Current step widget
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: _buildCurrentStep(campaign.currentStep),
              ),
            ),

            // Navigation buttons — bottom of the panel, corners clipped by parent
            _buildNavigationButtons(context, campaign),
          ],
        ),
      ),
    );
  }

  /// Build the current step widget based on currentStep
  Widget _buildCurrentStep(int currentStep) {
    switch (currentStep) {
      case 0:
        return const Step1CompanyProduct();
      case 1:
        return const Step2AIGeneration();
      case 2:
        return const Step3ReviewEdit();
      case 3:
        return const Step4Schedule();
      default:
        return const Center(child: Text('Invalid step'));
    }
  }

  /// Build navigation buttons (Back, Next/Generate/Schedule)
  Widget _buildNavigationButtons(BuildContext context, CampaignProvider campaign) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (campaign.currentStep > 0)
            OutlinedButton.icon(
              onPressed: () => campaign.previousStep(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            )
          else
            const SizedBox.shrink(),

          // Next/Generate/Schedule button
          FilledButton.icon(
            onPressed: campaign.canGoNext
                ? () => _handleNextStep(context, campaign)
                : null,
            icon: Icon(_getNextStepIcon(campaign.currentStep)),
            label: Text(_getNextStepLabel(campaign.currentStep)),
          ),
        ],
      ),
    );
  }

  /// Handle next step navigation with validation
  Future<void> _handleNextStep(BuildContext context, CampaignProvider campaign) async {
    switch (campaign.currentStep) {
      case 0:
        campaign.nextStep();
        break;
      case 1:
        await _handleGeneration(context, campaign);
        break;
      case 2:
        campaign.nextStep();
        break;
      case 3:
        await _handlePublish(context, campaign);
        break;
    }
  }

  /// Handle AI content generation
  Future<void> _handleGeneration(BuildContext context, CampaignProvider campaign) async {
    try {
      await campaign.generateContent();
      campaign.nextStep();
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to generate content: $e');
      }
    }
  }

  /// Handle publish/schedule
  Future<void> _handlePublish(BuildContext context, CampaignProvider campaign) async {
    final confirmed = await _showPublishConfirmation(context, campaign);
    if (confirmed != true) return;

    try {
      if (!campaign.publishNow) {
        if (context.mounted) {
          _showSuccess(context, 'Post scheduled successfully!');
          Navigator.of(context).pushReplacementNamed('/calendar');
        }
      } else {
        if (context.mounted) {
          _showSuccess(context, 'Post published successfully!');
          Navigator.of(context).pushReplacementNamed('/calendar');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to publish: $e');
      }
    }
  }

  IconData _getNextStepIcon(int currentStep) {
    switch (currentStep) {
      case 0:
        return Icons.arrow_forward;
      case 1:
        return Icons.auto_awesome;
      case 2:
        return Icons.arrow_forward;
      case 3:
        return Icons.publish;
      default:
        return Icons.arrow_forward;
    }
  }

  String _getNextStepLabel(int currentStep) {
    switch (currentStep) {
      case 0:
        return 'Next';
      case 1:
        return 'Generate Content';
      case 2:
        return 'Next';
      case 3:
        return 'Publish';
      default:
        return 'Next';
    }
  }

  Future<bool?> _showExitConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Campaign Wizard?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to exit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showPublishConfirmation(BuildContext context, CampaignProvider campaign) {
    final action = !campaign.publishNow ? 'schedule' : 'publish';
    final platforms = campaign.selectedPlatforms.join(', ');

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${action == 'schedule' ? 'Schedule' : 'Publish'} Campaign?'),
        content: Text(
          !campaign.publishNow
              ? 'Your campaign will be scheduled for ${campaign.scheduleTime?.toString()} on $platforms.'
              : 'Your campaign will be published immediately on $platforms.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(action == 'schedule' ? 'Schedule' : 'Publish'),
          ),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
