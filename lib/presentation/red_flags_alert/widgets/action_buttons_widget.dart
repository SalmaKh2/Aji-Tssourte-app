import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Action buttons widget for healthcare provider search and acknowledgment
///
/// Features:
/// - "Find Healthcare Providers" button linking to external directory
/// - "I Understand" button requiring checkbox confirmation
/// - Loading states during processing
/// - Disabled state when acknowledgment not checked
class ActionButtonsWidget extends StatelessWidget {
  final bool hasAcknowledged;
  final bool isProcessing;
  final VoidCallback onFindProviders;
  final VoidCallback onAcknowledge;

  const ActionButtonsWidget({
    super.key,
    required this.hasAcknowledged,
    required this.isProcessing,
    required this.onFindProviders,
    required this.onAcknowledge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Find Healthcare Providers button
        ElevatedButton(
          onPressed: isProcessing ? null : onFindProviders,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: isProcessing
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.onSecondary,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'search',
                      color: theme.colorScheme.onSecondary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Find Healthcare Providers',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),

        SizedBox(height: 2.h),

        // I Understand button
        ElevatedButton(
          onPressed: isProcessing ? null : onAcknowledge,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasAcknowledged
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            foregroundColor: hasAcknowledged
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: hasAcknowledged ? 2 : 0,
          ),
          child: isProcessing
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hasAcknowledged
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: hasAcknowledged
                          ? 'check_circle'
                          : 'check_circle_outline',
                      color: hasAcknowledged
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'I Understand',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: hasAcknowledged
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),

        SizedBox(height: 1.h),

        // Helper text
        if (!hasAcknowledged)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Please check the acknowledgment box above to continue',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
