import 'package:flutter/material.dart';
import '../models/ipaq_question_model.dart';
import '../widgets/ipaq_results_widget.dart';
import '../services/ipaq_scoring_service.dart';

class IpaqViewModel with ChangeNotifier {
  final IpaqScoringService _scoringService = IpaqScoringService();
  
  // Questions IPAQ-SF en français (selon cahier des charges)
  final List<IpaqQuestion> _questions = [
    IpaqQuestion(
      id: 1,
      question: 'Activités intenses',
      description: 'Pendant les 7 derniers jours, combien de jours avez-vous fait des activités physiques INTENSES (course à pied, sports de compétition, cardio intense) ?',
      hint: 'Des activités qui vous font respirer beaucoup plus fort que la normale',
      options: ['0 jour', '1 jour', '2 jours', '3 jours', '4 jours', '5 jours', '6 jours', '7 jours'],
      type: 'frequence',
      unite: 'jours',
    ),
    IpaqQuestion(
      id: 2,
      question: 'Durée activités intenses',
      description: 'Les jours d\'activités intenses, combien de temps en moyenne par jour ?',
      hint: 'En heures et minutes par jour',
      options: ['Moins de 10 minutes', '10-30 minutes', '30-60 minutes', '1 à 2 heures', 'Plus de 2 heures'],
      type: 'duree',
      unite: 'minutes',
    ),
    IpaqQuestion(
      id: 3,
      question: 'Activités modérées',
      description: 'Pendant les 7 derniers jours, combien de jours avez-vous fait des activités physiques MODÉRÉES (vélo lent, yoga léger, natation tranquille) ?',
      hint: 'Des activités qui vous font respirer un peu plus fort que la normale',
      options: ['0 jour', '1 jour', '2 jours', '3 jours', '4 jours', '5 jours', '6 jours', '7 jours'],
      type: 'frequence',
      unite: 'jours',
    ),
    IpaqQuestion(
      id: 4,
      question: 'Durée activités modérées',
      description: 'Les jours d\'activités modérées, combien de temps en moyenne par jour ?',
      hint: 'En heures et minutes par jour',
      options: ['Moins de 10 minutes', '10-30 minutes', '30-60 minutes', '1 à 2 heures', 'Plus de 2 heures'],
      type: 'duree',
      unite: 'minutes',
    ),
    IpaqQuestion(
      id: 5,
      question: 'Marche',
      description: 'Pendant les 7 derniers jours, combien de jours avez-vous marché au moins 10 minutes d\'affilée ?',
      hint: 'Inclure la marche au travail, à la maison, pour les déplacements',
      options: ['0 jour', '1 jour', '2 jours', '3 jours', '4 jours', '5 jours', '6 jours', '7 jours'],
      type: 'frequence',
      unite: 'jours',
    ),
    IpaqQuestion(
      id: 6,
      question: 'Durée marche',
      description: 'Les jours où vous avez marché, combien de temps en moyenne par jour ?',
      hint: 'En heures et minutes par jour',
      options: ['Moins de 10 minutes', '10-30 minutes', '30-60 minutes', '1 à 2 heures', 'Plus de 2 heures'],
      type: 'duree',
      unite: 'minutes',
    ),
    IpaqQuestion(
      id: 7,
      question: 'Temps assis',
      description: 'En moyenne, combien d\'heures par jour passez-vous ASSIS pendant la semaine (bureau, transport, maison, repas) ?',
      hint: 'Inclure le temps au travail, à la maison, pendant les études et les loisirs',
      options: ['Moins de 4 heures', '4 à 6 heures', '6 à 8 heures', '8 à 10 heures', 'Plus de 10 heures'],
      type: 'duree',
      unite: 'heures',
    ),
  ];

  // État (privé)
  int _currentQuestionIndex = 0;
  Map<int, dynamic> _reponses = {};
  bool _envoiEnCours = false;
  IpaqResult? _resultats;
  

  // Getters publics
  List<IpaqQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  IpaqQuestion get currentQuestion => _questions[_currentQuestionIndex];
  int get totalQuestions => _questions.length;
  double get progression => (_currentQuestionIndex + 1) / _questions.length;
  bool get isSubmitting => _envoiEnCours;
  IpaqResult? get results => _resultats;
  bool get isCompleted => _currentQuestionIndex >= _questions.length;
  
  // Getter pour une réponse spécifique
  dynamic getResponse(int questionId) {
    return _reponses[questionId];
  }
  
