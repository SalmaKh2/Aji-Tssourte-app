import 'package:flutter/material.dart';
import '../presentation/auto_assessment_hub/auto_assessment_hub.dart';
import '../presentation/red_flags_alert/red_flags_alert.dart';
import '../presentation/program_summary/program_summary.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/session_player/session_player.dart';
import '../presentation/post_session_feedback/post_session_feedback.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String autoAssessmentHub = '/auto-assessment-hub';
  static const String redFlagsAlert = '/red-flags-alert';
  static const String programSummary = '/program-summary';
  static const String authentication = '/authentication-screen';
  static const String sessionPlayer = '/session-player';
  static const String postSessionFeedback = '/post-session-feedback';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const AuthenticationScreen(),
    autoAssessmentHub: (context) => const AutoAssessmentHub(),
    redFlagsAlert: (context) => const RedFlagsAlert(),
    programSummary: (context) => const ProgramSummary(),
    authentication: (context) => const AuthenticationScreen(),
    sessionPlayer: (context) => const SessionPlayer(),
    postSessionFeedback: (context) => const PostSessionFeedback(),
    // TODO: Add your other routes here
  };
}
