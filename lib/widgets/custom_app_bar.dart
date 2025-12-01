import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different screen contexts
enum CustomAppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// Centered title variant for focused screens
  centered,

  /// Large title variant for main hub screens
  large,

  /// Transparent variant for immersive experiences (video player)
  transparent,

  /// Search variant with integrated search field
  search,
}

/// Custom app bar widget implementing Contemporary Wellness Minimalism design
/// for the motor reactivation app. Provides clean, minimal navigation with
/// clear visual hierarchy optimized for mobile exercise contexts.
///
/// Features:
/// - Multiple variants for different screen contexts
/// - Smooth transitions and animations
/// - Accessibility support with semantic labels
/// - Platform-specific styling (iOS/Android)
/// - Transparent overlay support for video sessions
/// - Integrated search functionality
///
/// Usage:
/// ```dart
/// Scaffold(
///   appBar: CustomAppBar(
///     title: 'Dashboard',
///     variant: CustomAppBarVariant.standard,
///     actions: [
///       IconButton(
///         icon: Icon(Icons.notifications_outlined),
///         onPressed: () {},
///       ),
///     ],
///   ),
///   body: content,
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a custom app bar
  ///
  /// Required parameters:
  /// [title] - Title text or widget to display
  ///
  /// Optional parameters:
  /// [variant] - Visual variant of the app bar (default: standard)
  /// [leading] - Widget to display before the title (default: back button if applicable)
  /// [actions] - List of action widgets to display after the title
  /// [onSearchChanged] - Callback for search variant when text changes
  /// [searchHint] - Hint text for search field
  /// [backgroundColor] - Custom background color (overrides theme)
  /// [elevation] - Elevation of the app bar (default: 0 for minimal design)
  /// [showBackButton] - Whether to show back button (default: auto-detect)
  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.leading,
    this.actions,
    this.onSearchChanged,
    this.searchHint = 'Search...',
    this.backgroundColor,
    this.elevation = 0,
    this.showBackButton,
  });

  /// Title of the app bar (String or Widget)
  final dynamic title;

  /// Visual variant of the app bar
  final CustomAppBarVariant variant;

  /// Leading widget (typically back button or menu icon)
  final Widget? leading;

  /// Action widgets displayed on the right side
  final List<Widget>? actions;

  /// Callback for search text changes (required for search variant)
  final ValueChanged<String>? onSearchChanged;

  /// Hint text for search field
  final String searchHint;

  /// Custom background color
  final Color? backgroundColor;

  /// Elevation of the app bar
  final double elevation;

  /// Whether to show back button (null = auto-detect)
  final bool? showBackButton;

  @override
  Size get preferredSize {
    switch (variant) {
      case CustomAppBarVariant.large:
        return Size.fromHeight(96);
      case CustomAppBarVariant.search:
        return Size.fromHeight(64);
      default:
        return Size.fromHeight(56);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;

    // Determine if we should show back button
    final canPop = Navigator.canPop(context);
    final shouldShowBack = showBackButton ?? canPop;

    // Get background color based on variant
    final bgColor = _getBackgroundColor(context);

    // Get system overlay style for status bar
    final overlayStyle = _getSystemOverlayStyle(context);

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: appBarTheme.foregroundColor ?? colorScheme.onSurface,
      elevation: elevation,
      scrolledUnderElevation:
          variant == CustomAppBarVariant.transparent ? 0 : 4,
      systemOverlayStyle: overlayStyle,
      centerTitle: variant == CustomAppBarVariant.centered,
      leading: leading ?? (shouldShowBack ? _buildBackButton(context) : null),
      title: _buildTitle(context),
      actions: actions != null ? _buildActions(context) : null,
      toolbarHeight: preferredSize.height,
      automaticallyImplyLeading: false,
    );
  }

  /// Builds the title widget based on variant
  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    switch (variant) {
      case CustomAppBarVariant.search:
        return _buildSearchField(context);

      case CustomAppBarVariant.large:
        return Align(
          alignment: Alignment.centerLeft,
          child: _buildTitleText(
            context,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: appBarTheme.foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

      case CustomAppBarVariant.transparent:
        return _buildTitleText(
          context,
          style: appBarTheme.titleTextStyle?.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: Offset(0, 1),
                blurRadius: 4,
              ),
            ],
          ),
        );

      default:
        return _buildTitleText(context);
    }
  }

  /// Builds title text widget
  Widget _buildTitleText(BuildContext context, {TextStyle? style}) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    if (title is Widget) {
      return title as Widget;
    }

    return Text(
      title.toString(),
      style: style ?? appBarTheme.titleTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds search field for search variant
  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        style: theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: searchHint,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          isDense: true,
        ),
      ),
    );
  }

  /// Builds custom back button with proper touch target
  Widget _buildBackButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isTransparent = variant == CustomAppBarVariant.transparent;

    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: isTransparent
            ? Colors.white
            : (theme.appBarTheme.foregroundColor ?? colorScheme.onSurface),
      ),
      iconSize: 24,
      padding: EdgeInsets.all(12),
      constraints: BoxConstraints(minWidth: 48, minHeight: 48),
      onPressed: () => Navigator.maybePop(context),
      tooltip: 'Back',
    );
  }

  /// Builds action widgets with proper spacing
  List<Widget> _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) return [];

    return [
      ...actions!,
      SizedBox(width: 8), // Right padding
    ];
  }

  /// Gets background color based on variant and theme
  Color _getBackgroundColor(BuildContext context) {
    if (backgroundColor != null) return backgroundColor!;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return Colors.transparent;
      default:
        return appBarTheme.backgroundColor ?? colorScheme.surface;
    }
  }

  /// Gets system overlay style for status bar
  SystemUiOverlayStyle _getSystemOverlayStyle(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;

    switch (variant) {
      case CustomAppBarVariant.transparent:
        return SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        );
      default:
        return brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light;
    }
  }
}

/// Extension to provide quick app bar creation methods
extension CustomAppBarExtension on BuildContext {
  /// Creates a standard app bar with title
  CustomAppBar standardAppBar({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.standard,
      actions: actions,
    );
  }

  /// Creates a centered app bar with title
  CustomAppBar centeredAppBar({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.centered,
      actions: actions,
    );
  }

  /// Creates a large title app bar for hub screens
  CustomAppBar largeAppBar({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.large,
      actions: actions,
    );
  }

  /// Creates a transparent app bar for immersive experiences
  CustomAppBar transparentAppBar({
    required String title,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: CustomAppBarVariant.transparent,
      actions: actions,
    );
  }

  /// Creates a search app bar with integrated search field
  CustomAppBar searchAppBar({
    required ValueChanged<String> onSearchChanged,
    String searchHint = 'Search...',
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: '',
      variant: CustomAppBarVariant.search,
      onSearchChanged: onSearchChanged,
      searchHint: searchHint,
      actions: actions,
    );
  }
}
