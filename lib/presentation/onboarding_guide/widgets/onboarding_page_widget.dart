// lib/presentation/onboarding_guide/onboarding_page_widget.dart

import 'package:flutter/material.dart';
import '../onboarding_model.dart';
import '../onboarding_data.dart';

/// Widget pour afficher une page individuelle d'onboarding - VERSION AJI TSSOURTE
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isLastPage;
  final VoidCallback? onStartPressed;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    this.isLastPage = false,
    this.onStartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image/Icon Section
          _buildImageSection(theme, isDarkMode),
          const SizedBox(height: 40),

          // Title
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              page.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                height: 1.6,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),

          // Contenu spécifique pour la dernière page
          if (page.isFinalPage) _buildFinalPageContent(context, theme),

          // Page Indicators (only if not last page)
          if (!isLastPage && !page.isFinalPage) _buildPageIndicator(theme),
        ],
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme, bool isDarkMode) {
    return Container(
      width: 220,
      height: 220,
      decoration: BoxDecoration(
        color: page.color?.withOpacity(0.15) ??
            theme.colorScheme.primary.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: page.color?.withOpacity(0.3) ??
              theme.colorScheme.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: page.icon != null
            ? Icon(
                page.icon,
                size: 110,
                color: page.color ?? theme.colorScheme.primary,
              )
            : ClipOval(
                child: Image.asset(
                  page.imageAsset,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: page.color ?? theme.colorScheme.primary,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildPageIndicator(ThemeData theme) {
    return Container(
      height: 6,
      width: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: Container(
          height: 4,
          width: 30,
          decoration: BoxDecoration(
            color: page.color ?? theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildFinalPageContent(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        // Badge "MVP Version 1.0"
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified,
                size: 16,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 8),
              Text(
                'MVP Version 1.0 - Novembre 2025',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Bouton de démarrage
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onStartPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
            ),
            child: Column(
              children: [
                Text(
                  OnboardingData.startButtonText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  OnboardingData.startButtonSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Note de sécurité
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orangeAccent.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.medical_services,
                color: Colors.orangeAccent,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ce programme est non-médical. En cas de douleur intense (>7/10), consultez un professionnel de santé.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
