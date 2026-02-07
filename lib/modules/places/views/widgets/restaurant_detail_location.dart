import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/place_model.dart';
import '../pages/place_form_page.dart';
import 'place_map_view.dart';

class RestaurantDetailLocation extends StatelessWidget {
  final PlaceModel place;
  final Function(PlaceModel)? onPlaceUpdated;

  const RestaurantDetailLocation({
    Key? key,
    required this.place,
    this.onPlaceUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(Icons.location_on_rounded, color: Theme.of(context).primaryColor, size: 24),
                const SizedBox(width: 10),
                const Text(
                  "Localisation",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () async {
                    final result = await Get.to(() => PlaceFormPage(place: place));
                    if (result != null && result is PlaceModel && onPlaceUpdated != null) {
                      onPlaceUpdated!(result);
                    }
                  },
                  icon: const Icon(Icons.edit_location_alt_rounded, size: 18),
                  label: const Text("Modifier"),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ],
            ),
          ),
          if (place.adresse != null && place.adresse!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                place.adresse!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            child: SizedBox(
              height: 200,
              child: PlaceMapView(
                lat: place.latitude,
                lng: place.longitude,
                isReadOnly: true,
                icon: Icons.restaurant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
