import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:icons_plus/icons_plus.dart';
import '../models/livreur_model.dart';
import '../controllers/livreur_controller.dart';
import 'livreur_form_page.dart';
import '../../journal/views/journal_list_page.dart';
import '../../../shared/widgets/image_viewer_widget.dart';

class LivreurDetailPage extends StatelessWidget {
  final LivreurModel livreur;
  final LivreurController controller = Get.find();

  LivreurDetailPage({Key? key, required this.livreur}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
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

  Widget _buildDocImage(String title, String? url) {
    if (url == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ImageViewerWidget(
          imageUrl: url,
          title: title,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(livreur.nom),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Get.to(() => LivreurFormPage(livreur: livreur)),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.defaultDialog(
                title: 'Supprimer',
                middleText: 'Voulez-vous vraiment supprimer ce livreur ?',
                textConfirm: 'Supprimer',
                textCancel: 'Annuler',
                confirmTextColor: Colors.white,
                onConfirm: () => controller.deleteLivreur(livreur.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       ElevatedButton.icon(
                        onPressed: () => _launchUrl('tel:${livreur.telephone}'),
                        icon: const Icon(Bootstrap.telephone_fill),
                        label: const Text('Appeler'),
                        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                           final phone = livreur.whatsapp?.isNotEmpty == true ? livreur.whatsapp : livreur.telephone;
                           _launchUrl('https://wa.me/$phone');
                        },
                        icon: const Icon(Bootstrap.whatsapp),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366)), // WhatsApp Brand Color
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
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informations Personnelles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildInfoRow('NNI', livreur.nni),
                  _buildInfoRow('WhatsApp', livreur.whatsapp),
                  
                  const SizedBox(height: 20),
                  const Text('Documents & Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildDocImage('CNI', livreur.photoCniUrl),
                  _buildDocImage('Carte Grise', livreur.photoCarteGriseUrl),
                  _buildDocImage('Assurance', livreur.photoAssuranceUrl),
                  _buildDocImage('Moto', livreur.photoMotoUrl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
