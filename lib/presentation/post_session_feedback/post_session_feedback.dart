import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/energy_level_widget.dart';
import './widgets/motivational_stats_widget.dart';
import './widgets/notes_field_widget.dart';
import './widgets/pain_level_widget.dart';
import './widgets/rpe_rating_widget.dart';
import './widgets/session_stats_widget.dart';

/// Post-Session Feedback Screen
///
/// Captures essential user response data for program adaptation through
/// mobile-optimized rating interfaces. Appears immediately after session
/// completion using modal presentation preventing skip behavior.
class PostSessionFeedback extends StatefulWidget {
  const PostSessionFeedback({super.key});

  @override
  State<PostSessionFeedback> createState() => _PostSessionFeedbackState();
}

class _PostSessionFeedbackState extends State<PostSessionFeedback> {
  // Feedback values
  double _rpeRating = 5.0;
  double _painLevel = 0.0;
  String _energyLevel = 'Moderate';
  String _notes = '';

  // UI state
  bool _isSubmitting = false;
  int _currentBottomNavIndex = 3; // Progress tab

  // Session statistics (mock data)
  final Map<String, dynamic> _sessionData = {
    'duration': '12:45',
    'exercisesCompleted': 8,
    'sessionName': 'Mobility & Stability Session',
    'completedAt': DateTime.now(),
  };

  // User progress (mock data)
  final Map<String, dynamic> _userProgress = {
    'currentStreak': 5,
    'weeklyGoal': 3,
    'completedThisWeek': 2,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Session Feedback',
        variant: CustomAppBarVariant.centered,
        showBackButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Celebration header with session stats
                SessionStatsWidget(
                  sessionName: _sessionData['sessionName'] as String,
                  duration: _sessionData['duration'] as String,
                  exercisesCompleted: _sessionData['exercisesCompleted'] as int,
                ),

                SizedBox(height: 3.h),

                // RPE Rating Section
                RPERatingWidget(
                  initialValue: _rpeRating,
                  onChanged: (value) {
                    setState(() => _rpeRating = value);
                  },
                ),

                SizedBox(height: 3.h),

                // Pain Level Section
                PainLevelWidget(
                  initialValue: _painLevel,
                  onChanged: (value) {
                    setState(() => _painLevel = value);
                  },
                ),

                SizedBox(height: 3.h),

                // Energy Level Section
                EnergyLevelWidget(
                  selectedLevel: _energyLevel,
                  onChanged: (level) {
                    setState(() => _energyLevel = level);
                  },
                ),

                SizedBox(height: 3.h),

                // Notes Field Section
                NotesFieldWidget(
                  onChanged: (text) {
                    setState(() => _notes = text);
                  },
                ),

                SizedBox(height: 3.h),

                // Motivational Stats
                MotivationalStatsWidget(
                  currentStreak: _userProgress['currentStreak'] as int,
                  weeklyGoal: _userProgress['weeklyGoal'] as int,
                  completedThisWeek: _userProgress['completedThisWeek'] as int,
                ),

                SizedBox(height: 4.h),

                // Submit Button
                _buildSubmitButton(theme),

                SizedBox(height: 2.h),

                // Skip Notes Option
                _buildSkipNotesButton(theme),

                SizedBox(height: 2.h),
              ],
            ),
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

  /// Builds the submit feedback button
  Widget _buildSubmitButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: _isSubmitting ? null : _handleSubmitFeedback,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: _isSubmitting
          ? SizedBox(
              height: 2.5.h,
              width: 2.5.h,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Submit Feedback',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  /// Builds the skip notes button
  Widget _buildSkipNotesButton(ThemeData theme) {
    return TextButton(
      onPressed: _isSubmitting ? null : _handleSkipNotes,
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
      ),
      child: Text(
        'Skip Notes',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Handles feedback submission
  Future<void> _handleSubmitFeedback() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    // Validate mandatory fields
    if (_rpeRating == 0 || _painLevel < 0) {
      _showErrorMessage('Please complete all required ratings');
      setState(() => _isSubmitting = false);
      return;
    }

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    // Prepare feedback data
    final feedbackData = {
      'rpeRating': _rpeRating,
      'painLevel': _painLevel,
      'energyLevel': _energyLevel,
      'notes': _notes,
      'sessionId': _sessionData['sessionName'],
      'completedAt': _sessionData['completedAt'].toString(),
      'duration': _sessionData['duration'],
      'exercisesCompleted': _sessionData['exercisesCompleted'],
    };

    // Log feedback data (in production, send to backend)
    debugPrint('Feedback submitted: $feedbackData');

    // Show success animation
    _showSuccessAnimation();

    // Navigate to dashboard after delay
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/authentication-screen');
    }
  }

  /// Handles skip notes action
  Future<void> _handleSkipNotes() async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    // Validate mandatory fields only
    if (_rpeRating == 0 || _painLevel < 0) {
      _showErrorMessage('Please complete RPE and Pain ratings');
      setState(() => _isSubmitting = false);
      return;
    }

    // Submit without notes
    await _handleSubmitFeedback();
  }

  /// Shows error message
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Shows success animation
  void _showSuccessAnimation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 48,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Feedback Submitted!',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 1.h),
              Text(
                'Your progress has been recorded',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
