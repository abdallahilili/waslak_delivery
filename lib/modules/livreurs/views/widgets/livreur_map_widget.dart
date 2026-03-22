import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import '../../controllers/livreur_controller.dart';

class LivreurMapWidget extends GetView<LivreurController> {
  const LivreurMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final markers = controller.livreurs.where((l) => l.statut == 'actif').map((l) {
        return Marker(
          markerId: MarkerId(l.id),
          position: const LatLng(18.0735, -15.9582), // TODO: Utiliser position réelle si dispo
          infoWindow: InfoWindow(title: l.nom, snippet: l.telephone),
        );
      }).toSet();

      return GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(18.0735, -15.9582),
          zoom: 12,
        ),
        markers: markers,
        myLocationEnabled: true,
      );
    });
  }
}
