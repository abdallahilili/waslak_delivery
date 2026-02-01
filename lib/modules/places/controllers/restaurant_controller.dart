import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/restaurant_model.dart';
import '../../../../core/services/storage_service.dart';

class RestaurantController extends GetxController {
  final _client = Supabase.instance.client;
  final _storageService = StorageService();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final currentRestaurant = Rxn<RestaurantModel>();

  // Use a map to simplify menu editing in UI: List of {name, price, description}
  final menuItems = <Map<String, dynamic>>[].obs;

  Future<void> fetchRestaurantByPlaceId(String placeId) async {
    try {
      isLoading.value = true;
      currentRestaurant.value = null; // Reset

      final response = await _client
          .from('restaurants')
          .select()
          .eq('place_id', placeId)
          .maybeSingle();

      if (response != null) {
        currentRestaurant.value = RestaurantModel.fromMap(response);
        _parseMenu(currentRestaurant.value!.menu);
      }
    } catch (e) {
      // It's okay if not found (maybeSingle returns null), but if error log it
      print('Error fetching restaurant: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _parseMenu(Map<String, dynamic>? menuData) {
    menuItems.clear();
    if (menuData != null && menuData['items'] != null) {
      final List<dynamic> items = menuData['items'];
      menuItems.assignAll(items.map((e) => Map<String, dynamic>.from(e)).toList());
    }
  }

  Future<void> saveRestaurant({
    required String placeId,
    required String nom,
    required String typeCuisine,
    String? description,
    File? logoFile,
    File? coverFile,
    bool actif = true,
    bool isUpdate = false,
    String? existingId,
  }) async {
    try {
      isSaving.value = true;

      String? logoUrl;
      String? coverUrl;

      if (logoFile != null) {
        logoUrl = await _storageService.uploadImage(logoFile, 'restaurants_logos');
      } else if (isUpdate && currentRestaurant.value != null) {
        logoUrl = currentRestaurant.value!.logoUrl;
      }

      if (coverFile != null) {
        coverUrl = await _storageService.uploadImage(coverFile, 'restaurants_covers');
      } else if (isUpdate && currentRestaurant.value != null) {
        coverUrl = currentRestaurant.value!.couvertureUrl;
      }

      // Construct menu JSON
      final menuJson = {
        'items': menuItems.toList(),
      };

      final restaurantData = {
        'place_id': placeId,
        'nom': nom,
        'type_cuisine': typeCuisine,
        'description': description,
        'menu': menuJson,
        'logo_url': logoUrl,
        'couverture_url': coverUrl,
        'actif': actif,
      };

      if (isUpdate && existingId != null) {
        final response = await _client
            .from('restaurants')
            .update(restaurantData)
            .eq('id', existingId)
            .select()
            .single();
        currentRestaurant.value = RestaurantModel.fromMap(response);
      } else {
        final response = await _client
            .from('restaurants')
            .insert(restaurantData)
            .select()
            .single();
        currentRestaurant.value = RestaurantModel.fromMap(response);
      }
      
      Get.back(); // Return to previous screen (usually list or detail)
      if (!isUpdate) {
          // If created, we might want to go to detail, but simpler flow is back to list then click again or replace route?
          // User said: "si la place pas assicier ... redirect vers restaurant_from_page ... formulaire de creation"
          // "doit etre comme celui d'affichage detail"
      }
      Get.snackbar('Succès', 'Restaurant enregistré avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d\'enregistrer le restaurant: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      isLoading.value = true;
      await _client.from('restaurants').delete().eq('id', id);
      currentRestaurant.value = null;
      Get.back(); // Back to list
      Get.snackbar('Succès', 'Restaurant supprimé');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Menu Management Helper
  void addMenuItem(String name, double price, String desc) {
    menuItems.add({
      'name': name,
      'price': price,
      'description': desc,
    });
  }

  void removeMenuItem(int index) {
    menuItems.removeAt(index);
  }
}
