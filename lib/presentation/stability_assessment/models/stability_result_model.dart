enum StabilityLevel {
  excellent,
  good,
  moderate,
  poor,
}

class StabilityAssessmentResult {
  final StabilityLevel level;
  final double overallScore;
  final Map<String, dynamic> details;
  final List<String> recommendations;

  StabilityAssessmentResult({
    required this.level,
    required this.overallScore,
    required this.details,
    required this.recommendations,
  });

  factory StabilityAssessmentResult.fromJson(Map<String, dynamic> json) {
    return StabilityAssessmentResult(
      level: StabilityLevel.values.firstWhere(
        (e) => e.toString() == json['level'],
        orElse: () => StabilityLevel.moderate,
      ),
      overallScore: json['overallScore'].toDouble(),
      details: Map<String, dynamic>.from(json['details']),
      recommendations: List<String>.from(json['recommendations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level.name,
      'overallScore': overallScore,
      'details': details,
      'recommendations': recommendations,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  String get levelDescription {
    switch (level) {
      case StabilityLevel.excellent:
        return 'Stabilité Excellente';
      case StabilityLevel.good:
        return 'Stabilité Bonne';
      case StabilityLevel.moderate:
        return 'Stabilité Moyenne';
      case StabilityLevel.poor:
        return 'Stabilité à Améliorer';
    }
  }
}
