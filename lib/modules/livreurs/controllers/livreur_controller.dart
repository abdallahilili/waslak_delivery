import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/livreur_model.dart';
import '../../../../core/services/storage_service.dart';

class LivreurController extends GetxController {
  final _client = Supabase.instance.client;
  final _storageService = StorageService();

  final livreurs = <LivreurModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  
  // Search
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLivreurs();
    
    // Simple debounce for search
    debounce(searchQuery, (_) => fetchLivreurs(), time: const Duration(milliseconds: 500));
  }

  Future<void> fetchLivreurs() async {
    try {
      isLoading.value = true;
      var query = _client.from('livreurs').select();
      
      if (searchQuery.isNotEmpty) {
        // Search by name, phone or nni
        // Note: Supabase 'or' syntax: 'nom.ilike.%query%,telephone.ilike.%query%...'
        final s = searchQuery.value;
        query = query.or('nom.ilike.%$s%,telephone.ilike.%$s%,nni.ilike.%$s%');
      }

      final response = await query.order('created_at', ascending: false);
      
      final data = response as List<dynamic>;
      livreurs.value = data.map((json) => LivreurModel.fromMap(json)).toList();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les livreurs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLivreur(
    String nom,
    String nni,
    String telephone,
    String? whatsapp, {
    File? photoProfil,
    File? photoCni,
    File? photoCarteGrise,
    File? photoAssurance,
    File? photoMoto,
  }) async {
    try {
      isSaving.value = true;

      // Upload Images
      String? urlProfil = photoProfil != null ? await _storageService.uploadImage(photoProfil, 'profils') : null;
      String? urlCni = photoCni != null ? await _storageService.uploadImage(photoCni, 'docs') : null;
      String? urlCarteGrise = photoCarteGrise != null ? await _storageService.uploadImage(photoCarteGrise, 'docs') : null;
      String? urlAssurance = photoAssurance != null ? await _storageService.uploadImage(photoAssurance, 'docs') : null;
      String? urlMoto = photoMoto != null ? await _storageService.uploadImage(photoMoto, 'motos') : null;

      final newLivreur = {
        'nom': nom,
        'nni': nni,
        'telephone': telephone,
        'whatsapp': whatsapp,
        'photo_profil_url': urlProfil,
        'photo_cni_url': urlCni,
        'photo_carte_grise_url': urlCarteGrise,
        'photo_assurance_url': urlAssurance,
        'photo_moto_url': urlMoto,
      };

      await _client.from('livreurs').insert(newLivreur);
      
      fetchLivreurs();
      Get.back(); // Close form
      Get.snackbar('Succès', 'Livreur ajouté avec succès');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la création: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateLivreur(String id, Map<String, dynamic> updates) async {
    try {
      isSaving.value = true;
      await _client.from('livreurs').update(updates).eq('id', id);
      fetchLivreurs(); // Refresh list to reflect changes
      Get.back();
      Get.snackbar('Succès', 'Livreur mis à jour');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteLivreur(String id) async {
    try {
      await _client.from('livreurs').delete().eq('id', id);
      livreurs.removeWhere((l) => l.id == id);
      Get.back(); // If inside details
      Get.snackbar('Succès', 'Livreur supprimé');
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de supprimer: $e');
    }
  }
}
