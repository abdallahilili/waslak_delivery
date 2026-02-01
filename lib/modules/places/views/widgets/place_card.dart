import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/place_model.dart';
import '../../controllers/places_controller.dart';
import '../../controllers/restaurant_controller.dart';
import '../pages/place_form_page.dart';
import '../pages/restaurant_detail_page.dart';
import '../pages/restaurant_form_page.dart';

class PlaceCard extends StatelessWidget {
  final PlaceModel place;
  final PlacesController controller;

  const PlaceCard({
    Key? key,
    required this.place,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getTypeColor(place.type, context),
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
      onTap: () async {
        if (place.type == 'restaurant') {
          final restController = Get.put(RestaurantController());
          
          Get.dialog(
            const Center(child: CircularProgressIndicator(color: Colors.white)),
            barrierDismissible: false,
          );
          
          await restController.fetchRestaurantByPlaceId(place.id);
          
          if (Get.isDialogOpen ?? false) Get.back(); // Close loading
          
          if (restController.currentRestaurant.value != null) {
            Get.to(() => RestaurantDetailPage(place: place, restaurant: restController.currentRestaurant.value!));
          } else {
            Get.to(() => RestaurantFormPage(place: place));
          }
        } else {
          Get.to(() => PlaceFormPage(place: place));
        }
      },
    );
  }

  Color _getTypeColor(String type, BuildContext context) {
    switch (type) {
      case 'restaurant': return Colors.orange;
      case 'client': return Theme.of(context).primaryColor;
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
