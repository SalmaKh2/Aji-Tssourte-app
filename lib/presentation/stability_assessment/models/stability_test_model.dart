import 'package:flutter/material.dart';

class StabilityTest {
  final String id;
  final String title;
  final String subtitle;
  final String instruction;
  final int duration; // en secondes
  final List<String> scoringCriteria;
  final String? videoAsset;
  final String? videoUrl;
  final String? thumbnail;
  final IconData icon;
  final Color color;
  final List<String> tips;

  StabilityTest({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.instruction,
    required this.duration,
    required this.scoringCriteria,
    this.videoAsset,
    this.videoUrl,
    this.thumbnail,
    required this.icon,
    required this.color,
    required this.tips,
  });
}

class StabilityTestResult {
  final String testId;
  final double tempsTenue; // pour équilibre (secondes)
  final double stabilite;  // 0-10
  final double controle;   // 0-10
  final double alignement; // 0-10
  final double douleur;    // 0-10

  StabilityTestResult({
    required this.testId,
    this.tempsTenue = 0,
    this.stabilite = 0,
    this.controle = 0,
    this.alignement = 0,
    this.douleur = 0,
  });
}

class StabilityQuestion {
  final String id;
  final String question;
  final String description;
  final String emoji;
  final bool inverse;

  StabilityQuestion({
    required this.id,
    required this.question,
    required this.description,
    required this.emoji,
    this.inverse = false,
  });
}

class StabilityResult {
  final double scoreStabilite;
  final double scoreControle;
  final double scoreAlignement;
  final double scoreGlobal;
  final Map<String, StabilityTestResult> testResults;
  final Map<String, int> questionnaireResults;
  final DateTime timestamp;

  StabilityResult({
    required this.scoreStabilite,
    required this.scoreControle,
    required this.scoreAlignement,
    required this.scoreGlobal,
    required this.testResults,
    required this.questionnaireResults,
    required this.timestamp,
  });

  String get niveauStabilite {
    if (scoreGlobal >= 8) return "Excellente";
    if (scoreGlobal >= 6) return "Bonne";
    if (scoreGlobal >= 4) return "Moyenne";
    return "À améliorer";
  }

  String get recommendations {
    if (scoreGlobal >= 8) {
      return "Votre stabilité est excellente ! Continuez à pratiquer pour maintenir ce niveau.";
    } else if (scoreGlobal >= 6) {
      return "Votre stabilité est bonne. Travaillez l'équilibre unipodal pour progresser.";
    } else if (scoreGlobal >= 4) {
      return "Votre stabilité nécessite du travail. Concentrez-vous sur les exercices de contrôle du genou.";
    } else {
      return "Commencez par des exercices de stabilité de base. Priorisez la sécurité.";
    }
  }
}
