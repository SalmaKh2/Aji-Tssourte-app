import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:confetti/confetti.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import './models/stability_test_model.dart';
import './services/stability_scoring_service.dart';
import './widgets/stability_test_card.dart';
import './widgets/stability_timer_widget.dart';
import './widgets/stability_questionnaire.dart';
import './widgets/stability_results_widget.dart';

/// Écran principal pour le Bilan Stabilité
/// Tests pratiques vidéo-guidés + questionnaire
class StabilityAssessmentScreen extends StatefulWidget {
  const StabilityAssessmentScreen({super.key});

  @override
  State<StabilityAssessmentScreen> createState() => _StabilityAssessmentScreenState();
}

class _StabilityAssessmentScreenState extends State<StabilityAssessmentScreen> {
  late ConfettiController _confettiController;
  int _currentStep = 0;
  bool _isTestActive = false;
  bool _showResults = false;
  
  // Contrôleurs vidéo
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  
  // Données des tests
  final List<StabilityTest> _tests = [
    StabilityTest(
      id: 'equilibre',
      title: '⚖️ Équilibre Unipodal',
      subtitle: 'Test d\'équilibre statique',
      instruction: 'Tenez-vous sur une jambe avec vos mains sur vos hanches. Essayez de maintenir l\'équilibre pendant 30 secondes sans bouger.',
      duration: 30,
      scoringCriteria: ['Temps tenu (secondes)', 'Stabilité /10', 'Douleur /10'],
      videoAsset: 'assets/videos/stability/balance_test.mp4',
      icon: Icons.balance,
      color: Color(0xFF2196F3),
      tips: [
        'Fixez un point devant vous',
        'Ne regardez pas vos pieds',
        'Gardez le corps aligné',
        'Utilisez un mur pour vous rattraper si besoin',
      ],
    ),
    StabilityTest(
      id: 'controle_genou',
      title: '🦵 Contrôle du Genou',
      subtitle: 'Test de squat unilatéral',
      instruction: 'Sur une jambe, pliez doucement le genou pour descendre votre corps, puis remontez lentement en gardant le contrôle.',
      duration: 30,
      scoringCriteria: ['Contrôle /10', 'Alignement /10', 'Douleur /10'],
      videoAsset: 'assets/videos/stability/knee_control.mp4',
      icon: Icons.directions_walk,
      color: Color(0xFF4CAF50),
      tips: [
        'Gardez le genou aligné avec le pied',
        'Descendez seulement à votre confort',
        'Mouvement lent et contrôlé',
        'Évitez que le genou ne rentre vers l\'intérieur',
      ],
    ),
    StabilityTest(
      id: 'stabilite_lombaire',
      title: '💪 Stabilité Lombaire',
      subtitle: 'Test dead-bug simplifié',
      instruction: 'Allongé sur le dos, bras et jambes en l\'air. Abaissez une jambe et le bras opposé vers le sol, puis revenez à la position initiale.',
      duration: 30,
      scoringCriteria: ['Stabilité /10', 'Forme /10', 'Douleur /10'],
      videoAsset: 'assets/videos/stability/core_stability.mp4',
      icon: Icons.fitness_center,
      color: Color(0xFFFF9800),
      tips: [
        'Gardez le bas du dos collé au sol',
        'Expirez en descendant',
        'Contrôlez le mouvement',
        'Ne laissez pas le dos se cambrer',
      ],
    ),
  ];

  // Questions du questionnaire
  final List<StabilityQuestion> _questions = [
    StabilityQuestion(
      id: 'q1_equilibre',
      question: 'Tenir l\'équilibre sur une jambe 10 secondes',
      description: 'Dans la vie quotidienne (en s\'habillant, etc.)',
      emoji: '⚖️',
    ),
    StabilityQuestion(
      id: 'q2_genou_inverse',
      question: 'Mes genoux "rentrent" pendant le squat',
      description: 'Valgus du genou pendant les mouvements',
      emoji: '🦵',
      inverse: true,
    ),
    StabilityQuestion(
      id: 'q3_stabilite_lombaire',
      question: 'Bas du dos stable lors des mouvements',
      description: 'En portant des charges, en se penchant',
      emoji: '💪',
    ),
    StabilityQuestion(
      id: 'q4_perte_equilibre_inverse',
      question: 'Perte d\'équilibre fréquente',
      description: 'Trébuchements ou pertes d\'équilibre',
      emoji: '🚶',
      inverse: true,
    ),
    StabilityQuestion(
      id: 'q5_stabilite_generale',
      question: 'Sensation générale de stabilité',
      description: 'Confiance dans votre stabilité globale',
      emoji: '🌟',
    ),
  ];

  // Résultats
  final Map<String, StabilityTestResult> _testResults = {};
  final Map<String, int> _questionnaireResults = {};
  StabilityResult? _finalResult;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _initializeVideo(0);
    
