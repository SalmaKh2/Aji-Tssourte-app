import 'package:flutter/material.dart';
import '../models/stability_test_model.dart';

class StabilityQuestionnaire extends StatefulWidget {
  final List<StabilityQuestion> questions;
  final Map<String, int> initialAnswers;
  final ValueChanged<Map<String, int>> onAnswersChanged;

  const StabilityQuestionnaire({
    super.key,
    required this.questions,
    required this.initialAnswers,
    required this.onAnswersChanged,
  });

  @override
  State<StabilityQuestionnaire> createState() => _StabilityQuestionnaireState();
}

class _StabilityQuestionnaireState extends State<StabilityQuestionnaire> {
  late Map<String, int> _answers;

  @override
  void initState() {
    super.initState();
    _answers = Map.from(widget.initialAnswers);
  }

  void _updateAnswer(String questionId, int value) {
    setState(() {
      _answers[questionId] = value;
    });
    widget.onAnswersChanged(_answers);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📝 Questionnaire Stabilité',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Répondez en pensant à votre expérience quotidienne',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        
        ...widget.questions.map((question) {
          final currentValue = _answers[question.id] ?? 2;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Échelle
              Text(
                'Échelle : 0 (jamais) à 4 (toujours)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Boutons de notation
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(5, (index) {
                  final isSelected = currentValue == index;
                  final label = index == 0 ? '0\nJamais' :
                              index == 1 ? '1\nRarement' :
                              index == 2 ? '2\nParfois' :
                              index == 3 ? '3\nSouvent' : '4\nToujours';
                  
                  return ChoiceChip(
                    label: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : null,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      _updateAnswer(question.id, index);
                    },
                    selectedColor: question.inverse ? Colors.orange : Colors.blue,
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                }),
              ),
              
              // Indication pour les questions inverses
              if (question.inverse) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info, color: Colors.orange, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pour cette question, 0 est le meilleur score',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
            ],
          );
        }).toList(),
      ],
    );
  }
}
