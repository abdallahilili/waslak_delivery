import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardStatsModel {
  final int commandesAujourdhui;
  final double revenusAujourdhui;
  final int livreursEnLigne;
  final double tauxCompletion;
  final double variationCommandes;
  final double variationRevenus;
  final double variationLivreurs;
  final double variationCompletion;

  DashboardStatsModel({
    required this.commandesAujourdhui,
    required this.revenusAujourdhui,
    required this.livreursEnLigne,
    required this.tauxCompletion,
    required this.variationCommandes,
    required this.variationRevenus,
    required this.variationLivreurs,
    required this.variationCompletion,
  });

  factory DashboardStatsModel.empty() {
    return DashboardStatsModel(
      commandesAujourdhui: 0,
      revenusAujourdhui: 0,
      livreursEnLigne: 0,
      tauxCompletion: 0,
      variationCommandes: 0,
      variationRevenus: 0,
      variationLivreurs: 0,
      variationCompletion: 0,
    );
  }

  factory DashboardStatsModel.fromMap(Map<String, dynamic> map) {
    return DashboardStatsModel(
      commandesAujourdhui: map['commandes_aujourdhui'] ?? 0,
      revenusAujourdhui: (map['revenus_aujourdhui'] as num?)?.toDouble() ?? 0.0,
      livreursEnLigne: map['livreurs_en_ligne'] ?? 0,
      tauxCompletion: (map['taux_completion'] as num?)?.toDouble() ?? 0.0,
      variationCommandes: (map['variation_commandes'] as num?)?.toDouble() ?? 0.0,
      variationRevenus: (map['variation_revenus'] as num?)?.toDouble() ?? 0.0,
      variationLivreurs: (map['variation_livreurs'] as num?)?.toDouble() ?? 0.0,
      variationCompletion: (map['variation_completion'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class DashboardChartData {
  final DateTime date;
  final double value;

  DashboardChartData(this.date, this.value);
}

class LivreurPosition {
  final String id;
  final String nom;
  final double lat;
  final double lng;
  final String statut;

  LivreurPosition({
    required this.id,
    required this.nom,
    required this.lat,
    required this.lng,
    required this.statut,
  });

  LatLng get position => LatLng(lat, lng);

  factory LivreurPosition.fromMap(Map<String, dynamic> map) {
    return LivreurPosition(
      id: map['id'],
      nom: map['nom'] ?? 'Inconnu',
      lat: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      lng: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      statut: map['statut'] ?? 'off',
    );
  }
}

class DashboardCommande {
  final String id;
  final String numero;
  final String client;
  final String? livreur;
  final String statut;
  final double montant;
  final DateTime date;

  DashboardCommande({
    required this.id,
    required this.numero,
    required this.client,
    this.livreur,
    required this.statut,
    required this.montant,
    required this.date,
  });

  factory DashboardCommande.fromMap(Map<String, dynamic> map) {
    return DashboardCommande(
      id: map['id'],
      numero: map['numero'] ?? map['id'].toString().substring(0, 8),
      client: map['client_nom'] ?? 'Client',
      livreur: map['livreur']?['nom'] ?? map['livreur_nom'],
      statut: map['statut'] ?? 'en_attente',
      montant: (map['montant'] as num?)?.toDouble() ?? 0.0,
      date: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class DashboardAlert {
  final String id;
  final String message;
  final String type; // 'warning', 'error', 'info'
  final DateTime date;

  DashboardAlert({
    required this.id,
    required this.message,
    required this.type,
    required this.date,
  });
}
