import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Widget for conducting individual assessment tests with scoring
class AssessmentTestWidget extends StatefulWidget {
  final String moduleName;
  final List<Map<String, dynamic>> tests;
  final Function(Map<String, dynamic>) onComplete;
  final VoidCallback onExit;

  const AssessmentTestWidget({
    super.key,
    required this.moduleName,
    required this.tests,
    required this.onComplete,
    required this.onExit,
  });

  @override
  State<AssessmentTestWidget> createState() => _AssessmentTestWidgetState();
}

class _AssessmentTestWidgetState extends State<AssessmentTestWidget> {
  int _currentTestIndex = 0;
  bool _isTestActive = false;
  int _remainingTime = 0;
  Map<String, dynamic> _testResults = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTest = widget.tests[_currentTestIndex];
    final progress = (_currentTestIndex + 1) / widget.tests.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => _showExitDialog(context),
        ),
        title: Text(widget.moduleName, style: theme.textTheme.titleMedium),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _isTestActive
            ? _buildActiveTest(context, currentTest)
            : _buildTestInstructions(context, currentTest),
      ),
    );
  }

  /// Builds test instructions screen
  Widget _buildTestInstructions(
    BuildContext context,
    Map<String, dynamic> test,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Test counter
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Test ${_currentTestIndex + 1} of ${widget.tests.length}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Test name
          Text(
            test['name'] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 2.h),

          // Duration indicator
          if ((test['duration'] as int) > 0)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'timer',
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Duration: ${test['duration']} seconds',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 3.h),

          // Instructions
          Text(
            'Instructions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            test['instruction'] as String,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          SizedBox(height: 3.h),

          // Safety note
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconWidget(
                  iconName: 'warning',
                  color: theme.colorScheme.error,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Stop immediately if you experience severe pain or discomfort',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          // Start button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startTest(test),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: theme.colorScheme.primary,
              ),
              child: Text(
                'Start Test',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds active test screen with timer
  Widget _buildActiveTest(BuildContext context, Map<String, dynamic> test) {
    final theme = Theme.of(context);
    final duration = test['duration'] as int;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Test name
          Text(
            test['name'] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),

          // Timer display
          if (duration > 0)
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primaryContainer,
                border: Border.all(color: theme.colorScheme.primary, width: 4),
              ),
              child: Center(
                child: Text(
                  '$_remainingTime',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            )
          else
            CustomIconWidget(
              iconName: 'assignment',
              color: theme.colorScheme.primary,
              size: 80,
            ),
          SizedBox(height: 4.h),

          // Instruction reminder
          Text(
            test['instruction'] as String,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),

          // Complete button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _completeTest(test),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: theme.colorScheme.secondary,
              ),
              child: Text(
                duration > 0 && _remainingTime > 0
                    ? 'Stop Early'
                    : 'Complete Test',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Starts the test with timer
  void _startTest(Map<String, dynamic> test) {
    final duration = test['duration'] as int;

    setState(() {
      _isTestActive = true;
      _remainingTime = duration;
    });

    if (duration > 0) {
      _startTimer();
    }
  }

  /// Starts countdown timer
  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_isTestActive && _remainingTime > 0) {
        setState(() => _remainingTime--);
        _startTimer();
      } else if (_remainingTime == 0) {
        _completeTest(widget.tests[_currentTestIndex]);
      }
    });
  }

  /// Completes current test and shows scoring dialog
  void _completeTest(Map<String, dynamic> test) {
    setState(() => _isTestActive = false);
    _showScoringDialog(context, test);
  }

  /// Shows scoring dialog for test results
  void _showScoringDialog(BuildContext context, Map<String, dynamic> test) {
    final theme = Theme.of(context);
    final scoringCriteria = test['scoringCriteria'] as List<dynamic>;
    final Map<String, double> scores = {};

    for (var criterion in scoringCriteria) {
      scores[criterion as String] = 5.0;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            'Rate Your Performance',
            style: theme.textTheme.titleLarge,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test['name'] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 2.h),
                ...scoringCriteria.map((criterion) {
                  final criterionStr = criterion as String;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              criterionStr,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            scores[criterionStr]!.toInt().toString(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: scores[criterionStr]!,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        onChanged: (value) {
                          setDialogState(() => scores[criterionStr] = value);
                        },
                      ),
                      SizedBox(height: 1.h),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isTestActive = false);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveTestResults(test['name'] as String, scores);
                Navigator.pop(context);
                _moveToNextTest();
              },
              child: Text('Save & Continue'),
            ),
          ],
        ),
      ),
    );
  }

  /// Saves test results
  void _saveTestResults(String testName, Map<String, double> scores) {
    _testResults[testName] = {
      ...scores,
      'completed': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Moves to next test or completes assessment
  void _moveToNextTest() {
    if (_currentTestIndex < widget.tests.length - 1) {
      setState(() {
        _currentTestIndex++;
        _isTestActive = false;
      });
    } else {
      widget.onComplete(_testResults);
    }
  }

  /// Shows exit confirmation dialog
  void _showExitDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Assessment?', style: theme.textTheme.titleLarge),
        content: Text(
          'Your progress will not be saved if you exit now. Are you sure you want to leave?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onExit();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
            ),
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }
}
