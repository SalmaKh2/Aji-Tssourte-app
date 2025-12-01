import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Customization modal widget for adjusting program parameters
class CustomizationModalWidget extends StatefulWidget {
  final Function(int frequency, Map<String, double> focusEmphasis) onSave;

  const CustomizationModalWidget({super.key, required this.onSave});

  @override
  State<CustomizationModalWidget> createState() =>
      _CustomizationModalWidgetState();
}

class _CustomizationModalWidgetState extends State<CustomizationModalWidget> {
  int _sessionsPerWeek = 3;
  double _mobilityEmphasis = 0.33;
  double _stabilityEmphasis = 0.33;
  double _awarenessEmphasis = 0.34;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 75.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Customize Your Program',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session frequency
                  Text(
                    'Sessions Per Week',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Adjust how many sessions you want to complete each week',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Frequency selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [2, 3, 4].map((frequency) {
                      final isSelected = _sessionsPerWeek == frequency;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.w),
                          child: InkWell(
                            onTap: () =>
                                setState(() => _sessionsPerWeek = frequency),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? theme.colorScheme.primaryContainer
                                    : theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline.withValues(
                                          alpha: 0.2,
                                        ),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    frequency.toString(),
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: isSelected
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.onSurface,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  Text(
                                    'sessions',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 4.h),

                  // Focus area emphasis
                  Text(
                    'Focus Area Emphasis',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Adjust the emphasis on each focus area (must total 100%)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Mobility slider
                  _buildEmphasisSlider(
                    theme,
                    'Mobility',
                    _mobilityEmphasis,
                    theme.colorScheme.primary,
                    (value) {
                      setState(() {
                        _mobilityEmphasis = value;
                        _normalizeEmphasis();
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Stability slider
                  _buildEmphasisSlider(
                    theme,
                    'Stability',
                    _stabilityEmphasis,
                    theme.colorScheme.secondary,
                    (value) {
                      setState(() {
                        _stabilityEmphasis = value;
                        _normalizeEmphasis();
                      });
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Awareness slider
                  _buildEmphasisSlider(
                    theme,
                    'Body Awareness',
                    _awarenessEmphasis,
                    theme.colorScheme.tertiary,
                    (value) {
                      setState(() {
                        _awarenessEmphasis = value;
                        _normalizeEmphasis();
                      });
                    },
                  ),

                  SizedBox(height: 4.h),

                  // Info box
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info_outline',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Changes will regenerate your program while maintaining the overall structure and duration.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  offset: Offset(0, -2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSave(_sessionsPerWeek, {
                        'mobility': _mobilityEmphasis,
                        'stability': _stabilityEmphasis,
                        'awareness': _awarenessEmphasis,
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds emphasis slider widget
  Widget _buildEmphasisSlider(
    ThemeData theme,
    String label,
    double value,
    Color color,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: theme.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            inactiveTrackColor: color.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            min: 0.0,
            max: 1.0,
            divisions: 20,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  /// Normalizes emphasis values to sum to 1.0
  void _normalizeEmphasis() {
    final total = _mobilityEmphasis + _stabilityEmphasis + _awarenessEmphasis;
    if (total > 0) {
      _mobilityEmphasis = _mobilityEmphasis / total;
      _stabilityEmphasis = _stabilityEmphasis / total;
      _awarenessEmphasis = _awarenessEmphasis / total;
    }
  }
}
