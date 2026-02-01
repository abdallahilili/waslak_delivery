import 'package:flutter/material.dart';
import '../../models/livreur_model.dart';

class DetailStats extends StatelessWidget {
  final LivreurModel livreur;

  const DetailStats({Key? key, required this.livreur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statistiques de livraison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          Row(
            children: [
              _buildStatCard('Total', livreur.nbLivraisonsTotal.toString(), Theme.of(context).primaryColor),
              _buildStatCard('Complétées', livreur.nbLivraisonsCompletees.toString(), Colors.green),
              _buildStatCard('Annulées', livreur.nbLivraisonsAnnulees.toString(), Theme.of(context).colorScheme.error),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatCard('Acceptées', livreur.nbLivraisonsAcceptees.toString(), Colors.orange),
              _buildStatCard('Refusées', livreur.nbLivraisonsRefusees.toString(), Colors.deepOrange),
              _buildStatCard('Ignorées', livreur.nbLivraisonsIgnorees.toString(), Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        color: color.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.2)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
