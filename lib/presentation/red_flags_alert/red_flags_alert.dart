import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/guidance_section_widget.dart';
import './widgets/red_flags_list_widget.dart';
import './widgets/warning_header_widget.dart';

/// Red Flags Alert Screen
///
/// Provides critical safety intervention when assessment detects high pain levels,
/// neurological symptoms, or test inability requiring medical consultation.
///
/// Features:
/// - Full-screen modal with urgent but non-alarming design
/// - Cannot be dismissed without acknowledgment
/// - Lists specific detected red flags
/// - Provides actionable guidance for medical consultation
/// - Blocks program access until acknowledgment
/// - Logs safety events for monitoring
class RedFlagsAlert extends StatefulWidget {
  const RedFlagsAlert({super.key});

  @override
  State<RedFlagsAlert> createState() => _RedFlagsAlertState();
}

class _RedFlagsAlertState extends State<RedFlagsAlert> {
  bool _hasAcknowledged = false;
  bool _isProcessing = false;

  // Mock detected red flags data
  final List<Map<String, dynamic>> _detectedRedFlags = [
    {
      "id": 1,
      "type": "high_pain",
      "title": "High Pain Level Detected",
      "description":
          "You reported pain levels above 7/10 during assessment. This indicates significant discomfort that requires professional evaluation.",
      "icon": "warning",
      "severity": "critical",
    },
    {
      "id": 2,
      "type": "test_inability",
      "title": "Unable to Complete Basic Tests",
      "description":
          "You were unable to complete one or more basic movement tests. This may indicate underlying issues that need medical attention.",
      "icon": "block",
      "severity": "high",
    },
  ];

  @override
  void initState() {
    super.initState();
    _logRedFlagEvent();
  }

  /// Logs red flag detection event for safety monitoring
  void _logRedFlagEvent() {
    final timestamp = DateTime.now();
    debugPrint('[Safety Alert] Red flags detected at $timestamp');
    debugPrint(
      '[Safety Alert] Flags: ${_detectedRedFlags.map((f) => f["type"]).join(", ")}',
    );
  }

  /// Handles acknowledgment checkbox change
  void _handleAcknowledgmentChange(bool? value) {
    setState(() {
      _hasAcknowledged = value ?? false;
    });
  }

  /// Handles "Find Healthcare Providers" action
  Future<void> _handleFindProviders() async {
    setState(() => _isProcessing = true);

    // Simulate opening external directory or maps application
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Opening healthcare provider directory...'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() => _isProcessing = false);
  }

  /// Handles "I Understand" action with acknowledgment requirement
  Future<void> _handleAcknowledgment() async {
    if (!_hasAcknowledged) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Please confirm that you understand the importance of medical consultation',
          ),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    // Log acknowledgment event
    debugPrint(
      '[Safety Alert] User acknowledged medical consultation requirement at ${DateTime.now()}',
    );

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Navigate back to assessment results with program access disabled
    Navigator.pushReplacementNamed(context, '/auto-assessment-hub');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false, // Prevent back navigation without acknowledgment
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Warning header section
                  WarningHeaderWidget(),

                  SizedBox(height: 3.h),

                  // Red flags list section
                  RedFlagsListWidget(redFlags: _detectedRedFlags),

                  SizedBox(height: 3.h),

                  // Guidance section
                  GuidanceSectionWidget(),

                  SizedBox(height: 3.h),

                  // Emergency contact information
                  _buildEmergencyContact(theme),

                  SizedBox(height: 3.h),

                  // Disclaimer text
                  _buildDisclaimer(theme),

                  SizedBox(height: 3.h),

                  // Acknowledgment checkbox
                  _buildAcknowledgmentCheckbox(theme),

                  SizedBox(height: 3.h),

                  // Action buttons
                  ActionButtonsWidget(
                    hasAcknowledged: _hasAcknowledged,
                    isProcessing: _isProcessing,
                    onFindProviders: _handleFindProviders,
                    onAcknowledge: _handleAcknowledgment,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds emergency contact information section
  Widget _buildEmergencyContact(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'phone',
            color: theme.colorScheme.error,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Contact',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'If you experience severe pain or symptoms, call emergency services immediately',
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

  /// Builds disclaimer text section
  Widget _buildDisclaimer(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
                'Important Disclaimer',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'This app is designed to support your wellness journey but is not a substitute for professional medical advice, diagnosis, or treatment. The assessments and exercises provided are for general fitness purposes only.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds acknowledgment checkbox section
  Widget _buildAcknowledgmentCheckbox(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _hasAcknowledged,
              onChanged: _isProcessing ? null : _handleAcknowledgmentChange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: GestureDetector(
              onTap: _isProcessing
                  ? null
                  : () => _handleAcknowledgmentChange(!_hasAcknowledged),
              child: Text(
                'I understand that I need to consult with a healthcare professional before starting any exercise program. I acknowledge that program access will be disabled until I receive medical clearance.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
