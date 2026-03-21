import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import 'package:intl/intl.dart';

class KPICardsSection extends GetView<DashboardController> {
  const KPICardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'fr', symbol: 'MRU');
    
    return Obx(() {
      final statsValue = controller.stats.value;
      
      return LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 1;
          if (constraints.maxWidth > 1200) {
            crossAxisCount = 4;
          } else if (constraints.maxWidth > 700) {
            crossAxisCount = 2;
          }
          
          return GridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            childAspectRatio: 2.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _KPICard(
                title: 'Commandes aujourd\'hui',
                value: statsValue.commandesAujourdhui.toString(),
                variation: statsValue.variationCommandes,
                icon: Icons.shopping_bag,
                color: Colors.blue,
              ),
              _KPICard(
                title: 'Revenus du jour',
                value: currencyFormat.format(statsValue.revenusAujourdhui),
                variation: statsValue.variationRevenus,
                icon: Icons.attach_money,
                color: Colors.green,
              ),
              _KPICard(
                title: 'Livreurs en ligne',
                value: statsValue.livreursEnLigne.toString(),
                variation: statsValue.variationLivreurs,
                icon: Icons.two_wheeler,
                color: Colors.orange,
              ),
              _KPICard(
                title: 'Taux complétion',
                value: '${(statsValue.tauxCompletion * 100).toStringAsFixed(1)}%',
                variation: statsValue.variationCompletion,
                icon: Icons.check_circle,
                color: Colors.teal,
              ),
            ],
          );
        },
      );
    });
  }
}

class _KPICard extends StatelessWidget {
  final String title;
  final String value;
  final double variation;
  final IconData icon;
  final Color color;

  const _KPICard({
    required this.title,
    required this.value,
    required this.variation,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    bool isPositive = variation >= 0;
    
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositive ? Colors.green : Colors.red).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive ? Colors.green : Colors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${variation.abs().toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
