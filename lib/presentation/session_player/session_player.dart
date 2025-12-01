import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/exercise_info_widget.dart';
import './widgets/safety_controls_widget.dart';
import './widgets/session_timer_widget.dart';
import './widgets/video_player_widget.dart';

/// Session Player Screen - Delivers guided exercise sessions with integrated
/// video, audio instructions, and real-time timing functionality.
///
/// Features:
/// - Full-screen immersive video player with custom controls
/// - Real-time session timer with pause/resume functionality
/// - Audio guidance with independent volume controls
/// - Exercise progression tracking
/// - Safety features (modify for pain, emergency stop)
/// - Offline capability support
/// - Portrait orientation lock
/// - Haptic feedback for transitions
class SessionPlayer extends StatefulWidget {
  const SessionPlayer({super.key});

  @override
  State<SessionPlayer> createState() => _SessionPlayerState();
}

class _SessionPlayerState extends State<SessionPlayer>
    with WidgetsBindingObserver {
  // Session state
  int _currentExerciseIndex = 0;
  bool _isSessionPaused = false;
  bool _isSessionCompleted = false;
  bool _showModifyInstructions = false;

  // Timer state
  Timer? _sessionTimer;
  int _elapsedSeconds = 0;

  // Video state
  bool _isVideoPlaying = true;

  // Mock session data
  final List<Map<String, dynamic>> _exercises = [
    {
      "id": 1,
      "name": "Diaphragmatic Breathing",
      "duration": 90,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Lie on your back with knees bent. Place one hand on chest, one on belly. Breathe deeply through nose, feeling belly rise.",
      "modifyInstructions":
          "If lying down is uncomfortable, sit in a chair with back support. Reduce breathing depth if feeling dizzy.",
      "audioGuidance":
          "Breathe in slowly through your nose for 4 counts... Hold for 2... Exhale through mouth for 6 counts...",
      "nextExercise": "Cat-Cow Stretch"
    },
    {
      "id": 2,
      "name": "Cat-Cow Stretch",
      "duration": 120,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Start on hands and knees. Arch back looking up (cow), then round spine looking down (cat). Move slowly with breath.",
      "modifyInstructions":
          "If wrists hurt, use fists or forearms. If knees hurt, place cushion underneath. Reduce range of motion if needed.",
      "audioGuidance":
          "Inhale as you arch your back... Exhale as you round your spine... Move with your breath...",
      "nextExercise": "Hip Flexor Stretch"
    },
    {
      "id": 3,
      "name": "Hip Flexor Stretch",
      "duration": 60,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Kneel on one knee, other foot forward. Gently push hips forward until stretch felt in front of hip. Hold 30 seconds each side.",
      "modifyInstructions":
          "Use wall for balance. Place cushion under knee. Reduce forward push if pain occurs.",
      "audioGuidance":
          "Feel the gentle stretch in your hip flexor... Hold steady... Breathe normally...",
      "nextExercise": "Shoulder Rolls"
    },
    {
      "id": 4,
      "name": "Shoulder Rolls",
      "duration": 45,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Stand or sit tall. Roll shoulders backward in large circles. 10 repetitions backward, then 10 forward.",
      "modifyInstructions":
          "Reduce circle size if shoulder pain occurs. Can be done seated if standing is difficult.",
      "audioGuidance":
          "Roll your shoulders back... Make big circles... Feel the tension release...",
      "nextExercise": "Ankle Circles"
    },
    {
      "id": 5,
      "name": "Ankle Circles",
      "duration": 60,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Sit or stand holding support. Lift one foot, rotate ankle in circles. 10 circles each direction, both feet.",
      "modifyInstructions":
          "Sit down if balance is difficult. Make smaller circles if ankle is stiff. Use chair for support.",
      "audioGuidance":
          "Rotate your ankle slowly... Make full circles... Switch directions...",
      "nextExercise": "Spinal Twist"
    },
    {
      "id": 6,
      "name": "Spinal Twist",
      "duration": 90,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Sit tall in chair. Place right hand on left knee, left hand behind. Gently twist left. Hold 30 seconds. Repeat other side.",
      "modifyInstructions":
          "Reduce twist depth if back pain occurs. Keep shoulders relaxed. Breathe normally throughout.",
      "audioGuidance":
          "Twist gently from your core... Keep your spine tall... Breathe into the stretch...",
      "nextExercise": "Standing Balance"
    },
    {
      "id": 7,
      "name": "Standing Balance",
      "duration": 60,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Stand near wall. Lift one foot off ground, balance on other. Hold 20 seconds. Switch feet. Repeat 3 times each.",
      "modifyInstructions":
          "Touch wall lightly for support. Reduce hold time if too difficult. Can hold chair instead.",
      "audioGuidance":
          "Find your balance point... Keep your core engaged... Breathe steadily...",
      "nextExercise": "Cool Down Breathing"
    },
    {
      "id": 8,
      "name": "Cool Down Breathing",
      "duration": 120,
      "videoUrl": "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      "instructions":
          "Sit or lie comfortably. Close eyes. Breathe naturally, focusing on breath. Relax entire body. Stay for 2 minutes.",
      "modifyInstructions":
          "Any comfortable position works. If mind wanders, gently return focus to breath. No wrong way to do this.",
      "audioGuidance":
          "Let your body relax completely... Notice your natural breath... Feel the calm settling in...",
      "nextExercise": null
    }
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _lockOrientation();
    _startSessionTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _sessionTimer?.cancel();
    _unlockOrientation();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle for background timer accuracy
    if (state == AppLifecycleState.paused) {
      _pauseSession();
    } else if (state == AppLifecycleState.resumed) {
      if (!_isSessionPaused) {
        _resumeSession();
      }
    }
  }

  /// Lock screen orientation to portrait
  void _lockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Unlock screen orientation
  void _unlockOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Start session timer
  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isSessionPaused) {
        setState(() {
          _elapsedSeconds++;

          // Check if current exercise duration is complete
          final currentExercise = _exercises[_currentExerciseIndex];
          if (_elapsedSeconds >= (currentExercise["duration"] as int)) {
            _moveToNextExercise();
          }
        });
      }
    });
  }

  /// Move to next exercise
  void _moveToNextExercise() {
    HapticFeedback.mediumImpact();

    if (_currentExerciseIndex < _exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
        _elapsedSeconds = 0;
        _showModifyInstructions = false;
      });
    } else {
      _completeSession();
    }
  }

  /// Complete session
  void _completeSession() {
    _sessionTimer?.cancel();
    setState(() {
      _isSessionCompleted = true;
    });

    HapticFeedback.heavyImpact();

    // Navigate to post-session feedback after brief delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/post-session-feedback');
      }
    });
  }

  /// Pause session
  void _pauseSession() {
    setState(() {
      _isSessionPaused = true;
      _isVideoPlaying = false;
    });
  }

  /// Resume session
  void _resumeSession() {
    setState(() {
      _isSessionPaused = false;
      _isVideoPlaying = true;
    });
  }

  /// Toggle pause/resume
  void _togglePauseResume() {
    HapticFeedback.lightImpact();
    if (_isSessionPaused) {
      _resumeSession();
    } else {
      _pauseSession();
    }
  }

  /// Show emergency stop dialog
  void _showEmergencyStopDialog() {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Emergency Stop',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Text(
          'Are you experiencing pain or discomfort that requires stopping the session immediately?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Session'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sessionTimer?.cancel();
              Navigator.pushReplacementNamed(context, '/program-summary');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Stop Session'),
          ),
        ],
      ),
    );
  }

  /// Toggle modify instructions
  void _toggleModifyInstructions() {
    HapticFeedback.lightImpact();
    setState(() {
      _showModifyInstructions = !_showModifyInstructions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentExercise = _exercises[_currentExerciseIndex];
    final totalExercises = _exercises.length;
    final progress = (_currentExerciseIndex + 1) / totalExercises;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Session in Progress',
        variant: CustomAppBarVariant.transparent,
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: _isSessionPaused ? 'play_arrow' : 'pause',
              color: Colors.white,
              size: 24,
            ),
            onPressed: _togglePauseResume,
            tooltip: _isSessionPaused ? 'Resume' : 'Pause',
          ),
        ],
      ),
      body: SafeArea(
        child: _isSessionCompleted
            ? _buildCompletionScreen(theme)
            : _buildSessionContent(
                theme, currentExercise, totalExercises, progress),
      ),
    );
  }

  /// Build session content
  Widget _buildSessionContent(
    ThemeData theme,
    Map<String, dynamic> currentExercise,
    int totalExercises,
    double progress,
  ) {
    return Column(
      children: [
        // Video player section (upper two-thirds)
        Expanded(
          flex: 2,
          child: VideoPlayerWidget(
            videoUrl: currentExercise["videoUrl"] as String,
            isPlaying: _isVideoPlaying,
            onPlayPauseToggle: _togglePauseResume,
          ),
        ),

        // Session info and controls section (lower third)
        Expanded(
          flex: 1,
          child: Container(
            color: theme.colorScheme.surface,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session timer
                  SessionTimerWidget(
                    elapsedSeconds: _elapsedSeconds,
                    totalSeconds: currentExercise["duration"] as int,
                    isPaused: _isSessionPaused,
                  ),

                  SizedBox(height: 2.h),

                  // Exercise info
                  ExerciseInfoWidget(
                    exerciseName: currentExercise["name"] as String,
                    currentExercise: _currentExerciseIndex + 1,
                    totalExercises: totalExercises,
                    nextExercise: currentExercise["nextExercise"] as String?,
                    instructions: _showModifyInstructions
                        ? (currentExercise["modifyInstructions"] as String)
                        : (currentExercise["instructions"] as String),
                    progress: progress,
                  ),

                  SizedBox(height: 2.h),

                  // Safety controls
                  SafetyControlsWidget(
                    showModifyInstructions: _showModifyInstructions,
                    onModifyPressed: _toggleModifyInstructions,
                    onEmergencyStopPressed: _showEmergencyStopDialog,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build completion screen
  Widget _buildCompletionScreen(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: theme.colorScheme.secondary,
                  size: 12.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Session Complete!',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'Great work! You completed all ${_exercises.length} exercises.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'timer',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Total Time: ${(_elapsedSeconds ~/ 60)}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Redirecting to feedback...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
