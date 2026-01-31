import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../livreurs/views/livreur_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Ensuring controller is initialized if not using bindings for Home specifically or if it's main entry
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion Livreurs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: controller.logout,
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: LivreurListPage(), // Main feature is Livreur management
    );
  }
}
