import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/customization_modal_widget.dart';
import './widgets/program_actions_widget.dart';
import './widgets/program_header_widget.dart';
import './widgets/program_recommendations_widget.dart';
import './widgets/weekly_session_card_widget.dart';

/// Program Summary Screen - Displays personalized training plan
///
/// Shows 2-4 week program structure with 2-3 sessions per week based on
/// assessment results. Includes weekly breakdown, session details, and
/// customization options.
class ProgramSummary extends StatefulWidget {
  const ProgramSummary({super.key});

  @override
  State<ProgramSummary> createState() => _ProgramSummaryState();
}

class _ProgramSummaryState extends State<ProgramSummary> {
  int _currentBottomNavIndex = 1; // Programs tab

  // Mock program data
  final Map<String, dynamic> programData = {
    "duration": "4 weeks",
    "totalSessions": 12,
    "weeklyTimeCommitment": "30-45 minutes",
    "startDate": "2025-12-02",
    "focusAreas": ["Mobility", "Stability", "Body Awareness"],
    "weeks": [
      {
        "weekNumber": 1,
        "title": "Foundation Building",
        "sessions": [
          {
            "id": "s1",
            "title": "Ankle & Hip Mobility",
            "focusAreas": ["Mobility"],
            "duration": "12 minutes",
            "difficulty": "Beginner",
            "thumbnail":
                "https://images.unsplash.com/photo-1518310952931-b1de897abd40",
            "semanticLabel":
                "Person performing ankle mobility exercise on yoga mat in bright studio",
            "exercises": [
              "Ankle Circles",
              "Hip Flexor Stretch",
              "Cat-Cow Stretch",
            ],
            "objectives":
                "Improve ankle dorsiflexion and hip flexion range of motion",
          },
          {
            "id": "s2",
            "title": "Core Stability Basics",
            "focusAreas": ["Stability"],
            "duration": "10 minutes",
            "difficulty": "Beginner",
            "thumbnail":
                "https://images.unsplash.com/photo-1526582722295-6438d8ef8a42",
            "semanticLabel":
                "Woman doing plank exercise on purple yoga mat in home gym",
            "exercises": ["Dead Bug", "Bird Dog", "Plank Hold"],
            "objectives":
                "Build foundational core strength and trunk stability",
          },
          {
            "id": "s3",
            "title": "Breathing & Awareness",
            "focusAreas": ["Body Awareness"],
            "duration": "8 minutes",
            "difficulty": "Beginner",
            "thumbnail":
                "https://images.unsplash.com/photo-1734638901126-bd34c411a029",
            "semanticLabel":
                "Person sitting cross-legged practicing breathing exercises in peaceful room",
            "exercises": [
              "Diaphragmatic Breathing",
              "Body Scan",
              "Posture Check",
            ],
            "objectives": "Develop breath awareness and postural consciousness",
          },
        ],
      },
      {
        "weekNumber": 2,
        "title": "Progressive Challenge",
        "sessions": [
          {
            "id": "s4",
            "title": "Shoulder & Spine Mobility",
            "focusAreas": ["Mobility"],
            "duration": "14 minutes",
            "difficulty": "Beginner",
            "thumbnail":
                "https://images.unsplash.com/photo-1518609571773-39b7d303a87b",
            "semanticLabel":
                "Person doing shoulder stretches with resistance band in fitness studio",
            "exercises": [
              "Shoulder Circles",
              "Thoracic Rotation",
              "Scapular Slides",
            ],
            "objectives":
                "Enhance shoulder mobility and thoracic spine rotation",
          },
          {
            "id": "s5",
            "title": "Balance & Control",
            "focusAreas": ["Stability"],
            "duration": "12 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://images.unsplash.com/photo-1666070981958-a4eb8ae06d76",
            "semanticLabel":
                "Woman balancing on one leg with arms extended in yoga pose outdoors",
            "exercises": [
              "Single Leg Balance",
              "Knee Control Drills",
              "Stability Reaches",
            ],
            "objectives": "Improve single-leg stability and dynamic balance",
          },
          {
            "id": "s6",
            "title": "Movement Integration",
            "focusAreas": ["Body Awareness", "Mobility"],
            "duration": "15 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://images.unsplash.com/photo-1612732362547-14adf627f24e",
            "semanticLabel":
                "Person performing flowing yoga movements on mat in sunlit room",
            "exercises": [
              "Flow Sequences",
              "Controlled Transitions",
              "Mindful Movement",
            ],
            "objectives":
                "Integrate mobility and awareness through fluid movement",
          },
        ],
      },
      {
        "weekNumber": 3,
        "title": "Strength Integration",
        "sessions": [
          {
            "id": "s7",
            "title": "Full Body Mobility",
            "focusAreas": ["Mobility"],
            "duration": "15 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://img.rocket.new/generatedImages/rocket_gen_img_1c2fad91d-1764441009023.png",
            "semanticLabel":
                "Person doing dynamic stretching routine in modern gym space",
            "exercises": [
              "Dynamic Warm-up",
              "Multi-joint Mobility",
              "Active Stretching",
            ],
            "objectives": "Combine mobility work across multiple joints",
          },
          {
            "id": "s8",
            "title": "Advanced Stability",
            "focusAreas": ["Stability"],
            "duration": "13 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://images.unsplash.com/photo-1599744331120-3226c87a6e25",
            "semanticLabel":
                "Man performing side plank with leg raise on exercise mat",
            "exercises": [
              "Side Plank Variations",
              "Anti-rotation Press",
              "Stability Ball Work",
            ],
            "objectives": "Challenge stability with advanced progressions",
          },
          {
            "id": "s9",
            "title": "Postural Refinement",
            "focusAreas": ["Body Awareness"],
            "duration": "10 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://img.rocket.new/generatedImages/rocket_gen_img_16942d83e-1764441009013.png",
            "semanticLabel":
                "Person checking posture alignment in mirror during exercise session",
            "exercises": [
              "Posture Corrections",
              "Alignment Drills",
              "Proprioception Work",
            ],
            "objectives": "Refine postural awareness and alignment",
          },
        ],
      },
      {
        "weekNumber": 4,
        "title": "Mastery & Maintenance",
        "sessions": [
          {
            "id": "s10",
            "title": "Mobility Mastery",
            "focusAreas": ["Mobility"],
            "duration": "15 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://img.rocket.new/generatedImages/rocket_gen_img_1adf160e7-1764441008120.png",
            "semanticLabel":
                "Person demonstrating advanced stretching technique with full range of motion",
            "exercises": [
              "Advanced Stretches",
              "End-range Holds",
              "Mobility Flows",
            ],
            "objectives":
                "Master mobility techniques for long-term maintenance",
          },
          {
            "id": "s11",
            "title": "Integrated Stability",
            "focusAreas": ["Stability", "Mobility"],
            "duration": "14 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://images.unsplash.com/photo-1701327771236-24c15ad56c09",
            "semanticLabel":
                "Woman performing complex stability exercise combining balance and strength",
            "exercises": [
              "Complex Movements",
              "Stability Challenges",
              "Functional Patterns",
            ],
            "objectives":
                "Integrate stability into functional movement patterns",
          },
          {
            "id": "s12",
            "title": "Complete Integration",
            "focusAreas": ["Body Awareness", "Mobility", "Stability"],
            "duration": "15 minutes",
            "difficulty": "Intermediate",
            "thumbnail":
                "https://img.rocket.new/generatedImages/rocket_gen_img_1df953cc0-1764441012575.png",
            "semanticLabel":
                "Person performing comprehensive full-body exercise routine in fitness center",
            "exercises": [
              "Full Body Flow",
              "Integrated Movements",
              "Mindful Practice",
            ],
            "objectives": "Combine all elements into cohesive practice",
          },
        ],
      },
    ],
    "recommendations": [
      "Your assessment showed limited ankle mobility (score: 4/10). This program emphasizes ankle and hip mobility exercises in weeks 1-2.",
      "Stability scores were moderate (6/10). Progressive balance challenges are included throughout the program.",
      "Body awareness needs development (5/10). Breathing and postural exercises are integrated in every week.",
    ],
    "expectedOutcomes": [
      "Improved ankle dorsiflexion by 15-20 degrees",
      "Enhanced single-leg balance time by 30+ seconds",
      "Reduced postural pain by 40-50%",
      "Better body awareness and movement control",
    ],
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Your Program',
        variant: CustomAppBarVariant.standard,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _shareProgram,
            tooltip: 'Share Program',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Program Header
              ProgramHeaderWidget(
                duration: programData["duration"] as String,
                totalSessions: programData["totalSessions"] as int,
                weeklyTimeCommitment:
                    programData["weeklyTimeCommitment"] as String,
                startDate: programData["startDate"] as String,
                focusAreas: (programData["focusAreas"] as List).cast<String>(),
              ),

              SizedBox(height: 2.h),

              // Program Recommendations
              ProgramRecommendationsWidget(
                recommendations: (programData["recommendations"] as List)
                    .cast<String>(),
                expectedOutcomes: (programData["expectedOutcomes"] as List)
                    .cast<String>(),
              ),

              SizedBox(height: 3.h),

              // Weekly Sessions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'Weekly Breakdown',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Week Cards
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: (programData["weeks"] as List).length,
                itemBuilder: (context, index) {
                  final week =
                      (programData["weeks"] as List)[index]
                          as Map<String, dynamic>;
                  return WeeklySessionCardWidget(
                    weekNumber: week["weekNumber"] as int,
                    weekTitle: week["title"] as String,
                    sessions: (week["sessions"] as List)
                        .cast<Map<String, dynamic>>(),
                    onSessionTap: _showSessionPreview,
                  );
                },
              ),

