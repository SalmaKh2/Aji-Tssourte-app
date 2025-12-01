import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Red flags list widget displaying detected issues
///
/// Features:
/// - Lists all detected red flags
/// - Clear, non-medical language explanations
/// - Visual severity indicators
/// - Organized card layout
class RedFlagsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> redFlags;

  const RedFlagsListWidget({
    super.key,
    required this.redFlags,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: theme.colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Detected Issues',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Red flags list
          ...redFlags.map((flag) => _buildRedFlagItem(context, flag, theme)),
        ],
      ),
    );
  }

  /// Builds individual red flag item
  Widget _buildRedFlagItem(
    BuildContext context,
    Map<String, dynamic> flag,
    ThemeData theme,
  ) {
    final isLastItem = redFlags.indexOf(flag) == redFlags.length - 1;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: _getSeverityColor(flag["severity"] as String, theme)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: _getSeverityColor(flag["severity"] as String, theme)
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: flag["icon"] as String,
                    color: _getSeverityColor(flag["severity"] as String, theme),
                    size: 5.w,
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flag["title"] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      flag["description"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLastItem) SizedBox(height: 2.h),
      ],
    );
  }

  /// Gets color based on severity level
  Color _getSeverityColor(String severity, ThemeData theme) {
    switch (severity) {
      case 'critical':
        return theme.colorScheme.error;
      case 'high':
        return AppTheme.warningLight;
      case 'medium':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.primary;
    }
  }
}