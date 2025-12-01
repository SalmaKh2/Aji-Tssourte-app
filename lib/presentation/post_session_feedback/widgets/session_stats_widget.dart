import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Session Statistics Widget
///
/// Displays celebration header with session completion statistics
/// including duration and exercises completed.
class SessionStatsWidget extends StatelessWidget {
  final String sessionName;
  final String duration;
  final int exercisesCompleted;

  const SessionStatsWidget({
    super.key,
    required this.sessionName,
    required this.duration,
    required this.exercisesCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary.withValues(alpha: 0.1),
            theme.colorScheme.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Celebration icon
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'celebration',
              color: theme.colorScheme.secondary,
              size: 32,
            ),
          ),

          SizedBox(height: 2.h),

          // Congratulations text
          Text(
            'Great Work!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 1.h),

          // Session name
          Text(
            sessionName,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                icon: 'timer',
                label: 'Duration',
                value: duration,
              ),
              Container(
                height: 6.h,
                width: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
              _buildStatItem(
                context,
                icon: 'fitness_center',
                label: 'Exercises',
                value: exercisesCompleted.toString(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual stat item
  Widget _buildStatItem(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.25.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
