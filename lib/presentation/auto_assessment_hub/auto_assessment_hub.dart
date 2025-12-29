import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/assessment_card_widget.dart';
import './widgets/assessment_test_widget.dart';
import './widgets/progress_header_widget.dart';
import '../ipaq_assessment/ipaq_assessment_screen.dart';
import '../mobility_assessment/mobility_assessment_screen.dart';
import '../stability_assessment/stability_assessment_screen.dart';
/// Hub d'Auto-Évaluation qui guide l'utilisateur à travers le système
/// d'évaluation complet en 4 parties conforme au cahier des charges.
class AutoAssessmentHub extends StatefulWidget {
  const AutoAssessmentHub({super.key});

  @override
  State<AutoAssessmentHub> createState() => _AutoAssessmentHubState();
}

class _AutoAssessmentHubState extends State<AutoAssessmentHub> {
  int _currentBottomNavIndex = 2; // Onglet Évaluations
  int _currentAssessmentIndex = 0;
  bool _isAssessmentActive = false;

  // Suivi de complétion des évaluations
  final Map<String, bool> _assessmentCompletion = {
    'ipaq': false,       // Premier selon CDC
    'mobilite': false,   // Mobilité
    'stabilite': false,  // Stabilité
    'conscience': false, // Conscience corporelle
  };

  // Stockage des données d'évaluation
  final Map<String, Map<String, dynamic>> _assessmentData = {
    'ipaq': {},
    'mobilite': {},
    'stabilite': {},
    'conscience': {},
  };

