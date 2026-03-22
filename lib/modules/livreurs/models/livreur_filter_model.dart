class LivreurFilter {
  String? query;
  String? statut; // 'tous', 'actif', 'inactif', 'bloque'
  String? zone;
  bool? estDisponible;

  LivreurFilter({
    this.query,
    this.statut = 'tous',
    this.zone,
    this.estDisponible,
  });

  LivreurFilter copyWith({
    String? query,
    String? statut,
    String? zone,
    bool? estDisponible,
  }) {
    return LivreurFilter(
      query: query ?? this.query,
      statut: statut ?? this.statut,
      zone: zone ?? this.zone,
      estDisponible: estDisponible ?? this.estDisponible,
    );
  }

  void reset() {
    query = null;
    statut = 'tous';
    zone = null;
    estDisponible = null;
  }
}
