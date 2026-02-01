import 'package:flutter/material.dart';
import '../../models/livreur_model.dart';

class DetailInfo extends StatelessWidget {
  final LivreurModel livreur;

  const DetailInfo({Key? key, required this.livreur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informations Personnelles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildInfoRow('NNI', livreur.nni),
          _buildInfoRow('WhatsApp', livreur.whatsapp),
          _buildInfoRow('Créé le', livreur.createdAt.toString().split('.')[0]),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(child: Text(value ?? '-', style: TextStyle(color: isLink ? Colors.blue : Colors.black))),
        ],
      ),
    );
  }
}
