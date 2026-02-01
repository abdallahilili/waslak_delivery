import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/livreur_model.dart';
import '../../../journal/views/pages/journal_list_page.dart';

class DetailHeader extends StatelessWidget {
  final LivreurModel livreur;

  const DetailHeader({Key? key, required this.livreur}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: livreur.photoProfilUrl != null ? NetworkImage(livreur.photoProfilUrl!) : null,
            child: livreur.photoProfilUrl == null ? const Icon(Icons.person, size: 50) : null,
          ),
          const SizedBox(height: 16),
          Text(livreur.nom, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(livreur.telephone, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          _buildStatusBadge(livreur.statut, context),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _launchUrl('tel:${livreur.telephone}'),
                icon: const Icon(Bootstrap.telephone_fill),
                label: const Text('Appeler'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  final phone = livreur.whatsapp?.isNotEmpty == true ? livreur.whatsapp : livreur.telephone;
                  _launchUrl('https://wa.me/$phone');
                },
                icon: const Icon(Bootstrap.whatsapp),
                label: const Text('WhatsApp'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25D366),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => JournalListPage(livreur: livreur)),
            icon: const Icon(Icons.book),
            label: const Text('Journal des courses'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String statut, BuildContext context) {
    Color color = Colors.grey;
    if (statut == 'actif') color = Theme.of(context).primaryColor;
    if (statut == 'inactif') color = Theme.of(context).colorScheme.error;
    if (statut == 'suspendu') color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statut.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
