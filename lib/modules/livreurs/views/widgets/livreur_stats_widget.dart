import 'package:flutter/material.dart';
import '../../models/livreur_model.dart';

class LivreurStatsWidget extends StatelessWidget {
  final LivreurModel livreur;

  const LivreurStatsWidget({super.key, required this.livreur});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Livraisons', livreur.nbLivraisonsTotal.toString(), Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Taux Complétion', '${livreur.tauxCompletion.toStringAsFixed(1)}%', Colors.green)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Taux Acceptation', '${livreur.tauxAcceptation.toStringAsFixed(1)}%', Colors.orange)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Annulées', livreur.nbLivraisonsAnnulees.toString(), Colors.red)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
