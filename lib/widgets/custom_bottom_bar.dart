import 'package:flutter/material.dart';

/// Navigation item configuration for the bottom navigation bar
enum CustomBottomBarItem {
  dashboard(
    route: '/authentication-screen',
    icon: Icons.home_outlined,
    activeIcon: Icons.home,
    label: 'Home',
  ),
  programs(
    route: '/program-summary',
    icon: Icons.fitness_center_outlined,
    activeIcon: Icons.fitness_center,
    label: 'Programs',
  ),
  assessments(
    route: '/auto-assessment-hub',
    icon: Icons.assessment_outlined,
    activeIcon: Icons.assessment,
    label: 'Assess',
  ),
  progress(
    route: '/post-session-feedback',
    icon: Icons.trending_up_outlined,
    activeIcon: Icons.trending_up,
    label: 'Progress',
  ),
  profile(
    route: '/red-flags-alert',
    icon: Icons.person_outline,
    activeIcon: Icons.person,
    label: 'Profile',
  );

  const CustomBottomBarItem({
    required this.route,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final String route;
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

/// Custom bottom navigation bar widget implementing thumb-accessible design
/// for the motor reactivation app. Follows Contemporary Wellness Minimalism
/// design philosophy with clear visual hierarchy and minimal cognitive load.
///
/// Features:
/// - Bottom-heavy design strategy for natural thumb reach
/// - Clear active state indication with color and icon changes
/// - Smooth transitions between navigation items (200ms ease-out)
/// - Platform-specific styling that adapts to theme
/// - Accessibility support with semantic labels
///
/// Usage:
/// ```dart
/// Scaffold(
///   body: _currentScreen,
///   bottomNavigationBar: CustomBottomBar(
///     currentIndex: _selectedIndex,
///     onTap: (index) {
///       setState(() => _selectedIndex = index);
///     },
///   ),
/// )
/// ```
class CustomBottomBar extends StatelessWidget {
  /// Creates a custom bottom navigation bar
  ///
  /// [currentIndex] - Currently selected navigation item index (0-4)
  /// [onTap] - Callback when navigation item is tapped, receives item index
  /// [elevation] - Optional elevation for the bottom bar (default: 8.0)
  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.elevation = 8.0,
  }) : assert(
         currentIndex >= 0 && currentIndex < 5,
         'currentIndex must be between 0 and 4',
       );

  /// Currently selected navigation item index
  final int currentIndex;

  /// Callback function when a navigation item is tapped
  final ValueChanged<int> onTap;

  /// Elevation of the bottom navigation bar
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;

    return Container(
      decoration: BoxDecoration(
        color: bottomNavTheme.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, -2),
            blurRadius: elevation,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              CustomBottomBarItem.values.length,
              (index) => _buildNavigationItem(
                context,
                CustomBottomBarItem.values[index],
                index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds individual navigation item with icon and label
  Widget _buildNavigationItem(
    BuildContext context,
    CustomBottomBarItem item,
    int index,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;
    final isSelected = currentIndex == index;

    final itemColor = isSelected
        ? (bottomNavTheme.selectedItemColor ?? colorScheme.primary)
        : (bottomNavTheme.unselectedItemColor ??
              colorScheme.onSurface.withValues(alpha: 0.6));

    final labelStyle = isSelected
        ? bottomNavTheme.selectedLabelStyle
        : bottomNavTheme.unselectedLabelStyle;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(context, index, item.route),
          borderRadius: BorderRadius.circular(12),
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: colorScheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with smooth transition
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    size: 24,
                    color: itemColor,
                  ),
                ),
                SizedBox(height: 4),
                // Label with fade transition
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: (labelStyle ?? theme.textTheme.labelSmall!).copyWith(
                    color: itemColor,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles navigation item tap with route navigation
  void _handleTap(BuildContext context, int index, String route) {
    // Call the onTap callback
    onTap(index);

    // Navigate to the corresponding route
    // Using pushReplacementNamed to avoid stacking navigation screens
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }
}

/// Extension to provide quick access to bottom bar configuration
extension CustomBottomBarExtension on BuildContext {
  /// Gets the current bottom bar item based on route name
  CustomBottomBarItem? getCurrentBottomBarItem() {
    final currentRoute = ModalRoute.of(this)?.settings.name;
    if (currentRoute == null) return null;

    try {
      return CustomBottomBarItem.values.firstWhere(
        (item) => item.route == currentRoute,
      );
    } catch (e) {
      return null;
    }
  }

  /// Gets the index of current bottom bar item
  int getCurrentBottomBarIndex() {
    final item = getCurrentBottomBarItem();
    return item != null ? CustomBottomBarItem.values.indexOf(item) : 0;
  }
}
