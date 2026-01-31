import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/places_controller.dart';
import 'place_form_page.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PlacesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Places'),
        backgroundColor: Colors.blue.withOpacity(0.8),
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
            final place = controller.places[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getTypeColor(place.type),
                child: Icon(_getTypeIcon(place.type), color: Colors.white),
              ),
              title: Text(place.nom),
              subtitle: Text('${place.type.capitalizeFirst} - ${place.adresse ?? ''}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Confirmation',
                    middleText: 'Supprimer cette place ?',
                    onConfirm: () {
                      controller.deletePlace(place.id);
                      Get.back();
                    },
                    textCancel: 'Annuler',
                  );
                },
              ),
              onTap: () => Get.to(() => PlaceFormPage(place: place)),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const PlaceFormPage()),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'restaurant': return Colors.orange;
      case 'client': return Colors.green;
      case 'depot': return Colors.blueGrey;
      default: return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'restaurant': return Icons.restaurant;
      case 'client': return Icons.person;
      case 'depot': return Icons.warehouse;
      default: return Icons.place;
    }
  }
}
