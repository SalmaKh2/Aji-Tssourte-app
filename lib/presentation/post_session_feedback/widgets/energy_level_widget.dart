import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Energy Level Widget
///
/// Displays energy level selection using segmented control with
/// four options: Low, Moderate, High, and Energized.
class EnergyLevelWidget extends StatelessWidget {
  final String selectedLevel;
  final ValueChanged<String> onChanged;

  const EnergyLevelWidget({
    super.key,
    required this.selectedLevel,
    required this.onChanged,
  });

  static const List<String> _energyLevels = [
    'Low',
    'Moderate',
    'High',
    'Energized',
  ];

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
                  color: _getEnergyColor(
                    selectedLevel,
                    theme,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'bolt',
                  color: _getEnergyColor(selectedLevel, theme),
                  size: 20,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Energy Level',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Selected level indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getEnergyColor(
                    selectedLevel,
                    theme,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getEnergyEmoji(selectedLevel),
                      style: const TextStyle(fontSize: 16),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      selectedLevel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getEnergyColor(selectedLevel, theme),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Segmented control
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: _energyLevels.map((level) {
                final isSelected = level == selectedLevel;
                final isFirst = level == _energyLevels.first;
                final isLast = level == _energyLevels.last;

                return Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onChanged(level),
                      borderRadius: BorderRadius.horizontal(
                        left: isFirst ? const Radius.circular(12) : Radius.zero,
                        right: isLast ? const Radius.circular(12) : Radius.zero,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _getEnergyColor(
                                  level,
                                  theme,
                                ).withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.horizontal(
                            left: isFirst
                                ? const Radius.circular(12)
                                : Radius.zero,
                            right: isLast
                                ? const Radius.circular(12)
                                : Radius.zero,
                          ),
                          border: isSelected
                              ? Border.all(
                                  color: _getEnergyColor(level, theme),
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getEnergyEmoji(level),
                              style: TextStyle(fontSize: isSelected ? 24 : 20),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              level,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? _getEnergyColor(level, theme)
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.6,
                                      ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 2.h),

          // Description
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: _getEnergyColor(
                selectedLevel,
                theme,
              ).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: _getEnergyColor(selectedLevel, theme),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getEnergyDescription(selectedLevel),
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

  /// Gets energy color based on level
  Color _getEnergyColor(String level, ThemeData theme) {
    switch (level) {
      case 'Low':
        return const Color(0xFFE53E3E);
      case 'Moderate':
        return const Color(0xFFFF9800);
      case 'High':
        return theme.colorScheme.secondary;
      case 'Energized':
        return theme.colorScheme.primary;
      default:
        return theme.colorScheme.primary;
    }
  }

  /// Gets energy emoji based on level
  String _getEnergyEmoji(String level) {
    switch (level) {
      case 'Low':
        return '😴';
      case 'Moderate':
        return '🙂';
      case 'High':
        return '😊';
      case 'Energized':
        return '⚡';
      default:
        return '🙂';
    }
  }

  /// Gets energy description based on level
  String _getEnergyDescription(String level) {
    switch (level) {
      case 'Low':
        return 'Feeling tired or fatigued after the session';
      case 'Moderate':
        return 'Feeling normal energy levels, neither tired nor energized';
      case 'High':
        return 'Feeling good and ready for more activity';
      case 'Energized':
        return 'Feeling highly energized and motivated';
      default:
        return 'Select your energy level after the session';
    }
  }
}
