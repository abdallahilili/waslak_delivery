import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/restaurant_model.dart';
import '../../controllers/restaurant_controller.dart';

class RestaurantDetailAppBar extends StatelessWidget {
  final RestaurantModel restaurant;
  final RestaurantController controller;

  const RestaurantDetailAppBar({
    Key? key,
    required this.restaurant,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          ),
          tooltip: 'Supprimer',
          onPressed: () {
            Get.defaultDialog(
              title: 'Confirmer',
              titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              middleText: 'Voulez-vous vraiment supprimer ce restaurant ?',
              textConfirm: 'Supprimer',
              textCancel: 'Annuler',
              confirmTextColor: Colors.white,
              buttonColor: Colors.red,
              onConfirm: () async {
                await controller.deleteRestaurant(restaurant.id);
                if (controller.currentRestaurant.value == null) {
                  Get.back();
                }
              },
            );
          },
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        centerTitle: true,
        titlePadding: const EdgeInsets.only(bottom: 16),
        title: Text(
          restaurant.nom,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'cover_${restaurant.id}',
              child: restaurant.couvertureUrl != null
                  ? Image.network(restaurant.couvertureUrl!, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.restaurant, size: 80, color: Colors.white24),
                    ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black12, Colors.black45],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
