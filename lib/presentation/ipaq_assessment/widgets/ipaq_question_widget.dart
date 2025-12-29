// lib/presentation/ipaq_assessment/widgets/ipaq_question_widget.dart

import 'package:flutter/material.dart';
import '../models/ipaq_question_model.dart';

class IpaqQuestionWidget extends StatelessWidget {
  final IpaqQuestion question;
  final dynamic currentValue;
  final ValueChanged<dynamic> onAnswer;
  final bool isLastQuestion;

  const IpaqQuestionWidget({
    super.key,
    required this.question,
    required this.currentValue,
    required this.onAnswer,
    this.isLastQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Numéro de question
            Text(
              'Question ${question.id}/7',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Titre de la question
            Text(
              question.question,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Text(
              question.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),

            // Indice (si disponible)
            if (question.hint.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question.hint,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Options de réponse
            if (question.type == 'frequency')
              _buildFrequencyOptions(theme)
            else
              _buildDurationOptions(theme),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyOptions(ThemeData theme) {
    return Column(
      children: question.options.map((option) {
        final isSelected = currentValue == option;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onAnswer(option),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$option ${question.unite}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDurationOptions(ThemeData theme) {
    return Column(
      children: question.options.map((option) {
        final isSelected = currentValue == option;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onAnswer(option),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withOpacity(0.2),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _getDurationEmoji(option),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          option,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (question.id == 7) // Sitting question
                          Text(
                            _getSittingDescription(option),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getDurationEmoji(String option) {
    switch (option) {
      case 'Less than 10 min':
        return '⚡';
      case '10-30 min':
        return '🏃';
      case '31-60 min':
        return '⏱️';
      case 'More than 60 min':
        return '🔥';
      case 'Less than 4 hours':
        return '💺';
      case '4-6 hours':
        return '🪑';
      case '7-9 hours':
        return '🛋️';
      case 'More than 9 hours':
        return '🚗';
      default:
        return '⏰';
    }
  }

  String _getSittingDescription(String option) {
    switch (option) {
      case 'Less than 4 hours':
        return 'Faible temps assis';
      case '4-6 hours':
        return 'Modéré';
      case '7-9 hours':
        return 'Élevé (bureau)';
      case 'More than 9 hours':
        return 'Très élevé';
      default:
        return '';
    }
  }
}
