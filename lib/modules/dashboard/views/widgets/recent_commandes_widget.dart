import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:intl/intl.dart';

class RecentCommandesWidget extends GetView<DashboardController> {
  const RecentCommandesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'fr', symbol: 'MRU');
    
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dernières Commandes',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed('/commandes'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Voir tout'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ));
              }
              
              if (controller.recentCommandes.isEmpty) {
                return const Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Aucune commande récente'),
                ));
              }
              
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: Get.width - 80),
                  child: DataTable(
                    headingRowHeight: 48,
                    dataRowHeight: 60,
                    dividerThickness: 0.5,
                    horizontalMargin: 0,
                    columns: const [
                      DataColumn(label: Text('Référence', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Client', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Livreur', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Montant', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Details', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: controller.recentCommandes.map((cmd) {
                      return DataRow(cells: [
                        DataCell(Text(cmd.numero, style: const TextStyle(fontWeight: FontWeight.w600))),
                        DataCell(Text(cmd.client)),
                        DataCell(Text(cmd.livreur ?? '-')),
                        DataCell(_buildStatusBadge(cmd.statut)),
                        DataCell(Text(currencyFormat.format(cmd.montant), style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.chevron_right, color: Colors.blue),
                            onPressed: () => Get.toNamed('/commande-details', arguments: cmd.id),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String statut) {
    Color color;
    String label = statut.toUpperCase();
    
    switch (statut) {
      case 'completee': color = Colors.green; label = 'TERMINÉE'; break;
      case 'en_cours': color = Colors.blue; label = 'EN COURS'; break;
      case 'annulee': color = Colors.red; label = 'ANNULÉE'; break;
      case 'en_attente': color = Colors.orange; label = 'ATTENTE'; break;
      default: color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}
