import 'package:flutter/material.dart';
import '../../models/livreur_model.dart';
import '../../../../shared/widgets/image_viewer_widget.dart';

class DetailDocs extends StatelessWidget {
  final LivreurModel livreur;

  const DetailDocs({Key? key, required this.livreur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Documents & Photos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildDocImage('CNI', livreur.photoCniUrl),
          _buildDocImage('Carte Grise', livreur.photoCarteGriseUrl),
          _buildDocImage('Assurance', livreur.photoAssuranceUrl),
          _buildDocImage('Moto', livreur.photoMotoUrl),
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
}
