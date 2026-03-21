import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';

class LivreursMapWidget extends GetView<DashboardController> {
  const LivreursMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Positions en temps réel',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.two_wheeler, size: 16, color: Colors.green),
                      const SizedBox(width: 8),
                      Obx(() => Text(
                        '${controller.livreursEnLigne.length} actifs',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 450,
            child: Obx(() {
               final markers = controller.livreursEnLigne.map((l) {
                 return Marker(
                   markerId: MarkerId(l.id),
                   position: LatLng(l.lat, l.lng),
                   infoWindow: InfoWindow(title: l.nom, snippet: l.statut),
                 );
               }).toSet();

               return GoogleMap(
                 initialCameraPosition: const CameraPosition(
                   target: LatLng(18.0735, -15.9582), // Nouakchott
                   zoom: 12,
                 ),
                 markers: markers,
                 myLocationEnabled: true,
                 mapToolbarEnabled: false,
                 zoomControlsEnabled: true,
                 mapType: MapType.normal,
                 padding: const EdgeInsets.only(bottom: 20, right: 20),
               );
            }),
          ),
        ],
      ),
    );
  }
}
