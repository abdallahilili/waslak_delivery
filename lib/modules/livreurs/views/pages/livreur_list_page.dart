import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';
import '../widgets/livreur_card.dart';
import 'livreur_form_page.dart';
import 'livreur_detail_page.dart';
import '../../../../shared/widgets/loading.dart';
import '../../../../shared/widgets/app_input.dart';

class LivreurListPage extends StatelessWidget {
  LivreurListPage({Key? key}) : super(key: key);

  // Inject controller here if not bound globally, but usually handled by binding
  final controller = Get.put(LivreurController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Livreurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchLivreurs,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => LivreurFormPage()),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppInput(
              label: 'Rechercher',
              hint: 'Nom, téléphone ou NNI',
              suffixIcon: const Icon(Icons.search),
              onChanged: (val) => controller.searchQuery.value = val,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Loading();
              }

              if (controller.livreurs.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.fetchLivreurs,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.center,
                      child: const Text('Aucun livreur trouvé'),
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchLivreurs,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.livreurs.length,
                  itemBuilder: (context, index) {
                    final livreur = controller.livreurs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: LivreurCard(
                        livreur: livreur,
                        onTap: () =>
                            Get.to(() => LivreurDetailPage(livreur: livreur)),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
