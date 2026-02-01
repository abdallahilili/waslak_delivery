import 'dart:convert';

class RestaurantModel {
  final String id;
  final String placeId;
  final String nom;
  final String typeCuisine;
  final String? description;
  final Map<String, dynamic>? menu; // Keeping it flexible as Map for JSONB
  final String? logoUrl;
  final String? couvertureUrl;
  final bool actif;
  final DateTime? createdAt;

  RestaurantModel({
    required this.id,
    required this.placeId,
    required this.nom,
    required this.typeCuisine,
    this.description,
    this.menu,
    this.logoUrl,
    this.couvertureUrl,
    this.actif = true,
    this.createdAt,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'] ?? '',
      placeId: map['place_id'] ?? '',
      nom: map['nom'] ?? '',
      typeCuisine: map['type_cuisine'] ?? '',
      description: map['description'],
      menu: map['menu'] != null 
          ? (map['menu'] is String ? jsonDecode(map['menu']) : map['menu']) 
          : null,
      logoUrl: map['logo_url'],
      couvertureUrl: map['couverture_url'],
      actif: map['actif'] ?? true,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'place_id': placeId,
      'nom': nom,
      'type_cuisine': typeCuisine,
      'description': description,
      'menu': menu,
      'logo_url': logoUrl,
      'couverture_url': couvertureUrl,
      'actif': actif,
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? placeId,
    String? nom,
    String? typeCuisine,
    String? description,
    Map<String, dynamic>? menu,
    String? logoUrl,
    String? couvertureUrl,
    bool? actif,
    DateTime? createdAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      nom: nom ?? this.nom,
      typeCuisine: typeCuisine ?? this.typeCuisine,
      description: description ?? this.description,
      menu: menu ?? this.menu,
      logoUrl: logoUrl ?? this.logoUrl,
      couvertureUrl: couvertureUrl ?? this.couvertureUrl,
      actif: actif ?? this.actif,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
