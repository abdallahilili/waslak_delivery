import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dashboard_stats_model.dart';

class DashboardController extends GetxController {
  final _client = Supabase.instance.client;

  final isLoading = true.obs;
  final stats = DashboardStatsModel.empty().obs;
  final commandesData = <DashboardChartData>[].obs;
  final revenusData = <DashboardChartData>[].obs;
  final livreursEnLigne = <LivreurPosition>[].obs;
  final recentCommandes = <DashboardCommande>[].obs;
  final alertes = <DashboardAlert>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    setupRealtimeSubscription();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      
      // 1. Stats depuis view dashboard_admin
      // Note: On suppose que la vue retourne les totaux et les variations
      final statsResponse = await _client.from('dashboard_admin').select().limit(1).maybeSingle();
      if (statsResponse != null) {
        stats.value = DashboardStatsModel.fromMap(statsResponse);
      }

      // 2. Positions livreurs depuis table livreurs
      final livreursResponse = await _client
          .from('livreurs')
          .select('id, nom, latitude, longitude, statut')
          .eq('statut', 'actif');
      
      livreursEnLigne.value = (livreursResponse as List)
          .map((e) => LivreurPosition.fromMap(e))
          .toList();

      // 3. Commandes récentes & Données graphiques
      // Pour les graphiques, on pourrait avoir une autre vue ou faire un group by
      // Ici on simule ou on récupère les dernières commandes pour déduire les stats
      final commandsResponse = await _client
          .from('commandes')
          .select('*, livreurs(nom)')
          .order('created_at', ascending: false)
          .limit(10);
          
      recentCommandes.value = (commandsResponse as List)
          .map((e) => DashboardCommande.fromMap(e))
          .toList();

      // Simulation des données graphiques (7 derniers jours)
      _generateMockChartData();

      // 4. Alertes calculées
      _calculateAlerts();

    } catch (e) {
      print('Dashboard error: $e');
      // Get.snackbar('Erreur', 'Impossible de charger les données du dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setupRealtimeSubscription() {
    // Écoute des changements sur les commandes
    _client.from('commandes').stream(primaryKey: ['id']).listen((data) {
       loadDashboardData();
    });

    // Écoute des positions livreurs
    _client.from('livreurs').stream(primaryKey: ['id']).listen((data) {
       livreursEnLigne.value = data
        .where((e) => e['statut'] == 'actif' && e['latitude'] != null)
        .map((e) => LivreurPosition.fromMap(e))
        .toList();
    });
  }

  void refreshStats() => loadDashboardData();

  void filterByPeriode(DateTimeRange range) {
    // Logique de filtrage par période
    // On pourrait filtrer les requêtes Supabase ici
    loadDashboardData();
  }

  void _generateMockChartData() {
    final now = DateTime.now();
    commandesData.value = List.generate(7, (i) {
      return DashboardChartData(
        now.subtract(Duration(days: 6 - i)),
        (10 + (i * 2) + (i % 2 == 0 ? 5 : -3)).toDouble(),
      );
    });

    revenusData.value = List.generate(7, (i) {
      return DashboardChartData(
        now.subtract(Duration(days: 6 - i)),
        (500 + (i * 150) + (i % 3 == 0 ? 200 : -100)).toDouble(),
      );
    });
  }

  void _calculateAlerts() {
    final list = <DashboardAlert>[];
    final now = DateTime.now();

    // Commande > 10 min en attente
    for (var cmd in recentCommandes) {
      if (cmd.statut == 'en_attente' && now.difference(cmd.date).inMinutes > 10) {
        list.add(DashboardAlert(
          id: 'late_${cmd.id}',
          message: 'Commande ${cmd.numero} en attente depuis ${now.difference(cmd.date).inMinutes} min',
          type: 'warning',
          date: cmd.date,
        ));
      }
    }

    // On pourrait aussi vérifier les soldes négatifs ici si on avait les données
    
    alertes.value = list;
  }
}
