class JournalModel {
  final String id;
  final String livreurId;
  final DateTime dateDebut;
  final DateTime? dateFin;
  final String statut; // "ouvert", "cloture"
  final double total;
  final DateTime createdAt;

  JournalModel({
    required this.id,
    required this.livreurId,
    required this.dateDebut,
    this.dateFin,
    required this.statut,
    this.total = 0.0,
    required this.createdAt,
  });

  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] ?? '',
      livreurId: map['livreur_id'] ?? '',
      dateDebut: DateTime.parse(map['date_debut']),
      dateFin: map['date_fin'] != null ? DateTime.parse(map['date_fin']) : null,
      statut: map['statut'] ?? 'ouvert',
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'livreur_id': livreurId,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin?.toIso8601String(),
      'statut': statut,
      'total': total,
    };
  }

  // Getters de compatibilité
  double get montant => total;
  DateTime get date => dateDebut;
}
