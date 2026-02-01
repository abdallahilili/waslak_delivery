import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class PlaceFormMap extends StatelessWidget {
  final double lat;
  final double lng;
  final Completer<GoogleMapController> mapController;
  final Function(LatLng) onMapTapped;
  final Marker? marker;
  final Function(String) onSearchChanged;
  final List<dynamic> predictions;
  final Function(String) onPredictionTap;

  const PlaceFormMap({
    Key? key,
    required this.lat,
    required this.lng,
    required this.mapController,
    required this.onMapTapped,
    this.marker,
    required this.onSearchChanged,
    required this.predictions,
    required this.onPredictionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(lat, lng),
            zoom: 14,
          ),
          onMapCreated: (c) => mapController.complete(c),
          onTap: onMapTapped,
          markers: marker != null ? {marker!} : {},
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Column(
            children: [
              Card(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une adresse...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
              if (predictions.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      final p = predictions[index];
                      return ListTile(
                        title: Text(p['description']),
                        onTap: () => onPredictionTap(p['place_id']),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
