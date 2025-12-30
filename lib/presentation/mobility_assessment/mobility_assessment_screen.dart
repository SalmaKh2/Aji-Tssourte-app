import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:confetti/confetti.dart'; // Pour l'animation de célébration
import 'dart:async';

/// Écran innovant et interactif pour le Bilan Mobilité
/// Avec interface motivante, animations et guidage étape par étape
class MobilityAssessmentScreen extends StatefulWidget {
  const MobilityAssessmentScreen({super.key});

  @override
  State<MobilityAssessmentScreen> createState() => _MobilityAssessmentScreenState();
}

class _MobilityAssessmentScreenState extends State<MobilityAssessmentScreen> {
  late ConfettiController _confettiController;
  int _currentStep = 0;
  bool _isTestActive = false;
  int _remainingTime = 0;
  Timer? _timer;
  
  // Résultats des tests
  final Map<String, Map<String, double>> _testResults = {};
  final Map<String, int> _questionnaireResults = {};

  // Tests de mobilité selon cahier des charges
  final List<Map<String, dynamic>> _mobilityTests = [
    {
      "id": "cheville",
      "title": "🦶 Mobilité Cheville",
      "subtitle": "Test de dorsiflexion",
      "instruction": "Placez-vous face à un mur. Avancez un pied et tentez de toucher le mur avec votre genou tout en gardant le talon au sol.",
      "duration": 30,
      "icon": Icons.directions_walk,
      "color": Color(0xFF4CAF50),
      "tips": [
        "Gardez le dos droit",
        "Ne forcez pas si douleur",
        "Testez les deux côtés"
      ]
    },
    {
      "id": "hanche",
      "title": "🦵 Mobilité Hanche",
      "subtitle": "Test de flexion/rotation",
      "instruction": "Allongé sur le dos, amenez un genou vers votre poitrine en gardant l'autre jambe tendue au sol.",
      "duration": 30,
      "icon": Icons.directions_run,
      "color": Color(0xFF2196F3),
      "tips": [
        "Respirez profondément",
        "Maintenez 10 secondes",
        "Changez de côté"
      ]
    },
    {
      "id": "epaules",
      "title": "💪 Mobilité Épaules",
      "subtitle": "Test de flexion/abduction",
      "instruction": "Dos contre un mur, levez les bras au-dessus de la tête en essayant de toucher le mur avec vos mains.",
      "duration": 30,
      "icon": Icons.fitness_center,
      "color": Color(0xFFFF9800),
      "tips": [
        "Gardez les coudes tendus",
        "Allez à votre rythme",
        "Pas de mouvement brusque"
      ]
    },
    {
      "id": "rachis",
      "title": "🧘 Mobilité Rachis",
      "subtitle": "Test de flexion/extension/rotation",
      "instruction": "Assis sur une chaise, tournez doucement le haut du corps à droite, puis à gauche, en gardant les hanches stables.",
      "duration": 30,
      "icon": Icons.self_improvement,
      "color": Color(0xFF9C27B0),
      "tips": [
        "Mouvement lent et contrôlé",
        "Regardez dans la direction de la rotation",
        "Expirez en tournant"
      ]
    }
  ];

