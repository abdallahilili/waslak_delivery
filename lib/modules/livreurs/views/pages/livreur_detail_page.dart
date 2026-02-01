import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../models/livreur_model.dart';
import '../../controllers/livreur_controller.dart';
import 'livreur_form_page.dart';
import '../../../journal/views/pages/journal_list_page.dart';
import '../../../../shared/widgets/image_viewer_widget.dart';

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
            ),
            const SizedBox(height: 10),
            Container(
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
                      _buildStatCard('Complétées', livreur.nbLivraisonsCompletees.toString(), Colors.green), // Keep green for success/completed
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
                  const SizedBox(height: 20),
                  const Text('Informations Personnelles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _buildInfoRow('NNI', livreur.nni),
                  _buildInfoRow('WhatsApp', livreur.whatsapp),
                  _buildInfoRow('Créé le', livreur.createdAt.toString().split('.')[0]),
                  
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
  Widget _buildStatusBadge(String statut, BuildContext context) {
    Color color = Colors.grey;
    if (statut == 'actif') color = Theme.of(context).primaryColor; // Match app theme
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