              SizedBox(height: 3.h),

              // Action Buttons
              ProgramActionsWidget(
                onStartProgram: _startProgram,
                onCustomizeProgram: _showCustomizationModal,
              ),

              SizedBox(height: 3.h),

              // Re-assessment Option
              _buildReassessmentOption(theme),

              SizedBox(height: 10.h), // Bottom padding for navigation bar
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() => _currentBottomNavIndex = index);
        },
      ),
    );
  }

  /// Builds re-assessment option section
  Widget _buildReassessmentOption(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Not satisfied with your program?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'You can retake the assessment to generate a new personalized program based on updated results.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _retakeAssessment,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              label: Text('Retake Assessment'),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows session preview modal
  void _showSessionPreview(Map<String, dynamic> session) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Session thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImageWidget(
                        imageUrl: session["thumbnail"] as String,
                        width: double.infinity,
                        height: 25.h,
                        fit: BoxFit.cover,
                        semanticLabel: session["semanticLabel"] as String,
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Session title
                    Text(
                      session["title"] as String,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    // Session metadata
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: [
                        _buildMetadataChip(
                          theme,
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: theme.colorScheme.primary,
                            size: 16,
                          ),
                          session["duration"] as String,
                        ),
                        _buildMetadataChip(
                          theme,
                          CustomIconWidget(
                            iconName: 'trending_up',
                            color: theme.colorScheme.secondary,
                            size: 16,
                          ),
                          session["difficulty"] as String,
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Focus areas
                    Text(
                      'Focus Areas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (session["focusAreas"] as List).map((area) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            area as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 2.h),

                    // Objectives
                    Text(
                      'Objectives',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      session["objectives"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Exercise list
                    Text(
                      'Exercises',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(session["exercises"] as List).map((exercise) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 1.h),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'check_circle',
                              color: theme.colorScheme.secondary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                exercise as String,
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    SizedBox(height: 3.h),

                    // Close button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds metadata chip widget
  Widget _buildMetadataChip(ThemeData theme, Widget icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 1.w),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Shows customization modal
  void _showCustomizationModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomizationModalWidget(
        onSave: (frequency, focusEmphasis) {
          setState(() {
          });
          _showCustomizationSuccess();
        },
      ),
    );
  }

  /// Shows customization success message
  void _showCustomizationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Program customized successfully!'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Starts the program
  void _startProgram() {
    Navigator.pushNamed(context, '/session-player');
  }

  /// Shares program overview
  void _shareProgram() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Program sharing feature coming soon!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Retakes assessment with confirmation
  void _retakeAssessment() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Retake Assessment?'),
        content: Text(
          'This will discard your current program and generate a new one based on fresh assessment results. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/auto-assessment-hub');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text('Retake'),
          ),
        ],
      ),
    );
  }
}
