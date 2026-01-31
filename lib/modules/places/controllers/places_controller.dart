import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/place_model.dart';

class PlacesController extends GetxController {
  final _client = Supabase.instance.client;
  
  final places = <PlaceModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    try {
      isLoading.value = true;
      final response = await _client.from('places').select().order('nom');
      final data = response as List<dynamic>;
      places.value = data.map((json) => PlaceModel.fromMap(json)).toList();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les places: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPlace(PlaceModel place) async {
    try {
      isSaving.value = true;
      await _client.from('places').insert(place.toMap());
      fetchPlaces();
      Get.back();
      Get.snackbar('Succès', 'Place ajoutée avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la création: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updatePlace(String id, Map<String, dynamic> updates) async {
    try {
      isSaving.value = true;
      await _client.from('places').update(updates).eq('id', id);
      fetchPlaces();
      Get.back();
      Get.snackbar('Succès', 'Place mise à jour');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deletePlace(String id) async {
    try {
      await _client.from('places').delete().eq('id', id);
      places.removeWhere((p) => p.id == id);
      Get.snackbar('Succès', 'Place supprimée');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer: $e');
    }
  }
}