  // Modules d'évaluation selon le cahier des charges
  final List<Map<String, dynamic>> _assessmentModules = [
    {
      "id": "ipaq",
      "title": "Questionnaire IPAQ-SF",
      "description": "Évaluation du niveau d'activité physique hebdomadaire",
      "estimatedTime": "3-5 minutes",
      "icon": "assignment",
      "color": Color(0xFF5B8FC4),
      "ordre": 1,
      "questions": [
        {
          "question": "Pendant les 7 derniers jours, combien de jours avez-vous marché au moins 10 minutes d'affilée ?",
          "type": "jours_semaine",
          "reponses": ["0 jour", "1 jour", "2 jours", "3 jours", "4 jours", "5 jours", "6 jours", "7 jours"]
        },
        {
          "question": "Les jours où vous avez marché, combien de temps en moyenne par jour ?",
          "type": "minutes_jour",
          "reponses": ["Moins de 10 min", "10-30 min", "30-60 min", "1-2h", "Plus de 2h"]
        },
        {
          "question": "Pendant les 7 derniers jours, combien de jours avez-vous fait des activités physiques MODÉRÉES (ex: vélo lent, yoga léger) ?",
          "type": "jours_semaine",
          "reponses": ["0 jour", "1 jour", "2 jours", "3 jours", "4 jours", "5 jours", "6 jours", "7 jours"]
        },
        {
          "question": "Les jours d'activités modérées, combien de temps en moyenne par jour ?",
          "type": "minutes_jour",
          "reponses": ["Moins de 10 min", "10-30 min", "30-60 min", "1-2h", "Plus de 2h"]
        },
        {
          "question": "Pendant les 7 derniers jours, combien de jours avez-vous fait des activités physiques INTENSES (ex: course, sport intense) ?",
          "type": "jours_semaine",
          "reponses": ["0 jour", "1 jour", "2 jours", "3 jours", "4 jours", "5 jours", "6 jours", "7 jours"]
        },
        {
          "question": "Les jours d'activités intenses, combien de temps en moyenne par jour ?",
          "type": "minutes_jour",
          "reponses": ["Moins de 10 min", "10-30 min", "30-60 min", "1-2h", "Plus de 2h"]
        },
        {
          "question": "En moyenne, combien d'heures par jour passez-vous ASSIS pendant la semaine (bureau, transport, maison) ?",
          "type": "heures_jour",
          "reponses": ["Moins de 4h", "4-6h", "6-8h", "8-10h", "Plus de 10h"]
        }
      ]
    },
    {
      "id": "mobilite",
      "title": "Bilan Mobilité",
      "description": "Tests pratiques cheville, hanche, épaules, rachis + questionnaire",
      "estimatedTime": "6-8 minutes",
      "icon": "accessibility_new",
      "color": Color(0xFF2D5A87),
      "ordre": 2,
      "tests": [
        {
          "id": "cheville",
          "name": "Mobilité Cheville (Dorsiflexion)",
          "instruction": "Placez-vous face à un mur, pieds nus. Avancez un pied de façon à ce que vos orteils soient à environ 10 cm du mur. Gardez le talon au sol et pliez le genou vers l'avant jusqu'à ce qu'il touche le mur. Répétez avec l'autre pied.",
          "duration": 45,
          "scoringCriteria": ["Amplitude /10", "Facilité /10", "Douleur /10"],
          "videoGuidance": null, // ou "cheville_dorsiflexion.mp4"
          "safetyTips": "Ne forcez pas si vous ressentez une douleur aiguë à la cheville"
        },
        {
          "id": "hanche",
          "name": "Mobilité Hanche (Flexion/Rotation)",
          "instruction": "Allongez-vous sur le dos, jambes tendues. Ramenez un genou vers votre poitrine en le tenant avec vos mains. Gardez l'autre jambe tendue au sol. Maintenez 10 secondes, puis changez de côté.",
          "duration": 60,
          "scoringCriteria": ["Amplitude /10", "Facilité /10", "Douleur /10"],
          "videoGuidance": null,
          "safetyTips": "Évitez si vous avez des problèmes de hanche récents"
        },
        {
          "id": "epaules",
          "name": "Mobilité Épaules (Flexion/Abduction)",
          "instruction": "Debout, dos contre un mur. Levez les bras sur les côtés jusqu'à ce qu'ils touchent le mur. Puis, levez-les vers l'avant jusqu'au-dessus de la tête, en gardant les coudes tendus.",
          "duration": 45,
          "scoringCriteria": ["Amplitude /10", "Facilité /10", "Douleur /10"],
          "videoGuidance": null,
          "safetyTips": "Arrêtez si douleur à l'épaule > 4/10"
        },
        {
          "id": "rachis",
          "name": "Mobilité Rachis (Flexion/Extension/Rotation)",
          "instruction": "Assis sur une chaise, pieds à plat. Tournez lentement le haut du corps vers la droite, en gardant les hanches stables. Tenez 5 secondes, revenez au centre, puis tournez à gauche. Ensuite, penchez-vous doucement vers l'avant comme pour toucher vos pieds.",
          "duration": 60,
          "scoringCriteria": ["Amplitude /10", "Facilité /10", "Douleur /10"],
          "videoGuidance": null,
          "safetyTips": "Évitez les mouvements brusques"
        }
      ],
      "questionnaire": [
        {
          "id": "q1",
          "question": "Me pencher en avant sans gêne",
          "echelle": "0 (impossible) à 4 (très facile)",
          "type": "echelle",
          "inverse": false
        },
        {
          "id": "q2",
          "question": "M'accroupir sans douleur",
          "echelle": "0 (impossible) à 4 (très facile)",
          "type": "echelle",
          "inverse": false
        },
        {
          "id": "q3",
          "question": "Tourner mon tronc aisément",
          "echelle": "0 (impossible) à 4 (très facile)",
          "type": "echelle",
          "inverse": false
        },
        {
          "id": "q4",
          "question": "Lever les bras au-dessus de ma tête",
          "echelle": "0 (impossible) à 4 (très facile)",
          "type": "echelle",
          "inverse": false
        },
        {
          "id": "q5",
          "question": "Sensation de raideur au réveil",
          "echelle": "0 (jamais) à 4 (toujours)",
          "type": "echelle",
          "inverse": true
        }
      ]
    },
    {
      "id": "stabilite",
      "title": "Bilan Stabilité",
      "description": "Équilibre unipodal, contrôle genou, stabilité lombaire",
      "estimatedTime": "5-7 minutes",
      "icon": "balance",
      "color": Color(0xFF7BA05B),
      "ordre": 3,
      "tests": [
      {
        "name": "Équilibre Unipodal",
        "instruction": "Tenez-vous sur une jambe avec vos mains sur vos hanches. Essayez de maintenir l'équilibre pendant 30 secondes sans bouger.",
        "duration": 30,
        "scoringCriteria": ["Temps tenu (secondes)", "Stabilité /10", "Douleur /10"],
        "videoGuidance": "assets/videos/stability/balance_test.mp4",
        "tips": ["Fixez un point devant vous", "Ne regardez pas vos pieds", "Gardez le corps aligné"]
      },
      {
        "name": "Contrôle du Genou (Mini-squat)",
        "instruction": "Sur une jambe, pliez doucement le genou pour descendre votre corps, puis remontez lentement en gardant le contrôle.",
        "duration": 30,
        "scoringCriteria": ["Contrôle /10", "Alignement /10", "Douleur /10"],
        "videoGuidance": "assets/videos/stability/knee_control.mp4",
        "tips": ["Gardez le genou aligné avec le pied", "Descendez seulement à votre confort", "Mouvement lent et contrôlé"]
      },
      {
        "name": "Stabilité Lombaire (Dead-bug simplifié)",
        "instruction": "Allongé sur le dos, bras et jambes en l'air. Abaissez une jambe et le bras opposé vers le sol, puis revenez à la position initiale.",
        "duration": 30,
        "scoringCriteria": ["Stabilité /10", "Forme /10", "Douleur /10"],
        "videoGuidance": "assets/videos/stability/core_stability.mp4",
        "tips": ["Gardez le bas du dos collé au sol", "Expirez en descendant", "Contrôlez le mouvement"]
      }
    ],
    "questionnaire": [
      {
        "question": "Tenir l'équilibre sur une jambe 10 secondes",
        "echelle": "0 (jamais) à 4 (toujours)",
        "type": "echelle"
      },
      {
        "question": "Mes genoux 'rentrent' pendant le squat",
        "echelle": "0 (jamais) à 4 (toujours)",
        "type": "echelle",
        "inverse": true
      },
      {
        "question": "Bas du dos stable lors des mouvements",
        "echelle": "0 (jamais) à 4 (toujours)",
        "type": "echelle"
      },
      {
        "question": "Perte d'équilibre fréquente",
        "echelle": "0 (jamais) à 4 (toujours)",
        "type": "echelle",
        "inverse": true
      },
      {
        "question": "Sensation générale de stabilité",
        "echelle": "0 (jamais) à 4 (toujours)",
        "type": "echelle"
      }
    ]
  },
    {
      "id": "conscience",
      "title": "Bilan Conscience Corporelle",
      "description": "Respiration diaphragmatique, perception posturale, contrôle mouvement",
      "estimatedTime": "5-6 minutes",
      "icon": "self_improvement",
      "color": Color(0xFF9BC47D),
      "ordre": 4,
      "tests": [
        {
          "name": "Respiration Diaphragmatique",
          "instruction": "Allongé sur le dos, une main sur la poitrine, une sur le ventre. Respirez profondément en gonflant le ventre.",
          "duration": 60,
          "scoringCriteria": ["Expansion ventre /10", "Mouvement poitrine /10", "Facilité /10"]
        },
        {
          "name": "Auto-perception Posture Assise",
          "instruction": "Assis naturellement. Évaluez si votre poids est bien réparti et votre colonne alignée.",
          "duration": 30,
          "scoringCriteria": ["Prise de conscience /10", "Perception alignement /10"]
        },
        {
          "name": "Contrôle de Mouvement",
          "instruction": "Levez lentement les bras au-dessus de la tête, puis baissez-les. Concentrez-vous sur un mouvement fluide.",
          "duration": 30,
          "scoringCriteria": ["Contrôle /10", "Fluidité /10", "Conscience /10"]
        }
      ],
      "questionnaire": [
        {
          "question": "Je remarque facilement une mauvaise posture",
          "echelle": "0 (jamais) à 4 (toujours)"
        },
        {
          "question": "Je suis conscient de ma respiration dans la journée",
          "echelle": "0 (jamais) à 4 (toujours)"
        },
        {
          "question": "Je perçois les zones de tension dans mon corps",
          "echelle": "0 (jamais) à 4 (toujours)"
        },
        {
          "question": "Je remarque quand je compense un mouvement",
          "echelle": "0 (jamais) à 4 (toujours)"
        },
        {
          "question": "Je sens si un mouvement est fluide ou rigide",
          "echelle": "0 (jamais) à 4 (toujours)"
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _isAssessmentActive
          ? null
          : CustomAppBar(
              title: 'Hub d\'Auto-Évaluation',
              variant: CustomAppBarVariant.standard,
              actions: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'info_outline',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => _showAssessmentInfo(context),
                  tooltip: 'Informations sur les évaluations',
                ),
              ],
            ),
      body: _isAssessmentActive
          ? _buildActiveAssessment(context)
          : _buildAssessmentHub(context),
      bottomNavigationBar: _isAssessmentActive
          ? null
          : CustomBottomBar(
              currentIndex: _currentBottomNavIndex,
              onTap: (index) {
                setState(() => _currentBottomNavIndex = index);
              },
            ),
    );
  }

