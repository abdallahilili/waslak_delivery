class PlaceModel {
  final String id;
  final String nom;
  final String type; // restaurant | client | depot | autre
  final String? telephone;
  final String? adresse;
  final double latitude;
  final double longitude;
  final bool actif;
  final DateTime createdAt;

  PlaceModel({
    required this.id,
    required this.nom,
    required this.type,
    this.telephone,
    this.adresse,
    required this.latitude,
    required this.longitude,
    this.actif = true,
    required this.createdAt,
  });

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      id: map['id'] ?? '',
      nom: map['nom'] ?? '',
      type: map['type'] ?? 'autre',
      telephone: map['telephone'],
      adresse: map['adresse'],
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      actif: map['actif'] ?? true,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'type': type,
      'telephone': telephone,
      'adresse': adresse,
      'latitude': latitude,
      'longitude': longitude,
      'actif': actif,
    };
  }
}
