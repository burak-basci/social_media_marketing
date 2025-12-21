import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/layouts/main_layout.dart';
import '../providers/campaign_provider.dart';
import '../widgets/step_indicator.dart';
import '../widgets/step1_company_product.dart';
import '../widgets/step2_ai_generation.dart';
import '../widgets/step3_review_edit.dart';
import '../widgets/step4_schedule.dart';

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
          // Track unsaved changes
          _hasUnsavedChanges = campaign.currentStep > 0;

          return MainLayout(
            selectedIndex: 1, // Campaign tab
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

                // Navigation buttons at the bottom
                _buildNavigationButtons(context, campaign),
              ],
            ),
          );
        },
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
    // Handle step-specific actions
    switch (campaign.currentStep) {
      case 0: // Company & Product → AI Generation
        campaign.nextStep();
        break;

      case 1: // AI Generation → Review & Edit
        await _handleGeneration(context, campaign);
        break;

      case 2: // Review & Edit → Schedule
        campaign.nextStep();
        break;

      case 3: // Schedule → Publish/Schedule
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
    // Show confirmation dialog
    final confirmed = await _showPublishConfirmation(context, campaign);
    if (confirmed != true) return;

    try {
      if (!campaign.publishNow) {
        // Schedule for later
        // TODO: Call backend to schedule post
        // await client.post.schedulePost(campaign.postId!, campaign.scheduleTime!);
        if (context.mounted) {
          _showSuccess(context, 'Post scheduled successfully!');
          Navigator.of(context).pushReplacementNamed('/calendar');
        }
      } else {
        // Publish now
        // TODO: Call backend to publish now
        // await client.post.publishNow(campaign.postId!);
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

  /// Get icon for next step button
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

  /// Get label for next step button
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

  /// Show exit confirmation dialog
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

  /// Show publish confirmation dialog
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

  /// Show error message
  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show success message
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
