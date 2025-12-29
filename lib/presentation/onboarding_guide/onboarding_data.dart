// lib/presentation/onboarding_guide/onboarding_data.dart

import 'package:flutter/material.dart';
import 'onboarding_model.dart';

class OnboardingData {
  static List<OnboardingPage> get pages => [
        OnboardingPage(
          title: 'Réactive ton mouvement avec Aji Tssourte',
          description:
              'Une plateforme digitale pour réactiver ta mobilité en seulement 10-15 minutes par séance, sans matériel.',
          imageAsset: 'assets/onboarding/welcome.png',
          icon: Icons.directions_run,
          color: Colors.blueAccent,
        ),
        OnboardingPage(
          title: 'Exclusivement pour les 18-30 ans',
          description:
              'Programme spécialement conçu pour les jeunes adultes confrontés à la sédentarité, au télétravail et aux douleurs posturales.',
          imageAsset: 'assets/onboarding/target.png',
          icon: Icons.emoji_people,
          color: Colors.greenAccent,
        ),
        OnboardingPage(
          title: 'Auto-bilan initial complet',
          description:
              'Évaluez votre mobilité, stabilité et conscience corporelle grâce à des tests guidés et des questionnaires validés scientifiquement.',
          imageAsset: 'assets/onboarding/assessment.png',
          icon: Icons.analytics,
          color: Colors.orangeAccent,
        ),
        OnboardingPage(
          title: 'Détection des Red Flags',
          description:
              'Notre système détecte automatiquement les signaux d\'alerte (douleur >7/10) pour assurer votre sécurité.',
          imageAsset: 'assets/onboarding/safety.png',
          icon: Icons.warning,
          color: Colors.redAccent,
        ),
        OnboardingPage(
          title: 'Programme 100% personnalisé',
          description:
              'Recevez un plan de 2 à 4 semaines adapté à vos scores : Débutant, Intermédiaire ou Avancé.',
          imageAsset: 'assets/onboarding/personalized.png',
          icon: Icons.person,
          color: Colors.purpleAccent,
        ),
        OnboardingPage(
          title: 'Méthode Conscience → Correction → Intégration',
          description:
              '3 phases progressives pour reprendre confiance en votre corps et intégrer le mouvement dans votre quotidien.',
          imageAsset: 'assets/onboarding/method.png',
          icon: Icons.psychology,
          color: Colors.tealAccent,
        ),
        OnboardingPage(
          title: 'Séances guidées courtes',
          description:
              'Vidéos de 30-90 secondes, audio guidé, timer intégré - parfait pour les emplois du temps chargés.',
          imageAsset: 'assets/onboarding/video.png',
          icon: Icons.video_library,
          color: Colors.deepOrangeAccent,
        ),
        OnboardingPage(
          title: 'Suivi et réévaluation',
          description:
              'Tableau de bord interactif, feedback après chaque séance, et réévaluation automatique toutes les 2 semaines.',
          imageAsset: 'assets/onboarding/progress.png',
          icon: Icons.trending_up,
          color: Colors.indigoAccent,
        ),
        OnboardingPage(
          title: 'Prêt à réactiver votre mobilité ?',
          description:
              'Commençons par le questionnaire IPAQ-SF pour évaluer votre niveau d\'activité physique actuel.',
          imageAsset: 'assets/onboarding/ready.png',
          icon: Icons.play_arrow,
          color: Colors.lightBlueAccent,
          isFinalPage: true,
        ),
      ];

  /// Nombre total de pages
  static int get pageCount => pages.length;

  /// Titre pour le bouton de démarrage (dernière page)
  static String get startButtonText => "Commencer l'auto-bilan";

  /// Sous-titre pour le bouton de démarrage
  static String get startButtonSubtitle => "IPAQ + Tests fonctionnels (15-20 min)";
}