    // Initialiser les réponses du questionnaire
    for (var question in _questions) {
      _questionnaireResults[question.id] = 2; // Valeur par défaut
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo(int testIndex) async {
    if (testIndex >= _tests.length) return;
    
    final test = _tests[testIndex];
    
    // Dispose previous controllers
    _videoController?.dispose();
    _chewieController?.dispose();
    
    try {
      if (test.videoAsset != null) {
        _videoController = VideoPlayerController.asset(test.videoAsset!);
        await _videoController!.initialize();
        
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: true,
          showControls: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: test.color,
            handleColor: test.color,
            backgroundColor: Colors.grey[300]!,
            bufferedColor: Colors.grey[200]!,
          ),
          placeholder: test.thumbnail != null
              ? Image.asset(test.thumbnail!)
              : Container(color: Colors.black),
          overlay: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              test.title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      }
    } catch (e) {
      print("Erreur chargement vidéo: $e");
    }
    
    if (mounted) setState(() {});
  }

  void _startTest(int testIndex) {
    setState(() => _isTestActive = true);
    
    // Démarrer la vidéo si disponible
    if (_chewieController != null) {
      _chewieController!.play();
    }
  }

  void _completeTest(int testIndex) {
    if (_chewieController != null && _chewieController!.isPlaying) {
      _chewieController!.pause();
    }
    
    setState(() => _isTestActive = false);
    
    // Afficher le formulaire de notation
    _showScoringDialog(testIndex);
  }

