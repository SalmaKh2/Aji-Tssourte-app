class MobilityTest {
  final String id;
  final String name;
  final String instruction;
  final int duration; // en secondes
  final List<String> scoringCriteria;
  final String? videoGuidance;
  
  MobilityTest({
    required this.id,
    required this.name,
    required this.instruction,
    required this.duration,
    required this.scoringCriteria,
    this.videoGuidance,
  });
}

class MobilityTestResult {
  final String testId;
  final double amplitude; // 0-10
  final double facilite;  // 0-10
  final double douleur;   // 0-10
  
  MobilityTestResult({
    required this.testId,
    required this.amplitude,
    required this.facilite,
    required this.douleur,
  });
}
