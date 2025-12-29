import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/register_form_widget.dart';

/// Écran d'authentification pour la connexion et l'inscription des utilisateurs
/// Met en œuvre une authentification sécurisée avec validation d'âge (18-30 ans)
/// Propose la prise en charge de l'authentification biométrique et la gestion des jetons JWT
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

  /// Gère l'authentification réussie
  void _handleAuthSuccess(bool isNewUser) {
    HapticFeedback.mediumImpact();

    // Navigation selon le type d'utilisateur
    if (isNewUser) {
      // Les nouveaux utilisateurs vont à l'étape d'introduction
      Navigator.pushReplacementNamed(context, '/onboarding_guide');
    } else {
      // Les utilisateurs existants vont au tableau de bord
      Navigator.pushReplacementNamed(context, '/authentication_screen');
    }
  }

  /// Affiche un message d'erreur à l'utilisateur
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
                  // Logo de l'application
                  _buildLogo(theme),
                  SizedBox(height: 48),

                  // Texte de bienvenue
                  _buildWelcomeText(theme),
                  SizedBox(height: 32),

                  // Sélecteur d'onglets (Connexion/Inscription)
                  _buildTabSelector(theme),
                  SizedBox(height: 32),

                  // Contenu des onglets
                  _buildTabContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Construit la section du logo de l'application
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

  /// Construit la section du texte de bienvenue
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
          'Votre voyage vers une meilleure posture commence ici',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construit le sélecteur d'onglets pour Connexion/Inscription
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
          Tab(text: 'Connexion'),
          Tab(text: 'Inscription'),
        ],
      ),
    );
  }

  /// Construit le contenu des onglets (formulaires de Connexion/Inscription)
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