  // Méthodes de conversion
  double _convertirDureeEnMinutes(dynamic valeur) {
    if (valeur is String) {
      switch (valeur) {
        case 'Moins de 10 minutes':
          return 5.0;
        case '10-30 minutes':
          return 20.0;
        case '30-60 minutes':
          return 45.0;
        case '1 à 2 heures':
          return 90.0;
        case 'Plus de 2 heures':
          return 150.0;
      }
    }
    return 0.0;
  }
  
  double _convertirTempsAssisEnMinutes(dynamic valeur) {
    if (valeur is String) {
      switch (valeur) {
        case 'Moins de 4 heures':
          return 180.0; // 3 heures
        case '4 à 6 heures':
          return 300.0; // 5 heures
        case '6 à 8 heures':
          return 420.0; // 7 heures
        case '8 à 10 heures':
          return 540.0; // 9 heures
        case 'Plus de 10 heures':
          return 660.0; // 11 heures
      }
    }
    return 0.0;
  }

  // Méthodes
  void answerQuestion(dynamic value) {
    _reponses[currentQuestion.id] = value;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  Future<void> submitAssessment() async {
    if (_reponses.length < _questions.length) {
      throw Exception('Veuillez répondre à toutes les questions');
    }

    _envoiEnCours = true;
    notifyListeners();

    try {
      // Convertir les réponses pour le scoring
      final reponsesTraitees = _traiterReponses();
      
      // Calculer les scores
      _resultats = await _scoringService.calculerScoresIpaq(reponses: reponsesTraitees);
      
      // Simuler un délai d'API
      await Future.delayed(const Duration(seconds: 1));
      
      notifyListeners();
    } finally {
      _envoiEnCours = false;
      notifyListeners();
    }
  }

  Map<String, dynamic> _traiterReponses() {
    final traitees = <String, dynamic>{};
    
    for (var entree in _reponses.entries) {
      final questionId = entree.key;
      final valeur = entree.value;
      
      switch (questionId) {
        case 1: // Jours activités intenses
          traitees['jours_intenses'] = _extraireNombreJours(valeur);
          break;
        case 2: // Minutes activités intenses
          traitees['minutes_intenses'] = _convertirDureeEnMinutes(valeur);
          break;
        case 3: // Jours activités modérées
          traitees['jours_moderes'] = _extraireNombreJours(valeur);
          break;
        case 4: // Minutes activités modérées
          traitees['minutes_moderes'] = _convertirDureeEnMinutes(valeur);
          break;
        case 5: // Jours marche
          traitees['jours_marche'] = _extraireNombreJours(valeur);
          break;
        case 6: // Minutes marche
          traitees['minutes_marche'] = _convertirDureeEnMinutes(valeur);
          break;
        case 7: // Minutes assis
          traitees['minutes_assis'] = _convertirTempsAssisEnMinutes(valeur);
          break;
      }
    }
    
    return traitees;
  }

  int _extraireNombreJours(dynamic valeur) {
    if (valeur is String) {
      // Extraire le nombre depuis "0 jour", "1 jour", etc.
      final match = RegExp(r'(\d+)').firstMatch(valeur);
      if (match != null) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return 0;
  }

  void reset() {
    _currentQuestionIndex = 0;
    _reponses.clear();
    _resultats = null;
    notifyListeners();
  }

  // Méthode pour convertir en JSON (utile pour le retour au parent)
  Map<String, dynamic> toJson() {
    if (_resultats == null) {
      return {
        'ipaqComplete': false,
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
    
    return {
      'ipaqComplete': true,
      'timestamp': DateTime.now().toIso8601String(),
      'niveauActivite': _resultats!.niveauActivite.name,
      'descriptionNiveau': _resultats!.descriptionNiveau,
      'scoreMET': _resultats!.scoreMET,
      'recommendations': _resultats!.recommandations,
      'details': {
        'jours_intenses': _resultats!.details['jours_intenses'] ?? 0,
        'minutes_intenses': _resultats!.details['minutes_intenses'] ?? 0,
        'jours_moderes': _resultats!.details['jours_moderes'] ?? 0,
        'minutes_moderes': _resultats!.details['minutes_moderes'] ?? 0,
        'jours_marche': _resultats!.details['jours_marche'] ?? 0,
        'minutes_marche': _resultats!.details['minutes_marche'] ?? 0,
        'minutes_assis': _resultats!.details['minutes_assis'] ?? 0,
      },
    };
  }

  // Méthode pour savoir si une question est répondue
  bool isQuestionAnswered(int questionId) {
    return _reponses.containsKey(questionId) && _reponses[questionId] != null;
  }
}
