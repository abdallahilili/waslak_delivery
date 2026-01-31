import 'package:flutter/material.dart';
import '../models/livreur_model.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LivreurCard extends StatelessWidget {
  final LivreurModel livreur;
  final VoidCallback onTap;

  const LivreurCard({
    Key? key,
    required this.livreur,
    required this.onTap,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: livreur.photoProfilUrl != null
              ? NetworkImage(livreur.photoProfilUrl!)
              : null,
          child: livreur.photoProfilUrl == null
              ? const Icon(Icons.person, color: Colors.grey)
              : null,
        ),
        title: Text(
          livreur.nom,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(livreur.telephone),
              ],
            ),
            if (livreur.nni.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text('NNI: ${livreur.nni}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Bootstrap.telephone_fill, color: Theme.of(context).primaryColor),
              onPressed: () => _launchUrl('tel:${livreur.telephone}'),
              tooltip: 'Appeler',
            ),
            IconButton(
              icon: const Icon(Bootstrap.whatsapp, color: Color(0xFF25D366)), // WhatsApp Brand Color
              onPressed: () {
                final phone = livreur.whatsapp?.isNotEmpty == true ? livreur.whatsapp : livreur.telephone;
                _launchUrl('https://wa.me/$phone');
              },
              tooltip: 'WhatsApp',
            ),
          ],
        ),
      ),
    );
  }
}