  void _showScoringDialog(int testIndex) {
    final test = _tests[testIndex];
    final scores = {
      'tempsTenue': test.id == 'equilibre' ? 15.0 : 0.0,
      'stabilite': 5.0,
      'controle': 5.0,
      'alignement': 5.0,
      'douleur': 0.0,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Column(
            children: [
              Icon(test.icon, color: test.color, size: 40),
              const SizedBox(height: 10),
              Text(test.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Comment s'est passé le test ?", style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                
                if (test.id == 'equilibre') ...[
                  _buildTimeSlider(
                    label: "⏱️ Temps tenu",
                    value: scores['tempsTenue']!,
                    max: test.duration.toDouble(),
                    onChanged: (value) => setState(() => scores['tempsTenue'] = value),
                  ),
                  const SizedBox(height: 15),
                ],
                
                _buildScoreSlider(
                  label: "⚖️ Stabilité",
                  value: scores['stabilite']!,
                  onChanged: (value) => setState(() => scores['stabilite'] = value),
                ),
                const SizedBox(height: 15),
                
                if (test.id != 'equilibre') ...[
                  _buildScoreSlider(
                    label: "🎯 Contrôle",
                    value: scores['controle']!,
                    onChanged: (value) => setState(() => scores['controle'] = value),
                  ),
                  const SizedBox(height: 15),
                  
                  _buildScoreSlider(
                    label: "📐 Alignement",
                    value: scores['alignement']!,
                    onChanged: (value) => setState(() => scores['alignement'] = value),
                  ),
                  const SizedBox(height: 15),
                ],
                
                _buildScoreSlider(
                  label: "⚠️ Douleur",
                  value: scores['douleur']!,
                  onChanged: (value) => setState(() => scores['douleur'] = value),
                  isPain: true,
                ),
                
                if (scores['douleur']! > 7)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber, color: Colors.orange),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Douleur élevée détectée (>7/10)\nConsultez un professionnel si cela persiste",
                              style: TextStyle(color: Colors.orange[800], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Revoir"),
            ),
            ElevatedButton(
              onPressed: () {
                final result = StabilityTestResult(
                  testId: test.id,
                  tempsTenue: scores['tempsTenue']!,
                  stabilite: scores['stabilite']!,
                  controle: scores['controle']!,
                  alignement: scores['alignement']!,
                  douleur: scores['douleur']!,
                );
                
                _testResults[test.id] = result;
                Navigator.pop(context);
                _nextStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: test.color,
              ),
              child: const Text("Enregistrer", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlider({
    required String label,
    required double value,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, size: 20),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${value.toInt()}s",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: 0,
          max: max,
          divisions: max.toInt(),
          label: "${value.toInt()}s",
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildScoreSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    bool isPain = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isPain ? Icons.warning : Icons.star,
                  size: 20,
                  color: isPain ? Colors.orange : null,
                ),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isPain && value > 7 ? Colors.orange.withOpacity(0.2) : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${value.toInt()}/10",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPain && value > 7 ? Colors.orange : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: 0,
          max: 10,
          divisions: 10,
          label: value.toStringAsFixed(0),
          activeColor: isPain ? Colors.orange : null,
          inactiveColor: isPain ? Colors.orange[100] : null,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _nextStep() {
    if (_currentStep < _tests.length - 1) {
      setState(() => _currentStep++);
      _initializeVideo(_currentStep);
    } else if (_currentStep == _tests.length - 1) {
      // Passer au questionnaire
      setState(() => _currentStep++);
      _videoController?.dispose();
      _chewieController?.dispose();
    } else if (_currentStep < _tests.length + _questions.length) {
      setState(() => _currentStep++);
    } else {
      // Terminer et calculer les résultats
      _completeAssessment();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      if (_currentStep <= _tests.length) {
        _initializeVideo(_currentStep - 1);
      }
      setState(() => _currentStep--);
    }
  }

  void _updateQuestionnaireAnswers(Map<String, int> answers) {
    setState(() {
      _questionnaireResults.clear();
      _questionnaireResults.addAll(answers);
    });
  }

  void _completeAssessment() {
    // Calculer les résultats
    final scoringService = StabilityScoringService();
    final result = scoringService.calculateStabilityScore(
      testResults: _testResults,
      questionnaireResults: _questionnaireResults,
    );
    
    setState(() {
      _finalResult = result;
      _showResults = true;
    });
    
    _confettiController.play();
  }

  void _returnToHub() {
    final results = {
      'stabilityCompleted': true,
      'scoreGlobal': _finalResult!.scoreGlobal,
      'testResults': _testResults.map((key, value) => MapEntry(key, {
        'tempsTenue': value.tempsTenue,
        'stabilite': value.stabilite,
        'controle': value.controle,
        'alignement': value.alignement,
        'douleur': value.douleur,
      })),
      'questionnaireResults': _questionnaireResults,
      'timestamp': DateTime.now().toIso8601String(),
      'recommendations': StabilityScoringService().generateRecommendations(_finalResult!),
    };
    
    Navigator.pop(context, results);
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = _tests.length + _questions.length;
    final progress = (_currentStep + 1) / totalSteps;

    if (_showResults && _finalResult != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Résultats Stabilité'),
          backgroundColor: const Color(0xFF7BA05B),
        ),
        body: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          child: StabilityResultsWidget(
            result: _finalResult!,
            onContinue: _returnToHub,
            onRetry: () {
              setState(() {
                _showResults = false;
                _currentStep = 0;
                _testResults.clear();
                _initializeVideo(0);
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bilan Stabilité'),
        backgroundColor: const Color(0xFF7BA05B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7BA05B)),
            minHeight: 4,
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_currentStep < _tests.length && !_isTestActive)
                    _buildTestInstruction(_currentStep)
                  else if (_currentStep < _tests.length && _isTestActive)
                    _buildActiveTest(_currentStep)
                  else if (_currentStep >= _tests.length && _currentStep < totalSteps)
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
                if (_currentStep > 0 && !_isTestActive)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('Précédent'),
                    ),
                  ),
                if (_currentStep > 0 && !_isTestActive) SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < _tests.length && !_isTestActive) {
                        _startTest(_currentStep);
                      } else if (_currentStep < _tests.length && _isTestActive) {
                        _completeTest(_currentStep);
                      } else if (_currentStep >= _tests.length && _currentStep < totalSteps) {
                        _nextStep();
                      } else {
                        _completeAssessment();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      backgroundColor: const Color(0xFF7BA05B),
                    ),
                    child: Text(
                      _getActionButtonText(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestInstruction(int testIndex) {
    final test = _tests[testIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StabilityTestCard(
          test: test,
          isActive: true,
          isCompleted: _testResults.containsKey(test.id),
          onStartTest: () => _startTest(testIndex),
        ),
        
        const SizedBox(height: 24),
        
        if (_chewieController != null)
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Chewie(controller: _chewieController!),
            ),
          ),
      ],
    );
  }

  Widget _buildActiveTest(int testIndex) {
    final test = _tests[testIndex];
    
    return Column(
      children: [
        if (_chewieController != null)
          Container(
            height: 30.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black,
            ),
            child: Stack(
              children: [
                Chewie(controller: _chewieController!),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '⏱️',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 32),
        
        StabilityTimerWidget(
          duration: test.duration,
          onTimerComplete: () => _completeTest(testIndex),
          color: test.color,
        ),
      ],
    );
  }

  Widget _buildQuestionnaireView() {
    
    return StabilityQuestionnaire(
      questions: _questions,
      initialAnswers: _questionnaireResults,
      onAnswersChanged: _updateQuestionnaireAnswers,
    );
  }

  Widget _buildCompletionView() {
    return const Column(
      children: [
        Icon(Icons.check_circle, size: 80, color: Colors.green),
        SizedBox(height: 24),
        Text(
          'Questionnaire terminé !',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Text(
          'Cliquez sur "Terminer" pour calculer votre score de stabilité.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  String _getActionButtonText() {
    if (_currentStep < _tests.length) {
      return _isTestActive ? 'Terminer le test' : 'Démarrer le test';
    } else if (_currentStep < _tests.length + _questions.length) {
      return 'Question suivante';
    } else {
      return 'Terminer l\'évaluation';
    }
  }
}
