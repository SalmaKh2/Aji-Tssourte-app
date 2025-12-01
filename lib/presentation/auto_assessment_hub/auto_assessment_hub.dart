import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/assessment_card_widget.dart';
import './widgets/assessment_test_widget.dart';
import './widgets/progress_header_widget.dart';

/// Auto-Assessment Hub screen that guides users through comprehensive
/// four-part evaluation system measuring mobility, stability, body awareness,
/// and lifestyle factors.
class AutoAssessmentHub extends StatefulWidget {
  const AutoAssessmentHub({super.key});

  @override
  State<AutoAssessmentHub> createState() => _AutoAssessmentHubState();
}

class _AutoAssessmentHubState extends State<AutoAssessmentHub> {
  int _currentBottomNavIndex = 2; // Assessments tab
  int _currentAssessmentIndex = 0;
  bool _isAssessmentActive = false;

  // Assessment completion tracking
  final Map<String, bool> _assessmentCompletion = {
    'mobility': false,
    'stability': false,
    'awareness': false,
    'lifestyle': false,
  };

  // Assessment data storage
  final Map<String, Map<String, dynamic>> _assessmentData = {
    'mobility': {},
    'stability': {},
    'awareness': {},
    'lifestyle': {},
  };

  // Mock assessment modules data
  final List<Map<String, dynamic>> _assessmentModules = [
    {
      "id": "mobility",
      "title": "Mobility Tests",
      "description": "Ankle, hip, shoulder, and spine mobility assessment",
      "estimatedTime": "6-8 minutes",
      "icon": "accessibility_new",
      "color": Color(0xFF2D5A87),
      "tests": [
        {
          "name": "Ankle Mobility",
          "instruction":
              "Stand facing a wall. Place one foot forward and try to touch your knee to the wall while keeping your heel on the ground.",
          "duration": 30,
          "scoringCriteria": ["Amplitude (0-10)", "Ease (0-10)", "Pain (0-10)"]
        },
        {
          "name": "Hip Mobility",
          "instruction":
              "Lie on your back. Bring one knee to your chest while keeping the other leg straight on the ground.",
          "duration": 30,
          "scoringCriteria": ["Amplitude (0-10)", "Ease (0-10)", "Pain (0-10)"]
        },
        {
          "name": "Shoulder Mobility",
          "instruction":
              "Stand with your back against a wall. Raise both arms overhead, trying to touch the wall with your hands.",
          "duration": 30,
          "scoringCriteria": ["Amplitude (0-10)", "Ease (0-10)", "Pain (0-10)"]
        },
        {
          "name": "Spine Mobility",
          "instruction":
              "Sit on a chair. Slowly rotate your upper body to the right, then to the left, keeping your hips stable.",
          "duration": 30,
          "scoringCriteria": ["Amplitude (0-10)", "Ease (0-10)", "Pain (0-10)"]
        }
      ]
    },
    {
      "id": "stability",
      "title": "Stability Tests",
      "description": "Balance, knee control, and trunk stability evaluation",
      "estimatedTime": "5-7 minutes",
      "icon": "balance",
      "color": Color(0xFF7BA05B),
      "tests": [
        {
          "name": "One-Leg Balance",
          "instruction":
              "Stand on one leg with your hands on your hips. Try to maintain balance for 30 seconds.",
          "duration": 30,
          "scoringCriteria": [
            "Time held (seconds)",
            "Stability (0-10)",
            "Pain (0-10)"
          ]
        },
        {
          "name": "Knee Control",
          "instruction":
              "Stand on one leg. Slowly bend your knee to lower your body, then return to standing position.",
          "duration": 30,
          "scoringCriteria": [
            "Control (0-10)",
            "Alignment (0-10)",
            "Pain (0-10)"
          ]
        },
        {
          "name": "Trunk Stability",
          "instruction":
              "Get into a plank position on your forearms. Hold this position while maintaining a straight line from head to heels.",
          "duration": 30,
          "scoringCriteria": [
            "Time held (seconds)",
            "Form (0-10)",
            "Pain (0-10)"
          ]
        }
      ]
    },
    {
      "id": "awareness",
      "title": "Body Awareness",
      "description": "Breathing, posture perception, and movement control",
      "estimatedTime": "5-6 minutes",
      "icon": "self_improvement",
      "color": Color(0xFF5B8FC4),
      "tests": [
        {
          "name": "Diaphragmatic Breathing",
          "instruction":
              "Lie on your back with one hand on your chest and one on your belly. Breathe deeply, focusing on expanding your belly rather than your chest.",
          "duration": 60,
          "scoringCriteria": [
            "Belly expansion (0-10)",
            "Chest movement (0-10)",
            "Ease (0-10)"
          ]
        },
        {
          "name": "Posture Perception",
          "instruction":
              "Stand naturally. Without looking in a mirror, assess whether you feel your weight is evenly distributed and your spine is aligned.",
          "duration": 30,
          "scoringCriteria": ["Awareness (0-10)", "Alignment perception (0-10)"]
        },
        {
          "name": "Controlled Movement",
          "instruction":
              "Slowly raise your arms overhead, then lower them. Focus on moving smoothly and with control throughout the entire range.",
          "duration": 30,
          "scoringCriteria": [
            "Control (0-10)",
            "Smoothness (0-10)",
            "Awareness (0-10)"
          ]
        }
      ]
    },
    {
      "id": "lifestyle",
      "title": "Lifestyle Questionnaire",
      "description": "IPAQ-SF physical activity assessment",
      "estimatedTime": "3-5 minutes",
      "icon": "assignment",
      "color": Color(0xFF9BC47D),
      "tests": [
        {
          "name": "Physical Activity Level",
          "instruction":
              "Answer questions about your typical weekly physical activity including vigorous activities, moderate activities, walking, and sitting time.",
          "duration": 0,
          "scoringCriteria": [
            "Activity frequency",
            "Activity duration",
            "Sitting time"
          ]
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
              title: 'Assessment Hub',
              variant: CustomAppBarVariant.standard,
              actions: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'info_outline',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => _showAssessmentInfo(context),
                  tooltip: 'Assessment Information',
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

  /// Builds the main assessment hub interface
  Widget _buildAssessmentHub(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress header
              ProgressHeaderWidget(
                completedCount:
                    _assessmentCompletion.values.where((v) => v).length,
                totalCount: _assessmentModules.length,
              ),
              SizedBox(height: 3.h),

              // Introduction text
              Text(
                'Complete all four assessments to unlock your personalized motor reactivation program',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 3.h),

              // Assessment cards
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _assessmentModules.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final module = _assessmentModules[index];
                  final isCompleted =
                      _assessmentCompletion[module['id']] ?? false;

                  return AssessmentCardWidget(
                    title: module['title'] as String,
                    description: module['description'] as String,
                    estimatedTime: module['estimatedTime'] as String,
                    iconName: module['icon'] as String,
                    color: module['color'] as Color,
                    isCompleted: isCompleted,
                    onTap: () => _startAssessment(index),
                  );
                },
              ),
              SizedBox(height: 3.h),

              // Complete button
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
                      'Generate My Program',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSecondary,
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the active assessment interface
  Widget _buildActiveAssessment(BuildContext context) {
    final module = _assessmentModules[_currentAssessmentIndex];
    final tests = module['tests'] as List<Map<String, dynamic>>;

    return AssessmentTestWidget(
      moduleName: module['title'] as String,
      tests: tests,
      onComplete: (data) => _saveAssessmentData(module['id'] as String, data),
      onExit: () => setState(() => _isAssessmentActive = false),
    );
  }

  /// Starts an assessment module
  void _startAssessment(int index) {
    setState(() {
      _currentAssessmentIndex = index;
      _isAssessmentActive = true;
    });
  }

  /// Saves assessment data and marks module as complete
  void _saveAssessmentData(String moduleId, Map<String, dynamic> data) {
    setState(() {
      _assessmentData[moduleId] = data;
      _assessmentCompletion[moduleId] = true;
      _isAssessmentActive = false;
    });

    // Check for red flags
    _checkRedFlags(moduleId, data);

    // Show completion message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_assessmentModules[_currentAssessmentIndex]['title']} completed!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Checks for red flags in assessment data
  void _checkRedFlags(String moduleId, Map<String, dynamic> data) {
    bool hasRedFlag = false;
    String redFlagMessage = '';

    // Check for high pain scores (>7/10)
    data.forEach((testName, testData) {
      if (testData is Map<String, dynamic>) {
        final painScore = testData['Pain (0-10)'];
        if (painScore != null && painScore > 7) {
          hasRedFlag = true;
          redFlagMessage = 'High pain level detected during $testName test';
        }

        // Check for test inability
        final testCompleted = testData['completed'];
        if (testCompleted != null && !testCompleted) {
          hasRedFlag = true;
          redFlagMessage = 'Unable to complete $testName test';
        }
      }
    });

    if (hasRedFlag) {
      // Navigate to red flags alert screen
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

  /// Completes all assessments and generates program
  void _completeAssessment(BuildContext context) {
    // Show celebration animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildCelebrationDialog(context),
    );

    // Navigate to program summary after delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close dialog
      Navigator.pushNamed(
        context,
        '/program-summary',
        arguments: {
          'assessmentData': _assessmentData,
        },
      );
    });
  }

  /// Builds celebration dialog
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
              'Assessment Complete!',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Generating your personalized program...',
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

  /// Shows assessment information dialog
  void _showAssessmentInfo(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About Assessments',
          style: theme.textTheme.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Complete all four assessment modules to receive your personalized motor reactivation program:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildInfoItem(
                context,
                'Mobility Tests',
                'Evaluates range of motion in key joints',
              ),
              _buildInfoItem(
                context,
                'Stability Tests',
                'Assesses balance and postural control',
              ),
              _buildInfoItem(
                context,
                'Body Awareness',
                'Measures movement perception and control',
              ),
              _buildInfoItem(
                context,
                'Lifestyle Questionnaire',
                'Evaluates current physical activity levels',
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
                        'Stop immediately if you experience severe pain (>7/10) or unusual symptoms',
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
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  /// Builds info item for dialog
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
