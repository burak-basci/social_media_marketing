import 'package:flutter/material.dart';

/// Step Indicator Widget
/// Shows progress through the 4-step campaign wizard
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Step circles and connecting lines
          Row(
            children: List.generate(
              totalSteps * 2 - 1, // Steps + connecting lines
              (index) {
                if (index.isEven) {
                  // Step circle
                  final stepIndex = index ~/ 2;
                  return _buildStepCircle(
                    context,
                    stepIndex,
                    currentStep,
                  );
                } else {
                  // Connecting line
                  final stepIndex = index ~/ 2;
                  return _buildConnectingLine(
                    context,
                    stepIndex < currentStep,
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 12),

          // Step labels
          Row(
            children: List.generate(totalSteps, (index) {
              return Expanded(
                child: _buildStepLabel(context, index),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Build step circle with number or checkmark
  Widget _buildStepCircle(BuildContext context, int stepIndex, int currentStep) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = stepIndex < currentStep;
    final isCurrent = stepIndex == currentStep;
    final isFuture = stepIndex > currentStep;

    Color backgroundColor;
    Color textColor;
    Widget child;

    if (isCompleted) {
      // Completed step: filled circle with checkmark
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      child = Icon(
        Icons.check,
        size: 20,
        color: textColor,
      );
    } else if (isCurrent) {
      // Current step: filled circle with number
      backgroundColor = colorScheme.primary;
      textColor = colorScheme.onPrimary;
      child = Text(
        '${stepIndex + 1}',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      );
    } else {
      // Future step: outlined circle with number
      backgroundColor = Colors.transparent;
      textColor = colorScheme.outline;
      child = Text(
        '${stepIndex + 1}',
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      );
    }

    return Expanded(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: isFuture
              ? Border.all(
                  color: colorScheme.outline,
                  width: 2,
                )
              : null,
        ),
        child: Center(child: child),
      ),
    );
  }

  /// Build connecting line between steps
  Widget _buildConnectingLine(BuildContext context, bool isCompleted) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      flex: 1,
      child: Container(
        height: 2,
        color: isCompleted ? colorScheme.primary : colorScheme.outline,
      ),
    );
  }

  /// Build step label text
  Widget _buildStepLabel(BuildContext context, int stepIndex) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCurrent = stepIndex == currentStep;

    final labels = [
      'Company &\nProduct',
      'Generate\nContent',
      'Review &\nEdit',
      'Schedule',
    ];

    return Text(
      labels[stepIndex],
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
        color: isCurrent ? colorScheme.primary : colorScheme.onSurfaceVariant,
        height: 1.3,
      ),
    );
  }
}
