import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import '../../controllers/places_controller.dart';
import '../../models/place_model.dart';
import 'dart:async';

class PlaceFormPage extends StatefulWidget {
  final PlaceModel? place;

  const PlaceFormPage({Key? key, this.place}) : super(key: key);

  @override
  State<PlaceFormPage> createState() => _PlaceFormPageState();
}

class _PlaceFormPageState extends State<PlaceFormPage> {
  final controller = Get.put(PlacesController());
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _adresseController = TextEditingController();

  String _type = 'client';
  double _lat = 18.0735; // Default (Mauritania/Nouakchott)
  double _lng = -15.9582;
  bool _actif = true;

  Completer<GoogleMapController> _mapController = Completer();
  Marker? _marker;

  // Google Places API (using provided key)
  final String _apiKey = 'AIzaSyDe5CA8nrN_lgix4lanomjg66YhQlP2goM';
  final _dio = Dio();
  List<dynamic> _predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      _nomController.text = widget.place!.nom;
      _phoneController.text = widget.place!.telephone ?? '';
      _adresseController.text = widget.place!.adresse ?? '';
      _type = widget.place!.type;
      _lat = widget.place!.latitude;
      _lng = widget.place!.longitude;
      _actif = widget.place!.actif;
    }
    _marker = Marker(
      markerId: const MarkerId('selected_pos'),
      position: LatLng(_lat, _lng),
    );
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _lat = position.latitude;
      _lng = position.longitude;
      _marker = Marker(
        markerId: const MarkerId('selected_pos'),
        position: position,
      );
    });
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(position));
    _onMapTapped(position);
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': _apiKey,
          'language': 'fr',
          'components': 'country:mr', // Mauritania
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
          setState(() => _predictions = data['predictions']);
        } else {
          print(
            'Google Maps API Error (Autocomplete): ${data['status']} - ${data['error_message']}',
          );
          Get.snackbar(
            'Erreur Recherche',
            'Erreur API: ${data['status']}. ${data['error_message'] ?? ''}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Autocomplete exception: $e');
      Get.snackbar(
        'Erreur Recherche',
        'Impossible de rechercher des lieux: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _getPlaceDetails(String placeId) async {
    try {
      final response = await _dio.get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {'place_id': placeId, 'key': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'OK') {
          final result = data['result'];
          final lat = result['geometry']['location']['lat'];
          final lng = result['geometry']['location']['lng'];
          final address = result['formatted_address'];

          setState(() {
            _adresseController.text = address;
            _predictions = [];
          });
          _moveCamera(LatLng(lat, lng));
        } else {
          print(
            'Google Maps API Error (Details): ${data['status']} - ${data['error_message']}',
          );
          Get.snackbar(
            'Erreur Détails',
            'Erreur API: ${data['status']}. ${data['error_message'] ?? ''}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        throw Exception('Server returned ${response.statusCode}');
      }
    } catch (e) {
      print('Place details exception: $e');
      Get.snackbar(
        'Erreur Détails',
        'Impossible de récupérer les détails: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place == null ? 'Ajouter une Place' : 'Modifier la Place',
        ),
        // backgroundColor handled by theme
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_lat, _lng),
                      zoom: 14,
                    ),
                    onMapCreated: (c) => _mapController.complete(c),
                    onTap: _onMapTapped,
                    markers: _marker != null ? {_marker!} : {},
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
                            onChanged: (val) {
                              if (_debounce?.isActive ?? false)
                                _debounce!.cancel();
                              _debounce = Timer(
                                const Duration(milliseconds: 500),
                                () {
                                  _searchPlaces(val);
                                },
                              );
                            },
                          ),
                        ),
                        if (_predictions.isNotEmpty)
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListView.builder(
                              itemCount: _predictions.length,
                              itemBuilder: (context, index) {
                                final p = _predictions[index];
                                return ListTile(
                                  title: Text(p['description']),
                                  onTap: () => _getPlaceDetails(p['place_id']),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de la Place *',
                      ),
                      validator: (v) => v!.isEmpty ? 'Requis' : null,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: const InputDecoration(labelText: 'Type'),
                      items: ['restaurant', 'client', 'depot', 'autre']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.capitalizeFirst!),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _type = v!),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Téléphone (Optionnel)',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _adresseController,
                      decoration: const InputDecoration(labelText: 'Adresse'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text('Latitude: ${_lat.toStringAsFixed(6)}'),
                        ),
                        Expanded(
                          child: Text('Longitude: ${_lng.toStringAsFixed(6)}'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: controller.isSaving.value
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    final place = PlaceModel(
                                      id: widget.place?.id ?? '',
                                      nom: _nomController.text,
                                      type: _type,
                                      telephone: _phoneController.text,
                                      adresse: _adresseController.text,
                                      latitude: _lat,
                                      longitude: _lng,
                                      actif: _actif,
                                      createdAt: DateTime.now(),
                                    );
                                    if (widget.place == null) {
                                      controller.createPlace(place);
                                    } else {
                                      controller.updatePlace(
                                        widget.place!.id,
                                        place.toMap(),
                                      );
                                    }
                                  }
                                },
                          child: controller.isSaving.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'ENREGISTRER',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
