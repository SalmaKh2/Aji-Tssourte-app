// lib/presentation/onboarding_guide/onboarding_guide_screen.dart

import 'package:flutter/material.dart';
import 'onboarding_data.dart';
import 'widgets/onboarding_page_widget.dart';

/// Écran de guide d'onboarding pour les nouveaux utilisateurs
class OnboardingGuideScreen extends StatefulWidget {
  const OnboardingGuideScreen({super.key});

  @override
  State<OnboardingGuideScreen> createState() => _OnboardingGuideScreenState();
}

class _OnboardingGuideScreenState extends State<OnboardingGuideScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Aller à la page suivante
  void _nextPage() {
    if (_currentPageIndex < OnboardingData.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _startAssessment();
    }
  }

  /// Aller à la page précédente
  void _previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Commencer l'évaluation IPAQ
  void _startAssessment() {
    Navigator.pushReplacementNamed(context, '/auto-assessment-hub');
  }

  /// Passer directement à l'évaluation
  void _skipOnboarding() {
    _startAssessment();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPageIndex == OnboardingData.pages.length - 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button (en haut à droite)
            if (_currentPageIndex < OnboardingData.pages.length - 1)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Passer',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: OnboardingData.pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    page: OnboardingData.pages[index],
                    isLastPage: index == OnboardingData.pages.length - 1,
                  );
                },
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  if (_currentPageIndex > 0)
                    OutlinedButton(
                      onPressed: _previousPage,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Retour',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const SizedBox(width: 100),

                  // Page Indicator
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      OnboardingData.pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPageIndex == index
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surfaceVariant,
                        ),
                      ),
                    ),
                  ),

                  // Next/Start Button
                  ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isLastPage ? 'Commencer' : 'Suivant',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (!isLastPage) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
