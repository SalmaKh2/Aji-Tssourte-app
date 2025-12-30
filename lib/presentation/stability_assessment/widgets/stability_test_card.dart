import 'package:flutter/material.dart';
import '../models/stability_test_model.dart';

class StabilityTestCard extends StatelessWidget {
  final StabilityTest test;
  final bool isActive;
  final bool isCompleted;
  final VoidCallback onStartTest;

  const StabilityTestCard({
    super.key,
    required this.test,
    this.isActive = false,
    this.isCompleted = false,
    required this.onStartTest,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isActive ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isActive ? test.color : Colors.transparent,
          width: isActive ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: !isCompleted ? onStartTest : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: test.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(test.icon, color: test.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          test.subtitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                test.instruction,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.timer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${test.duration} secondes',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  if (!isCompleted)
                    ElevatedButton(
                      onPressed: onStartTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: test.color,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Commencer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
              if (test.tips.isNotEmpty) ...[
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Conseils :',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...test.tips.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.circle, size: 8, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tip,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
