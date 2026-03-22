class LivreurModel {
  final String id;
  final String nom;
  final String? prenom;
  final String nni;
  final String telephone;
  final String? whatsapp;
  final String? email;
  final DateTime? dateNaissance;
  
  // Adresse
  final String? adresse;
  final String? ville;
  final String? quartier;
  final String? zoneService;
  
  // Véhicule
  final String? typeVehicule; // 'moto', 'voiture', etc.
  final String? marque;
  final String? modele;
  final String? immatriculation;
  final String? couleur;
  final int? annee;
  
  // Documents / URLs
  final String? photoProfilUrl;
  final String? photoCniUrl;
  final String? photoPermisUrl;
  final String? photoCarteGriseUrl;
  final String? photoAssuranceUrl;
  final String? photoMotoUrl;
  final DateTime? dateExpirationPermis;
  final DateTime? dateExpirationAssurance;
  
  // Configuration / Stats
  final String statut; // 'actif', 'inactif', 'bloque'
  final double commissionPlateforme;
  final int priorite;
  final bool estFavori;
  final double note;
  
  // Compteurs (Read-only)
  final int nbLivraisonsAcceptees;
  final int nbLivraisonsAnnulees;
  final int nbLivraisonsCompletees;
  final int nbLivraisonsIgnorees;
  final int nbLivraisonsRefusees;
  final int nbLivraisonsTotal;
  
  final DateTime createdAt;

  LivreurModel({
    required this.id,
    required this.nom,
    this.prenom,
    required this.nni,
    required this.telephone,
    this.whatsapp,
    this.email,
    this.dateNaissance,
    this.adresse,
    this.ville,
    this.quartier,
    this.zoneService,
    this.typeVehicule,
    this.marque,
    this.modele,
    this.immatriculation,
    this.couleur,
    this.annee,
    this.photoProfilUrl,
    this.photoCniUrl,
    this.photoPermisUrl,
    this.photoCarteGriseUrl,
    this.photoAssuranceUrl,
    this.photoMotoUrl,
    this.dateExpirationPermis,
    this.dateExpirationAssurance,
    required this.statut,
    this.commissionPlateforme = 10.0,
    this.priorite = 0,
    this.estFavori = false,
    this.note = 0.0,
    this.nbLivraisonsAcceptees = 0,
    this.nbLivraisonsAnnulees = 0,
    this.nbLivraisonsCompletees = 0,
    this.nbLivraisonsIgnorees = 0,
    this.nbLivraisonsRefusees = 0,
    this.nbLivraisonsTotal = 0,
    required this.createdAt,
  });

  // Getters calculés
  double get tauxAcceptation {
    if (nbLivraisonsTotal == 0) return 0;
    return (nbLivraisonsAcceptees / nbLivraisonsTotal) * 100;
  }

  double get tauxCompletion {
    if (nbLivraisonsAcceptees == 0) return 0;
    return (nbLivraisonsCompletees / nbLivraisonsAcceptees) * 100;
  }

  factory LivreurModel.fromMap(Map<String, dynamic> map) {
    return LivreurModel(
      id: map['id'] ?? '',
      nom: map['nom'] ?? '',
      prenom: map['prenom'],
      nni: map['nni'] ?? '',
      telephone: map['telephone'] ?? '',
      whatsapp: map['whatsapp'],
      email: map['email'],
      dateNaissance: map['date_naissance'] != null ? DateTime.parse(map['date_naissance']) : null,
      adresse: map['adresse'],
      ville: map['ville'],
      quartier: map['quartier'],
      zoneService: map['zone_service'],
      typeVehicule: map['type_vehicule'],
      marque: map['marque'],
      modele: map['modele'],
      immatriculation: map['immatriculation'],
      couleur: map['couleur'],
      annee: map['annee'],
      photoProfilUrl: map['photo_profil_url'],
      photoCniUrl: map['photo_cni_url'],
      photoPermisUrl: map['photo_permis_url'],
      photoCarteGriseUrl: map['photo_carte_grise_url'],
      photoAssuranceUrl: map['photo_assurance_url'],
      photoMotoUrl: map['photo_moto_url'],
      dateExpirationPermis: map['date_expiration_permis'] != null ? DateTime.parse(map['date_expiration_permis']) : null,
      dateExpirationAssurance: map['date_expiration_assurance'] != null ? DateTime.parse(map['date_expiration_assurance']) : null,
      statut: map['statut'] ?? 'actif',
      commissionPlateforme: (map['commission_plateforme'] as num?)?.toDouble() ?? 10.0,
      priorite: map['priorite'] ?? 0,
      estFavori: map['est_favori'] ?? false,
      note: (map['note'] as num?)?.toDouble() ?? 0.0,
      nbLivraisonsAcceptees: map['nb_livraisons_acceptees'] ?? 0,
      nbLivraisonsAnnulees: map['nb_livraisons_annulees'] ?? 0,
      nbLivraisonsCompletees: map['nb_livraisons_completees'] ?? 0,
      nbLivraisonsIgnorees: map['nb_livraisons_ignorees'] ?? 0,
      nbLivraisonsRefusees: map['nb_livraisons_refusees'] ?? 0,
      nbLivraisonsTotal: map['nb_livraisons_total'] ?? 0,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'nni': nni,
      'telephone': telephone,
      'whatsapp': whatsapp,
      'email': email,
      'date_naissance': dateNaissance?.toIso8601String(),
      'adresse': adresse,
      'ville': ville,
      'quartier': quartier,
      'zone_service': zoneService,
      'type_vehicule': typeVehicule,
      'marque': marque,
      'modele': modele,
      'immatriculation': immatriculation,
      'couleur': couleur,
      'annee': annee,
      'photo_profil_url': photoProfilUrl,
      'photo_cni_url': photoCniUrl,
      'photo_permis_url': photoPermisUrl,
      'photo_carte_grise_url': photoCarteGriseUrl,
      'photo_assurance_url': photoAssuranceUrl,
      'photo_moto_url': photoMotoUrl,
      'date_expiration_permis': dateExpirationPermis?.toIso8601String(),
      'date_expiration_assurance': dateExpirationAssurance?.toIso8601String(),
      'statut': statut,
      'commission_plateforme': commissionPlateforme,
      'priorite': priorite,
      'est_favori': estFavori,
      'note': note,
    };
  }

  LivreurModel copyWith({
    String? id,
    String? nom,
    String? prenom,
    String? nni,
    String? telephone,
    String? whatsapp,
    String? email,
    DateTime? dateNaissance,
    String? adresse,
    String? ville,
    String? quartier,
    String? zoneService,
    String? typeVehicule,
    String? marque,
    String? modele,
    String? immatriculation,
    String? couleur,
    int? annee,
    String? photoProfilUrl,
    String? photoCniUrl,
    String? photoPermisUrl,
    String? photoCarteGriseUrl,
    String? photoAssuranceUrl,
    String? photoMotoUrl,
    DateTime? dateExpirationPermis,
    DateTime? dateExpirationAssurance,
    String? statut,
    double? commissionPlateforme,
    int? priorite,
    bool? estFavori,
    double? note,
    int? nbLivraisonsAcceptees,
    int? nbLivraisonsAnnulees,
    int? nbLivraisonsCompletees,
    int? nbLivraisonsIgnorees,
    int? nbLivraisonsRefusees,
    int? nbLivraisonsTotal,
    DateTime? createdAt,
  }) {
    return LivreurModel(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      prenom: prenom ?? this.prenom,
      nni: nni ?? this.nni,
      telephone: telephone ?? this.telephone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      dateNaissance: dateNaissance ?? this.dateNaissance,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      quartier: quartier ?? this.quartier,
      zoneService: zoneService ?? this.zoneService,
      typeVehicule: typeVehicule ?? this.typeVehicule,
      marque: marque ?? this.marque,
      modele: modele ?? this.modele,
      immatriculation: immatriculation ?? this.immatriculation,
      couleur: couleur ?? this.couleur,
      annee: annee ?? this.annee,
      photoProfilUrl: photoProfilUrl ?? this.photoProfilUrl,
      photoCniUrl: photoCniUrl ?? this.photoCniUrl,
      photoPermisUrl: photoPermisUrl ?? this.photoPermisUrl,
      photoCarteGriseUrl: photoCarteGriseUrl ?? this.photoCarteGriseUrl,
      photoAssuranceUrl: photoAssuranceUrl ?? this.photoAssuranceUrl,
      photoMotoUrl: photoMotoUrl ?? this.photoMotoUrl,
      dateExpirationPermis: dateExpirationPermis ?? this.dateExpirationPermis,
      dateExpirationAssurance: dateExpirationAssurance ?? this.dateExpirationAssurance,
      statut: statut ?? this.statut,
      commissionPlateforme: commissionPlateforme ?? this.commissionPlateforme,
      priorite: priorite ?? this.priorite,
      estFavori: estFavori ?? this.estFavori,
      note: note ?? this.note,
      nbLivraisonsAcceptees: nbLivraisonsAcceptees ?? this.nbLivraisonsAcceptees,
      nbLivraisonsAnnulees: nbLivraisonsAnnulees ?? this.nbLivraisonsAnnulees,
      nbLivraisonsCompletees: nbLivraisonsCompletees ?? this.nbLivraisonsCompletees,
      nbLivraisonsIgnorees: nbLivraisonsIgnorees ?? this.nbLivraisonsIgnorees,
      nbLivraisonsRefusees: nbLivraisonsRefusees ?? this.nbLivraisonsRefusees,
      nbLivraisonsTotal: nbLivraisonsTotal ?? this.nbLivraisonsTotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
