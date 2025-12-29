import '../widgets/ipaq_results_widget.dart';

class IpaqScoringService {
  Future<IpaqResult> calculerScoresIpaq({
    required Map<String, dynamic> reponses,
  }) async {
    // Extraire les valeurs
    final joursIntenses = (reponses['jours_intenses'] as int?) ?? 0;
    final minutesIntenses = (reponses['minutes_intenses'] as double?) ?? 0.0;
    final joursModeres = (reponses['jours_moderes'] as int?) ?? 0;
    final minutesModeres = (reponses['minutes_moderes'] as double?) ?? 0.0;
    final joursMarche = (reponses['jours_marche'] as int?) ?? 0;
    final minutesMarche = (reponses['minutes_marche'] as double?) ?? 0.0;
    final minutesAssis = (reponses['minutes_assis'] as double?) ?? 0.0;

    // Calculer le score MET selon l'algorithme IPAQ
    final metIntenses = joursIntenses * minutesIntenses * 8.0;
    final metModeres = joursModeres * minutesModeres * 4.0;
    final metMarche = joursMarche * minutesMarche * 3.3;
    
    final scoreMETTotal = metIntenses + metModeres + metMarche;

    // Déterminer le niveau d'activité
    final niveauActivite = _determinerNiveauActivite(
      joursIntenses: joursIntenses,
      minutesIntenses: minutesIntenses,
      joursModeres: joursModeres,
      minutesModeres: minutesModeres,
      joursMarche: joursMarche,
      minutesMarche: minutesMarche,
      scoreMET: scoreMETTotal,
    );

    // Générer les recommandations
    final recommandations = _genererRecommandations(niveauActivite, minutesAssis);

    return IpaqResult(
      niveauActivite: niveauActivite,
      scoreMET: scoreMETTotal,
      recommandations: recommandations,
      details: {
        'jours_intenses': joursIntenses,
        'minutes_intenses': minutesIntenses,
        'jours_moderes': joursModeres,
        'minutes_moderes': minutesModeres,
        'jours_marche': joursMarche,
        'minutes_marche': minutesMarche,
        'minutes_assis': minutesAssis,
        'met_intenses': metIntenses,
        'met_moderes': metModeres,
        'met_marche': metMarche,
      },
    );
  }

  NiveauActivite _determinerNiveauActivite({
    required int joursIntenses,
    required double minutesIntenses,
    required int joursModeres,
    required double minutesModeres,
    required int joursMarche,
    required double minutesMarche,
    required double scoreMET,
  }) {
    // Catégorisation selon IPAQ-SF guidelines
    final joursActiviteVigoureuse = joursIntenses * (minutesIntenses >= 10 ? 1 : 0);
    final joursActiviteModeree = joursModeres * (minutesModeres >= 10 ? 1 : 0);
    final joursActiviteMarche = joursMarche * (minutesMarche >= 10 ? 1 : 0);

    final totalJoursActivite = joursActiviteVigoureuse + 
                              joursActiviteModeree + 
                              joursActiviteMarche;

    // Règles de catégorisation
    if (scoreMET < 600) {
      return NiveauActivite.sedentaire;
    } else if (scoreMET < 3000) {
      return NiveauActivite.faible;
    } else if (joursActiviteVigoureuse >= 3 || 
               totalJoursActivite >= 7 || 
               scoreMET >= 3000) {
      return NiveauActivite.eleve;
    } else {
      return NiveauActivite.modere;
    }
  }

  List<String> _genererRecommandations(NiveauActivite niveau, double minutesAssis) {
    final recommandations = <String>[];

    switch (niveau) {
      case NiveauActivite.sedentaire:
        recommandations.addAll([
          'Commencez par 2-3 séances courtes de 10-15 minutes par semaine',
          'Intégrez la marche dans votre quotidien (pause active toutes les heures)',
          'Réduisez le temps assis de 30 minutes par jour',
        ]);
        break;
      case NiveauActivite.faible:
        recommandations.addAll([
          'Augmentez progressivement à 3-4 séances de 15-20 minutes',
          'Variez les activités (mobilité, stabilité, renforcement léger)',
          'Prenez des pauses actives toutes les 45 minutes',
        ]);
        break;
      case NiveauActivite.modere:
        recommandations.addAll([
          'Maintenez votre routine actuelle',
          'Ajoutez des exercices de mobilité spécifiques',
          'Travaillez la qualité du mouvement',
        ]);
        break;
      case NiveauActivite.eleve:
        recommandations.addAll([
          'Concentrez-vous sur la récupération et la mobilité',
          'Équilibrez activité intense avec étirements',
          'Pratiquez la pleine conscience du mouvement',
        ]);
        break;
    }

    // Recommandation spécifique au temps assis
    if (minutesAssis > 480) { // Plus de 8 heures
      recommandations.add('Essayez de réduire votre temps assis de 1 heure par jour');
    }

    return recommandations;
  }
}
