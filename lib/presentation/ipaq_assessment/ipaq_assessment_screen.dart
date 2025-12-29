import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'view_models/ipaq_view_model.dart';
import 'widgets/ipaq_question_widget.dart';
import 'widgets/ipaq_progress_indicator.dart';
import 'widgets/ipaq_results_widget.dart';

class IpaqAssessmentScreen extends StatefulWidget {
  const IpaqAssessmentScreen({super.key});

  @override
  State<IpaqAssessmentScreen> createState() => _IpaqAssessmentScreenState();
}

class _IpaqAssessmentScreenState extends State<IpaqAssessmentScreen> {
  final IpaqViewModel _viewModel = IpaqViewModel();

  @override
  Widget build(BuildContext context) {
    // Écran des résultats
    if (_viewModel.results != null) {
      return _buildResultsScreen(context);
    }

    // Écran du questionnaire
    return _buildQuestionnaireScreen(context);
  }

  Widget _buildQuestionnaireScreen(BuildContext context) {
    final theme = Theme.of(context);
    final isLastQuestion = _viewModel.currentQuestionIndex == _viewModel.totalQuestions - 1;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar personnalisée
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Bouton Retour
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      if (_viewModel.currentQuestionIndex > 0) {
                        setState(() {
                          _viewModel.previousQuestion();
                        });
                      } else {
                        Navigator.maybePop(context);
                      }
                    },
                  ),

                  // Titre
                  Text(
                    'Questionnaire IPAQ-SF',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  // Espaceur pour l'alignement
                  SizedBox(width: 12.w),
                ],
              ),
            ),

            // Indicateur de progression
            IpaqProgressIndicator(
              progress: _viewModel.currentQuestionIndex / _viewModel.totalQuestions,
              currentQuestion: _viewModel.currentQuestionIndex + 1,
              totalQuestions: _viewModel.totalQuestions,
            ),
            SizedBox(height: 2.h),

            // Question actuelle
            Expanded(
              child: IpaqQuestionWidget(
                question: _viewModel.currentQuestion,
                currentValue: _viewModel.getResponse(_viewModel.currentQuestion.id),
                onAnswer: (value) {
                  setState(() {
                    _viewModel.answerQuestion(value);
                    
                    // Passer automatiquement à la question suivante après réponse
                    if (!isLastQuestion) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        setState(() {
                          _viewModel.nextQuestion();
                        });
                      });
                    }
                  });
                },
                isLastQuestion: isLastQuestion,
              ),
            ),

            // Boutons de navigation
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  // Bouton Précédent
                  if (_viewModel.currentQuestionIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _viewModel.previousQuestion();
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Précédent',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  if (_viewModel.currentQuestionIndex > 0) SizedBox(width: 2.w),

                  // Bouton Suivant/Soumettre
                  Expanded(
                    flex: _viewModel.currentQuestionIndex > 0 ? 1 : 2,
                    child: ElevatedButton(
                      onPressed: _viewModel.isSubmitting
                          ? null
                          : () async {
                              if (isLastQuestion) {
                                try {
                                  await _viewModel.submitAssessment();
                                  setState(() {}); // Rafraîchir l'UI
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: theme.colorScheme.error,
                                    ),
                                  );
                                }
                              } else {
                                setState(() {
                                  _viewModel.nextQuestion();
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: theme.colorScheme.primary,
                      ),
                      child: _viewModel.isSubmitting
                          ? SizedBox(
                              height: 3.h,
                              width: 3.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              isLastQuestion ? 'Soumettre' : 'Suivant',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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

  Widget _buildResultsScreen(BuildContext context) {
    final theme = Theme.of(context);
    final results = _viewModel.results!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar fixe
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Résultats IPAQ-SF',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.primary,
                    ),
                    onPressed: () {
                      _showIpaqInfo(context);
                    },
                  ),
                ],
              ),
            ),

            // Contenu défilant avec les résultats
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Résumé des résultats
                    IpaqResultsWidget(
                      results: results,
                      onContinue: () {
                        // Retourner au AutoAssessmentHub
                        _returnToAssessmentHub(context);
                      },
                      onRetry: () {
                        // Réinitialiser et refaire le test
                        _viewModel.reset();
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 4.h),

                    // Section suivante
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_forward,
                                color: theme.colorScheme.primary,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Prochaine étape',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Continuez votre évaluation avec les 3 bilans suivants :',
                            style: theme.textTheme.bodyLarge,
                          ),
                          SizedBox(height: 2.h),
                          
                          // Liste des prochains tests
                          _buildNextTestItem(
                            context,
                            '📊 Bilan Mobilité',
                            'Tests pratiques cheville, hanche, épaules, rachis',
                            '6-8 minutes',
                            Color(0xFF2D5A87),
                          ),
                          SizedBox(height: 1.5.h),
                          
                          _buildNextTestItem(
                            context,
                            '⚖️ Bilan Stabilité',
                            'Équilibre unipodal, contrôle genou, stabilité lombaire',
                            '5-7 minutes',
                            Color(0xFF7BA05B),
                          ),
                          SizedBox(height: 1.5.h),
                          
                          _buildNextTestItem(
                            context,
                            '🧘 Bilan Conscience Corporelle',
                            'Respiration, perception posturale, contrôle mouvement',
                            '5-6 minutes',
                            Color(0xFF9BC47D),
                          ),
                          SizedBox(height: 3.h),

                          // Bouton continuer
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _returnToAssessmentHub(context),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                backgroundColor: theme.colorScheme.secondary,
                              ),
                              child: Text(
                                'Continuer vers les autres évaluations',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextTestItem(BuildContext context, String title, String description, String time, Color color) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: color,
              size: 24,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              time,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showIpaqInfo(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('À propos de IPAQ-SF', style: theme.textTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'L\'International Physical Activity Questionnaire (IPAQ) est un outil validé scientifiquement pour mesurer l\'activité physique des 7 derniers jours.',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                'Les résultats IPAQ permettent de :',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              _buildInfoItem('🎯', 'Adapter l\'intensité de votre programme'),
              _buildInfoItem('📊', 'Définir votre profil de départ (A/B/C)'),
              _buildInfoItem('⏱️', 'Déterminer la fréquence optimale des séances'),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Ces données initiales sont essentielles pour générer un programme personnalisé de réactivation motrice.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Compris'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(width: 2.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

 void _returnToAssessmentHub(BuildContext context) {
    print("Retour au AutoAssessmentHub...");
    
    // Préparer les données IPAQ
    final ipaqData = {
      'ipaqCompleted': true,
      'timestamp': DateTime.now().toIso8601String(),
      'results': _viewModel.toJson(), // Utiliser toJson() du ViewModel
    };
    
    print("Données à retourner: ${ipaqData.keys}");
    
    // FORCER le retour avec données
    Navigator.of(context).pop(ipaqData);
  }
}
