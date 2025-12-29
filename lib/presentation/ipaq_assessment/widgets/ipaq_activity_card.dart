// lib/presentation/ipaq_assessment/widgets/ipaq_activity_card.dart

import 'package:flutter/material.dart';

class IpaqActivityCard extends StatelessWidget {
  final String activityType;
  final double metMinutes;
  final int days;
  final double minutesPerDay;
  final Color color;

  const IpaqActivityCard({
    super.key,
    required this.activityType,
    required this.metMinutes,
    required this.days,
    required this.minutesPerDay,
    required this.color,
  });

  String get activityTitle {
    switch (activityType) {
      case 'vigorous':
        return 'Activité Vigoureuse';
      case 'moderate':
        return 'Activité Modérée';
      case 'walking':
        return 'Marche';
      default:
        return activityType;
    }
  }

  String get activityIcon {
    switch (activityType) {
      case 'vigorous':
        return '💪';
      case 'moderate':
        return '🚴';
      case 'walking':
        return '🚶';
      default:
        return '🏃';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                activityIcon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Détails
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$days jours × ${minutesPerDay.round()} min/jour',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${metMinutes.round()} MET-min/semaine',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
