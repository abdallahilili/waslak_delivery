class JournalLigneModel {
  final String id;
  final String journalId;
  final String livreurId;
  final String placeDepartId;
  final String placeArriveeId;
  final String? restaurantId;
  final double montant;
  final String? commissionId;
  final String? description;
  final DateTime date;
  final DateTime createdAt;

  // Optional: Place names for display
  final String? placeDepartNom;
  final String? placeArriveeNom;

  JournalLigneModel({
    required this.id,
    required this.journalId,
    required this.livreurId,
    required this.placeDepartId,
    required this.placeArriveeId,
    this.restaurantId,
    required this.montant,
    this.commissionId,
    this.description,
    required this.date,
    required this.createdAt,
    this.placeDepartNom,
    this.placeArriveeNom,
  });

  factory JournalLigneModel.fromMap(Map<String, dynamic> map) {
    return JournalLigneModel(
      id: map['id'] ?? '',
      journalId: map['journal_id'] ?? '',
      livreurId: map['livreur_id'] ?? '',
      placeDepartId: map['place_depart_id'] ?? '',
      placeArriveeId: map['place_arrivee_id'] ?? '',
      restaurantId: map['restaurant_id'],
      montant: (map['montant'] as num?)?.toDouble() ?? 0.0,
      commissionId: map['commission_id'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : DateTime.now(),
      placeDepartNom: map['places_depart']?['nom'],
      placeArriveeNom: map['places_arrivee']?['nom'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'journal_id': journalId,
      'livreur_id': livreurId,
      'place_depart_id': placeDepartId,
      'place_arrivee_id': placeArriveeId,
      'restaurant_id': restaurantId,
      'montant': montant,
      'commission_id': commissionId,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  // Getters de compatibilité
  String get lieuDepart => placeDepartNom ?? '';
  String get lieuArrivee => placeArriveeNom ?? '';
}
