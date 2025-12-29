class IpaqQuestion {
  final int id;
  final String question;
  final String description;
  final String hint;
  final List<String> options;
  final String type; // 'frequence', 'duree'
  final String unite; // 'jours', 'minutes', 'heures'

  IpaqQuestion({
    required this.id,
    required this.question,
    required this.description,
    required this.hint,
    required this.options,
    required this.type,
    required this.unite,
  });

  // Factory pour créer depuis JSON
  factory IpaqQuestion.fromJson(Map<String, dynamic> json) {
    return IpaqQuestion(
      id: json['id'],
      question: json['question'],
      description: json['description'],
      hint: json['hint'],
      options: List<String>.from(json['options']),
      type: json['type'],
      unite: json['unite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'description': description,
      'hint': hint,
      'options': options,
      'type': type,
      'unite': unite,
    };
  }
}
