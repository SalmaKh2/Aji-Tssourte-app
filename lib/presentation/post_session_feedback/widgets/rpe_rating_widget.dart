import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// RPE Rating Widget
///
/// Displays RPE (Rate of Perceived Exertion) rating slider with
/// emoji-enhanced visual feedback for effort levels 1-10.
class RPERatingWidget extends StatelessWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const RPERatingWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'fitness_center',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Effort Level (RPE)',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Required',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Current value display with emoji
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getRPEColor(
                    initialValue,
                    theme,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getRPEEmoji(initialValue),
                      style: const TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      initialValue.toInt().toString(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getRPEColor(initialValue, theme),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getRPEColor(initialValue, theme),
              inactiveTrackColor: theme.colorScheme.outline.withValues(
                alpha: 0.2,
              ),
              thumbColor: _getRPEColor(initialValue, theme),
              overlayColor: _getRPEColor(
                initialValue,
                theme,
              ).withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: _getRPEColor(initialValue, theme),
              valueIndicatorTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Slider(
              value: initialValue,
              min: 1,
              max: 10,
              divisions: 9,
              label: '${initialValue.toInt()} ${_getRPEEmoji(initialValue)}',
              onChanged: onChanged,
            ),
          ),

          SizedBox(height: 1.h),

          // Scale labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScaleLabel(context, '1', 'Very Easy'),
              _buildScaleLabel(context, '5', 'Moderate'),
              _buildScaleLabel(context, '10', 'Maximum'),
            ],
          ),

          SizedBox(height: 2.h),

          // Description
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getRPEDescription(initialValue),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
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

  /// Builds scale label
  Widget _buildScaleLabel(BuildContext context, String value, String label) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  /// Gets RPE color based on value
  Color _getRPEColor(double value, ThemeData theme) {
    if (value <= 3) {
      return theme.colorScheme.secondary;
    } else if (value <= 6) {
      return theme.colorScheme.primary;
    } else if (value <= 8) {
      return const Color(0xFFFF9800);
    } else {
      return theme.colorScheme.error;
    }
  }

  /// Gets RPE emoji based on value
  String _getRPEEmoji(double value) {
    if (value <= 2) return '😌';
    if (value <= 4) return '🙂';
    if (value <= 6) return '😊';
    if (value <= 8) return '😅';
    return '😰';
  }

  /// Gets RPE description based on value
  String _getRPEDescription(double value) {
    if (value <= 3) {
      return 'Very light effort - could continue for hours';
    } else if (value <= 5) {
      return 'Light to moderate - comfortable pace';
    } else if (value <= 7) {
      return 'Moderate to hard - challenging but sustainable';
    } else if (value <= 9) {
      return 'Very hard - difficult to maintain';
    } else {
      return 'Maximum effort - cannot continue much longer';
    }
  }
}
