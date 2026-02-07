import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/places_controller.dart';
import '../../models/place_model.dart';
import '../widgets/place_map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final _searchController = TextEditingController();

  String _type = 'client';
  double _lat = 18.0735;
  double _lng = -15.9582;
  bool _actif = true;

  List<PlaceModel> _predictions = [];

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
  }

  void _onPositionChanged(LatLng pos) {
    setState(() {
      _lat = pos.latitude;
      _lng = pos.longitude;
    });
  }

  void _searchPlaces(String query) {
    if (query.length < 2) {
      setState(() => _predictions = []);
      return;
    }

    // Rechercher dans la liste locale du controller (déjà chargée depuis Supabase)
    final results = controller.places.where((p) {
      final name = p.nom.toLowerCase();
      final addr = (p.adresse ?? '').toLowerCase();
      final q = query.toLowerCase();
      return name.contains(q) || addr.contains(q);
    }).toList();

    setState(() {
      _predictions = results;
    });
  }

  void _selectPlace(PlaceModel place) {
    setState(() {
      _nomController.text = place.nom;
      _phoneController.text = place.telephone ?? '';
      _adresseController.text = place.adresse ?? '';
      _type = place.type;
      _lat = place.latitude;
      _lng = place.longitude;
      _actif = place.actif;
      _predictions = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.place == null ? 'Ajouter une Place' : 'Modifier la Place',
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // BARRE DE RECHERCHE DECOUPLEE POUR TESTER L'EVENEMENT
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Taper "test" pour essayer...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _searchPlaces(_searchController.text),
                    ),
                  ),
                  onChanged: (v) {
                    print('ON_CHANGED: $v');
                    _searchPlaces(v);
                  },
                ),
              ),
            ),
            if (_predictions.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                color: Colors.white,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _predictions.length,
                  itemBuilder: (context, index) {
                    final p = _predictions[index];
                    return ListTile(
                      title: Text(p.nom),
                      subtitle: Text(p.adresse ?? ''),
                      leading: const Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                      onTap: () => _selectPlace(p),
                    );
                  },
                ),
              ),
            Expanded(
              flex: 3,
              child: Obx(() {
                // Force la lecture de l'observable pour éviter l'erreur "improper use of GetX"
                final otherPlaces = controller.places.toList();
                return PlaceMapView(
                  lat: _lat,
                  lng: _lng,
                  onPositionChanged: _onPositionChanged,
                  otherPlaces: otherPlaces,
                );
              }),
            ),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildFields(),
              ),
            ),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: [
        TextFormField(
          controller: _nomController,
          decoration: const InputDecoration(labelText: 'Nom de la Place *'),
          validator: (v) => v!.isEmpty ? 'Requis' : null,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _type,
          decoration: const InputDecoration(labelText: 'Type'),
          items: ['restaurant', 'client', 'depot', 'autre']
              .map(
                (e) =>
                    DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!)),
              )
              .toList(),
          onChanged: (v) => setState(() => _type = v!),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(labelText: 'Téléphone (Optionnel)'),
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
            Expanded(child: Text('Lat: ${_lat.toStringAsFixed(6)}')),
            Expanded(child: Text('Lng: ${_lng.toStringAsFixed(6)}')),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
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
                      controller.updatePlace(widget.place!.id, place.toMap());
                    }
                  }
                },
          child: controller.isSaving.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'ENREGISTRER',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
