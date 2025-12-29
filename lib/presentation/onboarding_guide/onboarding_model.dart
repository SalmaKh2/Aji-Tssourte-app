// lib/presentation/onboarding_guide/onboarding_model.dart

import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final String imageAsset;
  final IconData? icon;
  final Color? color;
  final bool isFinalPage; // Indique si c'est la dernière page (avec bouton d'action)

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imageAsset,
    this.icon,
    this.color,
    this.isFinalPage = false,
  });
}
