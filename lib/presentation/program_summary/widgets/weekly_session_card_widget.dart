import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Weekly session card widget displaying week overview and sessions
class WeeklySessionCardWidget extends StatelessWidget {
  final int weekNumber;
  final String weekTitle;
  final List<Map<String, dynamic>> sessions;
  final Function(Map<String, dynamic>) onSessionTap;

  const WeeklySessionCardWidget({
    super.key,
    required this.weekNumber,
    required this.weekTitle,
    required this.sessions,
    required this.onSessionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      weekNumber.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Week $weekNumber',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        weekTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'expand_more',
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ],
            ),
          ),

          // Sessions list
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            itemCount: sessions.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final session = sessions[index];
              return _buildSessionCard(context, theme, session);
            },
          ),
        ],
      ),
    );
  }

  /// Builds individual session card
  Widget _buildSessionCard(
    BuildContext context,
    ThemeData theme,
    Map<String, dynamic> session,
  ) {
    return InkWell(
      onTap: () => onSessionTap(session),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: session["thumbnail"] as String,
                width: 25.w,
                height: 12.h,
                fit: BoxFit.cover,
                semanticLabel: session["semanticLabel"] as String,
              ),
            ),

            // Session details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      session["title"] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 1.h),

                    // Focus areas
                    Wrap(
                      spacing: 1.w,
                      runSpacing: 0.5.h,
                      children: (session["focusAreas"] as List).take(2).map((
                        area,
                      ) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getFocusAreaColor(
                              theme,
                              area as String,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            area,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getFocusAreaColor(theme, area),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 1.h),

                    // Duration and difficulty
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          session["duration"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.6,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(
                              theme,
                              session["difficulty"] as String,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            session["difficulty"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _getDifficultyColor(
                                theme,
                                session["difficulty"] as String,
                              ),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow icon
            Padding(
              padding: EdgeInsets.only(right: 3.w),
              child: CustomIconWidget(
                iconName: 'chevron_right',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets color for focus area
  Color _getFocusAreaColor(ThemeData theme, String area) {
    switch (area.toLowerCase()) {
      case 'mobility':
        return theme.colorScheme.primary;
      case 'stability':
        return theme.colorScheme.secondary;
      case 'body awareness':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  /// Gets color for difficulty level
  Color _getDifficultyColor(ThemeData theme, String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return theme.colorScheme.secondary;
      case 'intermediate':
        return AppTheme.warningColor;
      case 'advanced':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurface;
    }
  }
}
