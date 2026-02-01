import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/places_controller.dart';
import '../widgets/place_card.dart';
import 'place_form_page.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlacesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Places'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.places.isEmpty) {
          return const Center(child: Text('Aucune place trouvée'));
        }
        return ListView.builder(
          itemCount: controller.places.length,
          itemBuilder: (context, index) {
            return PlaceCard(
              place: controller.places[index],
              controller: controller,
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const PlaceFormPage()),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
