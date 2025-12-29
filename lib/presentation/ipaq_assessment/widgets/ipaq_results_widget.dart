import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum NiveauActivite {
  sedentaire,
  faible,
  modere,
  eleve,
}

class IpaqResult {
  final NiveauActivite niveauActivite;
  final double scoreMET;
  final List<String> recommandations;
  final Map<String, dynamic> details;

  IpaqResult({
    required this.niveauActivite,
    required this.scoreMET,
    required this.recommandations,
    required this.details,
  });

  String get descriptionNiveau {
    switch (niveauActivite) {
      case NiveauActivite.sedentaire:
        return 'Sédentaire';
      case NiveauActivite.faible:
        return 'Faible activité';
      case NiveauActivite.modere:
        return 'Activité modérée';
      case NiveauActivite.eleve:
        return 'Activité élevée';
    }
  }

  String get couleurNiveau {
    switch (niveauActivite) {
      case NiveauActivite.sedentaire:
        return '#FF5252'; // Rouge
      case NiveauActivite.faible:
        return '#FFB74D'; // Orange
      case NiveauActivite.modere:
        return '#4CAF50'; // Vert
      case NiveauActivite.eleve:
        return '#2196F3'; // Bleu
    }
  }

  factory IpaqResult.fromJson(Map<String, dynamic> json) {
    return IpaqResult(
      niveauActivite: NiveauActivite.values.firstWhere(
        (e) => e.toString() == json['niveauActivite'],
        orElse: () => NiveauActivite.sedentaire,
      ),
      scoreMET: json['scoreMET'].toDouble(),
      recommandations: List<String>.from(json['recommandations']),
      details: Map<String, dynamic>.from(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'niveauActivite': niveauActivite.name,
      'scoreMET': scoreMET,
      'recommandations': recommandations,
      'details': details,
    };
  }
}

class IpaqResultsWidget extends StatelessWidget {
  final IpaqResult results;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  const IpaqResultsWidget({
    super.key,
    required this.results,
    required this.onContinue,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorValue = results.couleurNiveau;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Résumé des résultats
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(int.parse('0x${colorValue.replaceFirst('#', 'FF')}')),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Votre niveau d\'activité physique',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                results.descriptionNiveau,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Color(int.parse('0x${colorValue.replaceFirst('#', 'FF')}')),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Score MET-min/semaine',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${results.scoreMET.toStringAsFixed(1)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        
        // Recommandations
        if (results.recommandations.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommandations',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              ...results.recommandations.map((rec) => Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 5.w,
                      color: theme.colorScheme.primary,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        rec,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
              SizedBox(height: 2.h),
            ],
          ),

        // Boutons d'action
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onRetry,
                child: Text('Recommencer'),
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onContinue,
                child: Text('Continuer'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
