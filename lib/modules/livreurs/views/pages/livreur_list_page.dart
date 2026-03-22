import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';
import '../widgets/livreur_filter_bar.dart';
import '../widgets/livreur_card.dart';
import 'livreur_form_page.dart';
import 'livreur_detail_page.dart';
import '../widgets/livreur_map_widget.dart';

class LivreurListPage extends StatefulWidget {
  const LivreurListPage({super.key});

  @override
  State<LivreurListPage> createState() => _LivreurListPageState();
}

class _LivreurListPageState extends State<LivreurListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<LivreurController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livreurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: controller.exportToExcel,
            tooltip: 'Exporter EXCEL',
          ),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => const LivreurFormPage()),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Nouveau'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.table_chart), text: 'Tableau'),
            Tab(icon: Icon(Icons.grid_view), text: 'Grille'),
            Tab(icon: Icon(Icons.map_outlined), text: 'Carte'),
          ],
        ),
      ),
      body: Column(
        children: [
          const LivreurFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTableView(),
                _buildGridView(),
                const LivreurMapWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableView() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('Photo')),
              DataColumn(label: Text('Nom')),
              DataColumn(label: Text('Téléphone')),
              DataColumn(label: Text('Statut')),
              DataColumn(label: Text('Zone')),
              DataColumn(label: Text('Note')),
              DataColumn(label: Text('Nb liv.')),
              DataColumn(label: Text('Actions')),
            ],
            rows: controller.livreurs.map((l) {
              return DataRow(
                onSelectChanged: (_) => Get.to(() => LivreurDetailPage(livreur: l)),
                cells: [
                  DataCell(CircleAvatar(
                    backgroundImage: l.photoProfilUrl != null ? NetworkImage(l.photoProfilUrl!) : null,
                    radius: 18,
                    child: l.photoProfilUrl == null ? const Icon(Icons.person, size: 20) : null,
                  )),
                  DataCell(Text(l.nom, style: const TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(l.telephone)),
                  DataCell(_buildStatutChip(l.statut)),
                  DataCell(Text(l.zoneService ?? '-')),
                  DataCell(Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(l.note.toStringAsFixed(1)),
                    ],
                  )),
                  DataCell(Text('${l.nbLivraisonsCompletees}')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => Get.to(() => const LivreurFormPage(), arguments: l),
                      ),
                      IconButton(
                        icon: Icon(
                          l.statut == 'bloque' ? Icons.lock_open : Icons.lock, 
                          color: l.statut == 'bloque' ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        onPressed: () => controller.toggleStatus(l.id, l.statut == 'bloque' ? 'actif' : 'bloque'),
                      ),
                    ],
                  )),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildGridView() {
     return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: controller.livreurs.length,
        itemBuilder: (context, index) {
          final l = controller.livreurs[index];
          return LivreurCard(livreur: l);
        },
      );
    });
  }

  Widget _buildStatutChip(String statut) {
    Color color;
    switch (statut) {
      case 'actif': color = Colors.green; break;
      case 'inactif': color = Colors.grey; break;
      case 'bloque': color = Colors.red; break;
      default: color = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        statut.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
