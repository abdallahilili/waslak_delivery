import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';
import '../widgets/livreur_search_header.dart';
import '../widgets/livreur_list_view.dart';
import 'livreur_form_page.dart';
import '../../../../shared/widgets/loading.dart';

class LivreurListPage extends StatelessWidget {
  LivreurListPage({Key? key}) : super(key: key);

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
          LivreurSearchHeader(
            onChanged: (val) => controller.searchQuery.value = val,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Loading();
              }
              return LivreurListView(
                livreurs: controller.livreurs,
                onRefresh: controller.fetchLivreurs,
              );
            }),
          ),
        ],
      ),
    );
  }
}
