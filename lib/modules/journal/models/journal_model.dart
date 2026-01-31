class JournalModel {
  final String id;
  final String livreurId;
  final double montant;
  final String lieuDepart;
  final String lieuArrivee;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  JournalModel({
    required this.id,
    required this.livreurId,
    required this.montant,
    required this.lieuDepart,
    required this.lieuArrivee,
    this.description,
    required this.date,
    required this.createdAt,
  });

  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] ?? '',
      livreurId: map['livreur_id'] ?? '',
      montant: (map['montant'] as num).toDouble(),
      lieuDepart: map['lieu_depart'] ?? '',
      lieuArrivee: map['lieu_arrivee'] ?? '',
      description: map['description'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'livreur_id': livreurId,
      'montant': montant,
      'lieu_depart': lieuDepart,
      'lieu_arrivee': lieuArrivee,
      'description': description,
      'date': date.toIso8601String(),
    };
  }
}
