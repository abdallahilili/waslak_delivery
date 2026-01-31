import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../livreurs/views/livreur_list_page.dart';

import '../../places/views/places_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panneau'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: controller.logout,
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
                   SizedBox(height: 10),
                   Text('Gestion Livreurs', style: TextStyle(color: Colors.white, fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Livreurs'),
              onTap: () {
                Get.back(); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.place),
              title: const Text('Places / Géolocalisation'),
              onTap: () {
                Get.back();
                Get.to(() => const PlacesListPage());
              },
            ),
          ],
        ),
      ),
      body: LivreurListPage(),
    );
  }
}
