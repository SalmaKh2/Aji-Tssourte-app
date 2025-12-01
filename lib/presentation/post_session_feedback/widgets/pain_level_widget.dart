import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Pain Level Widget
///
/// Displays pain level rating slider with color-coded visual feedback
/// from green (no pain) to red (severe pain) on a 0-10 scale.
class PainLevelWidget extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;

  const PainLevelWidget({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PainLevelWidget> createState() => _PainLevelWidgetState();
}

class _PainLevelWidgetState extends State<PainLevelWidget> {
  bool _showGuidance = false;

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
          // Header with icon and guidance toggle
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getPainColor(
                    widget.initialValue,
                    theme,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'healing',
                  color: _getPainColor(widget.initialValue, theme),
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pain Level',
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
              // Guidance toggle button
              InkWell(
                onTap: () {
                  setState(() => _showGuidance = !_showGuidance);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 2.w,
                    vertical: 0.5.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: _showGuidance
                            ? 'expand_less'
                            : 'help_outline',
                        color: theme.colorScheme.primary,
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _showGuidance ? 'Hide' : 'Guide',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              // Current value display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getPainColor(
                    widget.initialValue,
                    theme,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.initialValue.toInt().toString(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getPainColor(widget.initialValue, theme),
                  ),
                ),
              ),
            ],
          ),

          // Expandable guidance section
          if (_showGuidance) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pain Scale Guide',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildGuidanceItem(context, '0-2', 'No to mild pain'),
                  _buildGuidanceItem(context, '3-4', 'Moderate discomfort'),
                  _buildGuidanceItem(context, '5-6', 'Noticeable pain'),
                  _buildGuidanceItem(context, '7-8', 'Severe pain'),
                  _buildGuidanceItem(context, '9-10', 'Extreme pain'),
                ],
              ),
            ),
          ],

          SizedBox(height: 2.h),

          // Color-coded slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: _getPainColor(widget.initialValue, theme),
              inactiveTrackColor: theme.colorScheme.outline.withValues(
                alpha: 0.2,
              ),
              thumbColor: _getPainColor(widget.initialValue, theme),
              overlayColor: _getPainColor(
                widget.initialValue,
                theme,
              ).withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
              valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
              valueIndicatorColor: _getPainColor(widget.initialValue, theme),
              valueIndicatorTextStyle: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: Slider(
              value: widget.initialValue,
              min: 0,
              max: 10,
              divisions: 10,
              label: widget.initialValue.toInt().toString(),
              onChanged: widget.onChanged,
            ),
          ),

          SizedBox(height: 1.h),

          // Scale labels with color indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScaleLabel(
                context,
                '0',
                'No Pain',
                const Color(0xFF4CAF50),
              ),
              _buildScaleLabel(
                context,
                '5',
                'Moderate',
                const Color(0xFFFF9800),
              ),
              _buildScaleLabel(
                context,
                '10',
                'Severe',
                const Color(0xFFE53E3E),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Warning message for high pain levels
          if (widget.initialValue >= 7) ...[
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'High pain levels detected. Consider consulting a healthcare professional.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds guidance item
  Widget _buildGuidanceItem(
    BuildContext context,
    String range,
    String description,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            padding: EdgeInsets.symmetric(vertical: 0.25.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              range,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds scale label with color indicator
  Widget _buildScaleLabel(
    BuildContext context,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 0.5.h),
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

  /// Gets pain color based on value (green to red gradient)
  Color _getPainColor(double value, ThemeData theme) {
    if (value <= 2) {
      return const Color(0xFF4CAF50); // Green
    } else if (value <= 4) {
      return const Color(0xFF8BC34A); // Light green
    } else if (value <= 6) {
      return const Color(0xFFFF9800); // Orange
    } else if (value <= 8) {
      return const Color(0xFFFF5722); // Deep orange
    } else {
      return const Color(0xFFE53E3E); // Red
    }
  }
}