  /// Construit l'interface principale du hub d'évaluation
  Widget _buildAssessmentHub(BuildContext context) {
    final theme = Theme.of(context);

    // Trier les modules par ordre défini
    final sortedModules = _assessmentModules.toList()
      ..sort((a, b) => (a['ordre'] ?? 0).compareTo(b['ordre'] ?? 0));

    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de progression
              ProgressHeaderWidget(
                completedCount:
                    _assessmentCompletion.values.where((v) => v).length,
                totalCount: _assessmentModules.length,
              ),
              SizedBox(height: 3.h),

              

              // Cartes d'évaluation
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: sortedModules.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final module = sortedModules[index];
                    final isCompleted = _assessmentCompletion[module['id']] ?? false;
                    final isLocked = index > 0 && !(_assessmentCompletion[sortedModules[index - 1]['id']] ?? false);

                  return AssessmentCardWidget(
                    title: module['title'] as String,
                    description: module['description'] as String,
                    estimatedTime: module['estimatedTime'] as String,
                    iconName: module['icon'] as String,
                    color: module['color'] as Color,
                    isCompleted: isCompleted,
                    isLocked: isLocked,
                    onTap: !isLocked ? () => _startAssessment(index) : null,
                  );
                },
              ),
              SizedBox(height: 3.h),

              // Bouton de complétion
              if (_assessmentCompletion.values.every((v) => v))
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _completeAssessment(context),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      backgroundColor: theme.colorScheme.secondary,
                    ),
                    child: Text(
                      'Générer mon Programme',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 2.h),

              // Indication sur l'ordre des tests
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Ordre recommandé :',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '1. IPAQ → 2. Mobilité → 3. Stabilité → 4. Conscience corporelle\n\nL\'IPAQ mesure d\'abord votre niveau d\'activité physique pour adapter les séances.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 /// Construit l'interface d'évaluation active
  Widget _buildActiveAssessment(BuildContext context) {
    final module = _assessmentModules[_currentAssessmentIndex];
    final moduleId = module['id'] as String;
    
    print("🔧 Module actif: $moduleId");
    
    // Gérer selon le type de module
    if (moduleId == 'ipaq') {
      // Pour IPAQ (déjà fonctionnel)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IpaqAssessmentScreen(),
          ),
        );
        
        if (result != null && result is Map<String, dynamic>) {
          _saveAssessmentData('ipaq', result);
        }
        setState(() => _isAssessmentActive = false);
      });
      
      return Center(child: CircularProgressIndicator());
      
    } else if (moduleId == 'mobilite') {
      // Pour Mobilité (à adapter avec la nouvelle version vidéo)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobilityAssessmentScreen(),
          ),
        );
        
        if (result != null && result is Map<String, dynamic>) {
          _saveAssessmentData('mobilite', result);
        }
        setState(() => _isAssessmentActive = false);
      });
      
      return Center(child: CircularProgressIndicator());
      
    } else if (moduleId == 'stabilite') {
      // POUR STABILITÉ 🆕
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StabilityAssessmentScreen(),
          ),
        );
        
        if (result != null && result is Map<String, dynamic>) {
          _saveAssessmentData('stabilite', result);
        }
        setState(() => _isAssessmentActive = false);
      });
      
      return Center(child: CircularProgressIndicator());
      
    } else if (moduleId == 'conscience') {
      // POUR CONSCIENCE (à créer plus tard)
      final tests = module['tests'] as List<Map<String, dynamic>>;
      
      return AssessmentTestWidget(
        moduleName: module['title'] as String,
        tests: tests,
        onComplete: (data) => _saveAssessmentData(moduleId, data),
        onExit: () => setState(() => _isAssessmentActive = false),
      );
    }
    
    // Fallback
    return Center(child: Text('Module non implémenté'));
  }

  /// Démarre un module d'évaluation
  void _startAssessment(int index) {
    final module = _assessmentModules[index];
    final moduleId = module['id'] as String;
    
    print("▶️ Démarrage module: $moduleId");
    
    // VÉRIFICATION : IPAQ doit être fait en premier
    if (moduleId != 'ipaq' && !(_assessmentCompletion['ipaq'] ?? false)) {
      print("⛔ IPAQ non complété, impossible de continuer");
      
      // Afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Complétez d\'abord le questionnaire IPAQ-SF'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    setState(() {
      _currentAssessmentIndex = index;
      _isAssessmentActive = true;
    });
  }

  /// Sauvegarde les données d'évaluation et marque le module comme complet
  void _saveAssessmentData(String moduleId, Map<String, dynamic> data) {
    print("💾 Sauvegarde module: $moduleId");
    print("📊 Données reçues: ${data.keys}");
    
    setState(() {
      _assessmentData[moduleId] = data;
      _assessmentCompletion[moduleId] = true;
      _isAssessmentActive = false;
    });

    // Message de succès
    final moduleTitle = _assessmentModules.firstWhere(
      (m) => m['id'] == moduleId,
      orElse: () => {'title': 'Module'},
    )['title'] as String;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ $moduleTitle complété !'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Vérifier les red flags (sauf pour IPAQ)
    if (moduleId != 'ipaq') {
      _checkRedFlags(moduleId, data);
    }
  }

  /// Vérifie les red flags selon le cahier des charges
  void _checkRedFlags(String moduleId, Map<String, dynamic> data) {
    bool hasRedFlag = false;
    String redFlagMessage = '';

    // Vérifier les scores de douleur élevés (>7/10)
    if (moduleId != 'ipaq') {
      data.forEach((testName, testData) {
        if (testData is Map<String, dynamic>) {
          final painScore = testData['Douleur /10'];
          if (painScore != null && painScore > 7) {
            hasRedFlag = true;
            redFlagMessage = 'Douleur élevée détectée pendant le test $testName';
          }

          // Vérifier l'incapacité à réaliser un test
          final testCompleted = testData['completed'];
          if (testCompleted != null && !testCompleted) {
            hasRedFlag = true;
            redFlagMessage = 'Incapacité à réaliser le test $testName';
          }
        }
      });
    }

    if (hasRedFlag) {
      // Naviguer vers l'écran d'alerte red flags
      Future.delayed(Duration(milliseconds: 500), () {
        Navigator.pushNamed(
          context,
          '/red-flags-alert',
          arguments: {
            'message': redFlagMessage,
            'assessmentData': _assessmentData,
          },
        );
      });
    }
  }

  /// Complète toutes les évaluations et génère le programme
  void _completeAssessment(BuildContext context) {
    // Afficher l'animation de célébration
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCelebrationDialog(context),
    );

    // Naviguer vers le tableau de bord de progression après délai
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Fermer la boîte de dialogue
      Navigator.pushNamed(
        context,
        '/progress-dashboard', // Modifié pour aller vers Progress Dashboard
        arguments: {
          'assessmentData': _assessmentData,
        },
      );
    });
  }

  /// Construit la boîte de dialogue de célébration
  Widget _buildCelebrationDialog(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: theme.colorScheme.secondary,
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'Évaluations Complétées !',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Génération de votre programme personnalisé...',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            CircularProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche les informations sur les évaluations
  void _showAssessmentInfo(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'À propos des évaluations',
          style: theme.textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Complétez les 4 modules d\'évaluation pour recevoir votre programme personnalisé de réactivation motrice :',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildInfoItem(
                context,
                'IPAQ-SF',
                'Mesure votre niveau d\'activité physique hebdomadaire',
              ),
              _buildInfoItem(
                context,
                'Bilan Mobilité',
                'Évalue l\'amplitude articulaire (cheville, hanche, épaules, rachis)',
              ),
              _buildInfoItem(
                context,
                'Bilan Stabilité',
                'Teste l\'équilibre et le contrôle postural',
              ),
              _buildInfoItem(
                context,
                'Bilan Conscience Corporelle',
                'Mesure la perception et le contrôle du mouvement',
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'warning',
                      color: theme.colorScheme.error,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Arrêtez immédiatement si vous ressentez une douleur aiguë (>7/10) ou des symptômes neurologiques',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
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

  /// Construit un élément d'information pour la boîte de dialogue
  Widget _buildInfoItem(
      BuildContext context, String title, String description) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'check_circle',
            color: theme.colorScheme.secondary,
            size: 20,
          ),
          SizedBox(width: 2.w),
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
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
