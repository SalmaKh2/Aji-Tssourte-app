import 'package:flutter/material.dart';
import '../models/mobility_test_model.dart';

class MobilityTestCard extends StatelessWidget {
  final MobilityTest test;
  final ValueChanged<MobilityTestResult> onCompleted;
  
  const MobilityTestCard({
    super.key,
    required this.test,
    required this.onCompleted,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              test.name,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              test.instruction,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Renvoie un résultat factice pour permettre la progression
                    final result = MobilityTestResult(
                      testId: test.id,
                      amplitude: 8.0,
                      facilite: 8.0,
                      douleur: 0.0,
                    );
                    onCompleted(result);
                  },
                  child: const Text('Terminer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
