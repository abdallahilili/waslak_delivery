import 'package:flutter/material.dart';
import 'package:gestion_livreurs/modules/livreurs/models/livreur_model.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';
import '../widgets/detail_header.dart';
import '../widgets/detail_stats.dart';
import '../widgets/detail_info.dart';
import '../widgets/detail_docs.dart';
import '../widgets/livreur_map_widget.dart';
import 'livreur_form_page.dart';

class LivreurDetailPage extends StatefulWidget {
  final LivreurModel livreur;
  const LivreurDetailPage({super.key, required this.livreur});

  @override
  State<LivreurDetailPage> createState() => _LivreurDetailPageState();
}

class _LivreurDetailPageState extends State<LivreurDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<LivreurController>();
  late String id;

  @override
  void initState() {
    super.initState();
    id = widget.livreur.id;
    _tabController = TabController(length: 5, vsync: this);
    controller.getLivreurDetails(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.selectedLivreur.value?.nom ?? 'Détails Livreur')),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (controller.selectedLivreur.value != null) {
                Get.to(() => LivreurFormPage(livreur: controller.selectedLivreur.value));
              }
            },
          ),
          _buildMoreActions(),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Informations'),
            Tab(text: 'Statistiques'),
            Tab(text: 'Finances'),
            Tab(text: 'Courses'),
            Tab(text: 'Tracking'),
          ],
        ),
      ),
      body: Obx(() {
        final l = controller.selectedLivreur.value;
        if (l == null) return const Center(child: CircularProgressIndicator());

        return TabBarView(
          controller: _tabController,
          children: [
            _buildInfoTab(l),
            _buildStatsTab(l),
            _buildFinanceTab(l),
            _buildCoursesTab(l),
            _buildTrackingTab(l),
          ],
        );
      }),
    );
  }

  Widget _buildMoreActions() {
    return PopupMenuButton<String>(
      onSelected: (val) {
        if (val == 'block') {
           final l = controller.selectedLivreur.value;
           if (l != null) {
              controller.toggleStatus(l.id, l.statut == 'bloque' ? 'actif' : 'bloque');
           }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'block', child: Text('Bloquer/Activer')),
        const PopupMenuItem(value: 'reset_pwd', child: Text('Réinitialiser MDP')),
        const PopupMenuItem(value: 'notify', child: Text('Envoyer notification')),
      ],
    );
  }

  Widget _buildInfoTab(l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DetailHeader(livreur: l),
          const SizedBox(height: 16),
          DetailInfo(livreur: l),
          const SizedBox(height: 16),
          DetailDocs(livreur: l),
        ],
      ),
    );
  }

  Widget _buildStatsTab(l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DetailStats(livreur: l),
          const SizedBox(height: 20),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Graphiques de performance (Hebdomadaire/Mensuelle)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceTab(l) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              title: const Text('Solde Actuel', style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Text('0.00 MRU', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Transactions récentes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Card(
            child: ListTile(
              title: Text('Tableau des transactions (Dépôts, Retraits, Commissions)'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab(l) {
    return const Center(child: Text('Liste des courses effectuées par le livreur'));
  }

  Widget _buildTrackingTab(l) {
    return Column(
      children: const [
        Expanded(child: LivreurMapWidget()),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Historique des positions et Timeline des déplacements'),
        ),
      ],
    );
  }
}
