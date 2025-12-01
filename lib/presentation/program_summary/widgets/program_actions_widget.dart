import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Program actions widget with primary and secondary action buttons
class ProgramActionsWidget extends StatelessWidget {
  final VoidCallback onStartProgram;
  final VoidCallback onCustomizeProgram;

  const ProgramActionsWidget({
    super.key,
    required this.onStartProgram,
    required this.onCustomizeProgram,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Primary action - Start Program
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton.icon(
              onPressed: onStartProgram,
              icon: CustomIconWidget(
                iconName: 'play_arrow',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Start Program',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Secondary action - Customize Program
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: onCustomizeProgram,
              icon: CustomIconWidget(
                iconName: 'tune',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              label: Text(
                'Customize Program',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
