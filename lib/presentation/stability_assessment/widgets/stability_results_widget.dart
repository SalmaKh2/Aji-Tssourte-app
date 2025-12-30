import 'package:flutter/material.dart';
import '../models/stability_test_model.dart';
import '../services/stability_scoring_service.dart';

class StabilityResultsWidget extends StatelessWidget {
  final StabilityResult result;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  const StabilityResultsWidget({
    super.key,
    required this.result,
    required this.onContinue,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final scoringService = StabilityScoringService();
    final recommendations = scoringService.generateRecommendations(result);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                const Text(
                  '🎉 Bilan Stabilité Terminé !',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Votre score : ${result.scoreGlobal.toStringAsFixed(1)}/10',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Score détaillé
          const Text(
            '📊 Scores détaillés',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildScoreCard(
                'Équilibre',
                result.scoreStabilite,
                Icons.balance,
                Colors.blue,
              ),
              _buildScoreCard(
                'Contrôle',
                result.scoreControle,
                Icons.touch_app,
                Colors.green,
              ),
              _buildScoreCard(
                'Alignement',
                result.scoreAlignement,
                Icons.straighten,
                Colors.orange,
              ),
              _buildScoreCard(
                'Global',
                result.scoreGlobal,
                Icons.star,
                Colors.purple,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Résultats des tests
          const Text(
            '🧪 Résultats par test',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          ...result.testResults.entries.map((entry) {
            final testResult = entry.value;
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getTestName(entry.key),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildMiniScore('Stabilité', testResult.stabilite),
                        _buildMiniScore('Contrôle', testResult.controle),
                        _buildMiniScore('Alignement', testResult.alignement),
                        if (testResult.tempsTenue > 0)
                          _buildMiniScore('Temps', testResult.tempsTenue, isTime: true),
                      ],
                    ),
                    if (testResult.douleur > 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          children: [
                            const Icon(Icons.warning, size: 16, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              'Douleur : ${testResult.douleur.toStringAsFixed(1)}/10',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          // Recommandations
          const Text(
            '💡 Recommandations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber),
                  const SizedBox(height: 12),
                  ...recommendations.map((recommendation) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Boutons d'action
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRetry,
                  child: const Text('Refaire le test'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreCard(String title, double score, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              score.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '/10',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniScore(String label, double value, {bool isTime = false}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            isTime ? '${value.toInt()}s' : value.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getTestName(String testId) {
    switch (testId) {
      case 'equilibre':
        return 'Équilibre Unipodal';
      case 'controle_genou':
        return 'Contrôle du Genou';
      case 'stabilite_lombaire':
        return 'Stabilité Lombaire';
      default:
        return 'Test';
    }
  }
}
