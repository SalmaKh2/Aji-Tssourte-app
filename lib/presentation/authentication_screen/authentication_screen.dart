import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/register_form_widget.dart';

/// Authentication screen for user login and registration
/// Implements secure authentication with age validation (18-30 years)
/// Features biometric authentication support and JWT token handling
class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Handles successful authentication
  void _handleAuthSuccess(bool isNewUser) {
    HapticFeedback.mediumImpact();

    // Navigate based on user type
    if (isNewUser) {
      // New users go to auto-assessment
      Navigator.pushReplacementNamed(context, '/auto-assessment-hub');
    } else {
      // Returning users go to dashboard
      Navigator.pushReplacementNamed(context, '/authentication-screen');
    }
  }

  /// Shows error message to user
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Logo
                  _buildLogo(theme),
                  SizedBox(height: 48),

                  // Welcome Text
                  _buildWelcomeText(theme),
                  SizedBox(height: 32),

                  // Tab Selector (Login/Register)
                  _buildTabSelector(theme),
                  SizedBox(height: 32),

                  // Tab Content
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds app logo section
  Widget _buildLogo(ThemeData theme) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: CustomIconWidget(
            iconName: 'fitness_center',
            color: theme.colorScheme.primary,
            size: 64,
          ),
        ),
      ),
    );
  }

  /// Builds welcome text section
  Widget _buildWelcomeText(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Aji Tssourte',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Your journey to better posture starts here',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Builds tab selector for Login/Register
  Widget _buildTabSelector(ThemeData theme) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor:
            theme.colorScheme.onSurface.withValues(alpha: 0.6),
        labelStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Login'),
          Tab(text: 'Register'),
        ],
      ),
    );
  }

  /// Builds tab content (Login/Register forms)
  Widget _buildTabContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          LoginFormWidget(
            onSuccess: () => _handleAuthSuccess(false),
            onError: _showError,
            isLoading: _isLoading,
            onLoadingChanged: (loading) {
              setState(() => _isLoading = loading);
            },
          ),
          RegisterFormWidget(
            onSuccess: () => _handleAuthSuccess(true),
            onError: _showError,
            isLoading: _isLoading,
            onLoadingChanged: (loading) {
              setState(() => _isLoading = loading);
            },
          ),
        ],
      ),
    );
  }
}