  // Questionnaire mobilité
  final List<Map<String, dynamic>> _mobilityQuestionnaire = [
    {
      "id": "q1",
      "question": "Me pencher en avant sans gêne",
      "description": "Pour ramasser un objet au sol",
      "emoji": "👇"
    },
    {
      "id": "q2", 
      "question": "M'accroupir sans douleur",
      "description": "Comme pour chercher quelque chose en bas",
      "emoji": "🧎"
    },
    {
      "id": "q3",
      "question": "Tourner mon tronc aisément",
      "description": "Pour regarder derrière moi en voiture",
      "emoji": "↩️"
    },
    {
      "id": "q4",
      "question": "Lever les bras au-dessus de ma tête",
      "description": "Pour prendre un objet en hauteur",
      "emoji": "👆"
    },
    {
      "id": "q5",
      "question": "Sensation de raideur au réveil",
      "description": "Fréquence des raideurs matinales",
      "emoji": "🌅",
      "inverse": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      _isTestActive = true;
      _remainingTime = _mobilityTests[_currentStep]["duration"] as int;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        _completeTest();
      }
    });
  }

  void _completeTest() {
    _timer?.cancel();
    setState(() => _isTestActive = false);
    
    // Afficher le formulaire de notation
    _showScoringDialog(_currentStep);
  }

  void _showScoringDialog(int testIndex) {
    final test = _mobilityTests[testIndex];
    final scores = {
      'Amplitude': 5.0,
      'Facilité': 5.0,
      'Douleur': 0.0,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Column(
            children: [
              Icon(test['icon'] as IconData, color: test['color'] as Color, size: 40),
              SizedBox(height: 10),
              Text(test['title'] as String, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Comment s'est passé le test ?", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              
              // Slider Amplitude
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("📐 Amplitude", style: TextStyle(fontWeight: FontWeight.w500)),
                      Text("${scores['Amplitude']!.toInt()}/10"),
                    ],
                  ),
                  Slider(
                    value: scores['Amplitude']!,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: scores['Amplitude']!.toStringAsFixed(0),
                    onChanged: (value) => setState(() => scores['Amplitude'] = value),
                  ),
                ],
              ),
              
              // Slider Facilité
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("😌 Facilité", style: TextStyle(fontWeight: FontWeight.w500)),
                      Text("${scores['Facilité']!.toInt()}/10"),
                    ],
                  ),
                  Slider(
                    value: scores['Facilité']!,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: scores['Facilité']!.toStringAsFixed(0),
                    onChanged: (value) => setState(() => scores['Facilité'] = value),
                  ),
                ],
              ),
              
              // Slider Douleur
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("⚠️ Douleur", style: TextStyle(fontWeight: FontWeight.w500)),
                      Text("${scores['Douleur']!.toInt()}/10"),
                    ],
                  ),
                  Slider(
                    value: scores['Douleur']!,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: scores['Douleur']!.toStringAsFixed(0),
                    onChanged: (value) => setState(() => scores['Douleur'] = value),
                  ),
                  if (scores['Douleur']! > 7)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "⚠️ Douleur élevée détectée",
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                _testResults[test['id'] as String] = {
                  'Amplitude': scores['Amplitude']!,
                  'Facilité': scores['Facilité']!,
                  'Douleur': scores['Douleur']!,
                };
                Navigator.pop(context);
                _nextStep();
              },
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _mobilityTests.length - 1) {
      setState(() => _currentStep++);
    } else if (_currentStep == _mobilityTests.length - 1) {
      // Passer au questionnaire
      setState(() => _currentStep++);
    } else if (_currentStep < _mobilityTests.length + _mobilityQuestionnaire.length - 1) {
      setState(() => _currentStep++);
    } else {
      // Terminer
      _completeAssessment();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _setQuestionnaireAnswer(int questionIndex, int value) {
    final question = _mobilityQuestionnaire[questionIndex - _mobilityTests.length];
    _questionnaireResults[question['id'] as String] = value;
  }

  void _completeAssessment() {
    _confettiController.play();
    
    // Calculer le score final
    final mobilityScore = _calculateMobilityScore();
    
    // Préparer les résultats
    final results = {
      'mobilityScore': mobilityScore,
      'testResults': _testResults,
      'questionnaireResults': _questionnaireResults,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Afficher les résultats avec animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildResultsDialog(mobilityScore, results),
    );
  }

  double _calculateMobilityScore() {
    // Calcul selon cahier des charges
    double practicalScore = 0;
    int testCount = 0;
    
    _testResults.forEach((key, scores) {
      // Moyenne amplitude + facilité (douleur n'est pas positive)
      practicalScore += (scores['Amplitude']! + scores['Facilité']!) / 2;
      testCount++;
    });
    
    practicalScore = testCount > 0 ? (practicalScore / testCount) : 0;
    
    // Score questionnaire (0-4 → 0-10)
    double questionnaireScore = 0;
    int questionCount = 0;
    
    _questionnaireResults.forEach((key, value) {
      final question = _mobilityQuestionnaire.firstWhere((q) => q['id'] == key);
      final isInverse = question['inverse'] == true;
      final adjustedValue = isInverse ? 4 - value : value;
      questionnaireScore += adjustedValue * 2.5; // Convertir 0-4 → 0-10
      questionCount++;
    });
    
    questionnaireScore = questionCount > 0 ? (questionnaireScore / questionCount) : 0;
    
    // Score final = moyenne des deux
    return (practicalScore + questionnaireScore) / 2;
  }

  Widget _buildResultsDialog(double score, Map<String, dynamic> results) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.orange, Colors.purple],
            ),
            Icon(Icons.celebration, size: 60, color: Colors.amber),
            SizedBox(height: 20),
            Text("🎉 Bilan Mobilité Terminé !", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Votre score de mobilité", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _getScoreColor(score),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text("${score.toStringAsFixed(1)}", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("/10", style: TextStyle(fontSize: 20, color: Colors.white70)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(_getScoreMessage(score), textAlign: TextAlign.center),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fermer le dialog
                  Navigator.pop(context, results); // Retourner les résultats
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Continuer", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return Colors.green;
    if (score >= 6) return Colors.blue;
    if (score >= 4) return Colors.orange;
    return Colors.red;
  }

  String _getScoreMessage(double score) {
    if (score >= 8) return "Excellent ! Votre mobilité est très bonne. Continuez à entretenir vos articulations.";
    if (score >= 6) return "Bon ! Votre mobilité est satisfaisante. Quelques améliorations possibles.";
    if (score >= 4) return "Moyen. Nous allons travailler spécifiquement sur votre mobilité.";
    return "À améliorer. Nous allons créer un programme pour booster votre mobilité.";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSteps = _mobilityTests.length + _mobilityQuestionnaire.length;
    final progress = (_currentStep + 1) / totalSteps;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bilan Mobilité'),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            minHeight: 4,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  if (_currentStep < _mobilityTests.length)
                    _buildTestView()
                  else if (_currentStep < totalSteps)
                    _buildQuestionnaireView()
                  else
                    _buildCompletionView(),
                ],
              ),
            ),
          ),
          
          // Navigation buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: Text('Précédent'),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < _mobilityTests.length && !_isTestActive) {
                        _startTest();
                      } else if (_currentStep >= _mobilityTests.length && _currentStep < totalSteps - 1) {
                        _nextStep();
                      } else if (_currentStep == totalSteps - 1) {
                        _completeAssessment();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text(_getActionButtonText()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestView() {
    final test = _mobilityTests[_currentStep];
    final color = test['color'] as Color;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Test header
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(test['icon'] as IconData, color: color, size: 32),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test['title'] as String,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          test['subtitle'] as String,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    label: Text('${_currentStep + 1}/${_mobilityTests.length}'),
                    backgroundColor: color.withOpacity(0.2),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              
              // Timer or instruction
              if (_isTestActive)
                _buildTimerWidget(test)
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instructions',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      test['instruction'] as String,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
            ],
          ),
        ),
        
        SizedBox(height: 3.h),
        
        // Tips
        if (!_isTestActive)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💡 Conseils',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              ...(test['tips'] as List<String>).map((tip) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    SizedBox(width: 2.w),
                    Expanded(child: Text(tip)),
                  ],
                ),
              )).toList(),
            ],
          ),
      ],
    );
  }

  Widget _buildTimerWidget(Map<String, dynamic> test) {
    return Column(
      children: [
        Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: test['color'] as Color,
          ),
          child: Center(
            child: Text(
              '$_remainingTime',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'En cours...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.h),
        Text(
          test['instruction'] as String,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildQuestionnaireView() {
    final questionIndex = _currentStep - _mobilityTests.length;
    final question = _mobilityQuestionnaire[questionIndex];
    final currentAnswer = _questionnaireResults[question['id']];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📝 Questionnaire Mobilité',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 1.h),
        Text(
          'Question ${questionIndex + 1}/${_mobilityQuestionnaire.length}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 3.h),
        
        // Question
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                question['emoji'] as String,
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(height: 2.h),
              Text(
                question['question'] as String,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Text(
                question['description'] as String,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 4.h),
        
        // Scale
        Text(
          'Échelle : 0 (impossible) à 4 (très facile)',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 2.h),
        
        // Rating buttons
        Wrap(
          spacing: 2.w,
          runSpacing: 2.w,
          children: List.generate(5, (index) {
            final isSelected = currentAnswer == index;
            return ChoiceChip(
              label: Text(
                index == 0 ? '0\nImpossible' : 
                index == 1 ? '1\nTrès difficile' :
                index == 2 ? '2\nDifficile' :
                index == 3 ? '3\nFacile' : '4\nTrès facile',
                textAlign: TextAlign.center,
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _setQuestionnaireAnswer(questionIndex, index);
                });
              },
              selectedColor: Colors.blue,
              labelStyle: TextStyle(color: isSelected ? Colors.white : null),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            );
          }),
        ),
        
        SizedBox(height: 2.h),
        
        if (question['inverse'] == true)
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.orange),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Pour cette question, 0 est le meilleur score (jamais de raideur)',
                    style: TextStyle(fontSize: 12, color: Colors.orange[800]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Column(
      children: [
        Icon(Icons.check_circle, size: 80, color: Colors.green),
        SizedBox(height: 3.h),
        Text(
          'Questionnaire terminé !',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 2.h),
        Text(
          'Cliquez sur "Terminer" pour calculer votre score de mobilité.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  String _getActionButtonText() {
    if (_currentStep < _mobilityTests.length) {
      return _isTestActive ? 'Terminer le test' : 'Démarrer le test';
    } else if (_currentStep < _mobilityTests.length + _mobilityQuestionnaire.length - 1) {
      return 'Question suivante';
    } else {
      return 'Terminer l\'évaluation';
    }
  }
}
