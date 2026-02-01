import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/livreur_model.dart';
import '../../controllers/livreur_controller.dart';
import 'livreur_form_page.dart';
import '../widgets/detail_header.dart';
import '../widgets/detail_stats.dart';
import '../widgets/detail_info.dart';
import '../widgets/detail_docs.dart';

class LivreurDetailPage extends StatelessWidget {
  final LivreurModel livreur;
  final LivreurController controller = Get.find();

  LivreurDetailPage({Key? key, required this.livreur}) : super(key: key);

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
            DetailHeader(livreur: livreur),
            const SizedBox(height: 10),
            DetailStats(livreur: livreur),
            const SizedBox(height: 10),
            DetailInfo(livreur: livreur),
            const SizedBox(height: 10),
            DetailDocs(livreur: livreur),
          ],
        ),
      ),
    );
  }
}
