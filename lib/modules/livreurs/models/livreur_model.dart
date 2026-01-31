class LivreurModel {
  final String id;
  final String nom;
  final String nni;
  final String telephone;
  final String? whatsapp;
  final String? photoProfilUrl;
  final String? photoCniUrl;
  final String? photoCarteGriseUrl;
  final String? photoAssuranceUrl;
  final String? photoMotoUrl;
  final String statut;
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
    required this.nni,
    required this.telephone,
    this.whatsapp,
    this.photoProfilUrl,
    this.photoCniUrl,
    this.photoCarteGriseUrl,
    this.photoAssuranceUrl,
    this.photoMotoUrl,
    required this.statut,
    this.nbLivraisonsAcceptees = 0,
    this.nbLivraisonsAnnulees = 0,
    this.nbLivraisonsCompletees = 0,
    this.nbLivraisonsIgnorees = 0,
    this.nbLivraisonsRefusees = 0,
    this.nbLivraisonsTotal = 0,
    required this.createdAt,
  });

  factory LivreurModel.fromMap(Map<String, dynamic> map) {
    return LivreurModel(
      id: map['id'] ?? '',
      nom: map['nom'] ?? '',
      nni: map['nni'] ?? '',
      telephone: map['telephone'] ?? '',
      whatsapp: map['whatsapp'],
      photoProfilUrl: map['photo_profil_url'],
      photoCniUrl: map['photo_cni_url'],
      photoCarteGriseUrl: map['photo_carte_grise_url'],
      photoAssuranceUrl: map['photo_assurance_url'],
      photoMotoUrl: map['photo_moto_url'],
      statut: map['statut'] ?? 'actif',
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
      'nni': nni,
      'telephone': telephone,
      'whatsapp': whatsapp,
      'photo_profil_url': photoProfilUrl,
      'photo_cni_url': photoCniUrl,
      'photo_carte_grise_url': photoCarteGriseUrl,
      'photo_assurance_url': photoAssuranceUrl,
      'photo_moto_url': photoMotoUrl,
      'statut': statut,
      // Note: Counters are read-only side Flutter, managed by Edge Functions.
      // So they are not included in toMap() for insert/update.
    };
  }
}
