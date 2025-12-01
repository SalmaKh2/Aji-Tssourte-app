import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Safety controls widget with modify and emergency stop buttons
class SafetyControlsWidget extends StatelessWidget {
  final bool showModifyInstructions;
  final VoidCallback onModifyPressed;
  final VoidCallback onEmergencyStopPressed;

  const SafetyControlsWidget({
    super.key,
    required this.showModifyInstructions,
    required this.onModifyPressed,
    required this.onEmergencyStopPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Modify for pain button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onModifyPressed,
            icon: CustomIconWidget(
              iconName: showModifyInstructions ? 'check_circle' : 'healing',
              color: showModifyInstructions
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.primary,
              size: 20,
            ),
            label: Text(
              showModifyInstructions
                  ? 'Showing Modified Instructions'
                  : 'Modify for Pain',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: showModifyInstructions
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.primary,
              side: BorderSide(
                color: showModifyInstructions
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.primary,
                width: 1.5,
              ),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Emergency stop button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onEmergencyStopPressed,
            icon: CustomIconWidget(
              iconName: 'warning',
              color: theme.colorScheme.error,
              size: 20,
            ),
            label: const Text('Emergency Stop'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error, width: 1.5),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
            ),
          ),
        ),

        SizedBox(height: 1.h),

        // Safety note
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: theme.colorScheme.error,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Stop immediately if you experience sharp pain or discomfort',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
