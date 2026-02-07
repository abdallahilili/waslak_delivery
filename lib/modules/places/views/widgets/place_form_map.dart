import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class PlaceFormMap extends StatelessWidget {
  final double lat;
  final double lng;
  final Completer<GoogleMapController> mapController;
  final Function(LatLng) onMapTapped;
  final Marker? marker;
  final TextEditingController searchController;
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
    required this.searchController,
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
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher une adresse...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                      onPressed: () {
                         onSearchChanged(searchController.text);
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: onSearchChanged,
                  onSubmitted: onSearchChanged,
                ),
              ),
              if (predictions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          final p = predictions[index];
                          return ListTile(
                            leading: const Icon(Icons.location_on, color: Colors.red, size: 20),
                            title: Text(
                              p['description'], 
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)
                            ),
                            onTap: () => onPredictionTap(p['place_id']),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
