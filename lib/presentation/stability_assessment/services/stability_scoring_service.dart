import '../models/stability_test_model.dart';

class StabilityScoringService {
  // Calculer le score de stabilité selon le cahier des charges
  StabilityResult calculateStabilityScore({
    required Map<String, StabilityTestResult> testResults,
    required Map<String, int> questionnaireResults,
  }) {
    // 1. Calculer les scores des tests pratiques
    double scoreStabilite = 0;
    double scoreControle = 0;
    double scoreAlignement = 0;
    double totalDouleur = 0;
    int testCount = testResults.length;

    testResults.forEach((testId, result) {
      // Pour le test d'équilibre : temps tenu converti en score 0-10
      if (testId == 'equilibre') {
        scoreStabilite += (result.tempsTenue / 30) * 10; // 30s max = 10/10
      } else {
        scoreStabilite += result.stabilite;
      }
      
      scoreControle += result.controle;
      scoreAlignement += result.alignement;
      totalDouleur += result.douleur;
    });

    // Moyennes
    scoreStabilite = testCount > 0 ? scoreStabilite / testCount : 0;
    scoreControle = testCount > 0 ? scoreControle / testCount : 0;
    scoreAlignement = testCount > 0 ? scoreAlignement / testCount : 0;
    double moyenneDouleur = testCount > 0 ? totalDouleur / testCount : 0;

    // 2. Calculer le score du questionnaire
    double scoreQuestionnaire = 0;
    int questionCount = questionnaireResults.length;

    questionnaireResults.forEach((questionId, value) {
      // Identifier si c'est une question inverse
      bool isInverse = questionId.contains('inverse');
      double adjustedValue = isInverse ? (4 - value).toDouble() : value.toDouble();
      scoreQuestionnaire += adjustedValue * 2.5; // Convertir 0-4 → 0-10
    });

    scoreQuestionnaire = questionCount > 0 ? scoreQuestionnaire / questionCount : 0;

    // 3. Score global = 70% tests pratiques + 30% questionnaire
    // Réduction si douleur moyenne > 3
    double reductionDouleur = moyenneDouleur > 3 ? (moyenneDouleur - 3) * 0.5 : 0;
    double scorePratique = (scoreStabilite + scoreControle + scoreAlignement) / 3;
    scorePratique = scorePratique - reductionDouleur;
    if (scorePratique < 0) scorePratique = 0;

    double scoreGlobal = (scorePratique * 0.7) + (scoreQuestionnaire * 0.3);

    return StabilityResult(
      scoreStabilite: scoreStabilite,
      scoreControle: scoreControle,
      scoreAlignement: scoreAlignement,
      scoreGlobal: scoreGlobal,
      testResults: testResults,
      questionnaireResults: questionnaireResults,
      timestamp: DateTime.now(),
    );
  }

  // Générer des recommandations personnalisées
  List<String> generateRecommendations(StabilityResult result) {
    final recommendations = <String>[];

    // Recommandations basées sur le score global
    if (result.scoreGlobal < 4) {
      recommendations.addAll([
        'Commencez par des exercices d\'équilibre avec support (mur, chaise)',
        'Pratiquez 5 minutes par jour',
        'Concentrez-vous sur la sécurité avant la performance',
      ]);
    } else if (result.scoreGlobal < 6) {
      recommendations.addAll([
        'Travaillez l\'équilibre unipodal 3 fois par semaine',
        'Ajoutez des exercices de contrôle du genou',
        'Pratiquez le mini-squat avec un miroir pour surveiller l\'alignement',
      ]);
    } else if (result.scoreGlobal < 8) {
      recommendations.addAll([
        'Maintenez votre routine actuelle',
        'Ajoutez des défis d\'équilibre (yeux fermés, surface instable)',
        'Travaillez la stabilité dynamique avec des mouvements fonctionnels',
      ]);
    } else {
      recommendations.addAll([
        'Continuez à varier vos exercices de stabilité',
        'Explorez des activités comme le yoga ou le Pilates',
        'Intégrez la stabilité dans vos activités sportives',
      ]);
    }

    // Recommandations spécifiques basées sur les résultats des tests
    if (result.testResults.containsKey('equilibre')) {
      final equilibreResult = result.testResults['equilibre']!;
      if (equilibreResult.tempsTenue < 15) {
        recommendations.add('Augmentez progressivement le temps d\'équilibre unipodal');
      }
    }

    if (result.testResults.containsKey('controle_genou')) {
      final controleResult = result.testResults['controle_genou']!;
      if (controleResult.alignement < 6) {
        recommendations.add('Travaillez spécifiquement l\'alignement du genou pendant le squat');
      }
    }

    // Vérifier la douleur
    double douleurMoyenne = 0;
    result.testResults.forEach((key, value) {
      douleurMoyenne += value.douleur;
    });
    douleurMoyenne = douleurMoyenne / result.testResults.length;

    if (douleurMoyenne > 3) {
      recommendations.add('Réduisez l\'intensité si vous ressentez des douleurs > 3/10');
    }

    return recommendations;
  }
}
