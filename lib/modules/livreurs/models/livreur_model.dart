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
      createdAt: DateTime.parse(map['created_at']),
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
    };
  }
}
