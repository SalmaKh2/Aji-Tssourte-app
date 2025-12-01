import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Guidance section widget providing actionable medical consultation advice
///
/// Features:
/// - Clear call-to-action for medical consultation
/// - Emphasis on user safety priority
/// - Professional and supportive tone
/// - Visual hierarchy for important information
class GuidanceSectionWidget extends StatelessWidget {
  const GuidanceSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'local_hospital',
                color: theme.colorScheme.primary,
                size: 28,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Next Steps',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Main guidance text
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please consult with a healthcare professional before starting any exercise program',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 1.5.h),
                Text(
                  'A qualified healthcare provider can:',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                ..._buildGuidancePoints(theme),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Safety priority message
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'verified_user',
                  color: theme.colorScheme.secondary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Your safety is our top priority. We want to ensure you can exercise safely and effectively.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds list of guidance points
  List<Widget> _buildGuidancePoints(ThemeData theme) {
    final points = [
      'Evaluate your specific condition and symptoms',
      'Provide personalized medical advice',
      'Recommend appropriate treatment options',
      'Clear you for safe exercise participation',
    ];

    return points
        .map(
          (point) => Padding(
            padding: EdgeInsets.only(bottom: 1.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h),
                  child: CustomIconWidget(
                    iconName: 'check_circle',
                    color: theme.colorScheme.secondary,
                    size: 18,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    point,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
