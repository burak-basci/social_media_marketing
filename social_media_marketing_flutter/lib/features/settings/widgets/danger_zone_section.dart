import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/utils/router.dart';
import '../providers/settings_provider.dart';

/// Danger zone section for account deactivation
class DangerZoneSection extends StatelessWidget {
  const DangerZoneSection({super.key});

  void _showDeactivateDialog(BuildContext context) {
    final passwordController = TextEditingController();
    bool isDeactivating = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            icon: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 48,
            ),
            title: const Text('Deactivate Account'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to deactivate your account?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap.md(),
                  Container(
                    padding: AppSpacing.paddingMD,
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(25),
                      borderRadius: AppSpacing.borderRadiusMD,
                      border: Border.all(
                        color: Colors.red.withAlpha(102),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                            const Gap.xs(),
                            Text(
                              'This action cannot be undone',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Gap.sm(),
                        Text(
                          'Deactivating your account will:',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Gap.xs(),
                        _buildWarningItem(
                          context,
                          'Disable your access to the platform',
                        ),
                        _buildWarningItem(
                          context,
                          'Mark your account as inactive',
                        ),
                        _buildWarningItem(
                          context,
                          'Require admin approval to reactivate',
                        ),
                      ],
                    ),
                  ),
                  const Gap.md(),
                  Text(
                    'Please enter your password to confirm:',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Gap.sm(),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    enabled: !isDeactivating,
                    autofocus: true,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isDeactivating
                    ? null
                    : () {
                        passwordController.dispose();
                        Navigator.of(context).pop();
                      },
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: isDeactivating
                    ? null
                    : () async {
                        if (passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter your password'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isDeactivating = true;
                        });

                        final provider =
                            Provider.of<SettingsProvider>(dialogContext, listen: false);
                        final success = await provider.deactivateAccount(
                          password: passwordController.text,
                        );

                        if (dialogContext.mounted) {
                          if (success) {
                            passwordController.dispose();
                            Navigator.of(dialogContext).pop();

                            // Log out and redirect to login
                            await AppRouter.logout();
                            if (dialogContext.mounted) {
                              dialogContext.go(AppRoutes.login);
                            }
                          } else {
                            setState(() {
                              isDeactivating = false;
                            });

                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(
                                content: Text(
                                  provider.error ??
                                      'Failed to deactivate account',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: isDeactivating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Deactivate Account'),
              ),
            ],
          );
        },
      ),
    ).then((_) {
      passwordController.dispose();
    });
  }

  Widget _buildWarningItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.md, top: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: Colors.red.withAlpha(25),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMD,
        side: BorderSide(
          color: Colors.red.withAlpha(128),
          width: 2,
        ),
      ),
      child: Padding(
        padding: AppSpacing.paddingLG,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: AppSpacing.iconMD,
                  color: Colors.red,
                ),
                const Gap.sm(),
                Text(
                  'Danger Zone',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const Gap.md(),
            Divider(
              color: Colors.red.withAlpha(128),
            ),
            const Gap.md(),

            // Warning text
            Text(
              'Once you deactivate your account, there is no going back. '
              'Please be certain.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            const Gap.lg(),

            // Deactivate button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showDeactivateDialog(context),
                icon: const Icon(Icons.delete_forever),
                label: const Text('Deactivate Account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red, width: 2),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
