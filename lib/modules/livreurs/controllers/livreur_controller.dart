import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/livreur_model.dart';
import '../models/livreur_filter_model.dart';
import '../../../../core/services/storage_service.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LivreurController extends GetxController {
  final _client = Supabase.instance.client;
  final _storageService = StorageService();

  final livreurs = <LivreurModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;
  final totalCount = 0.obs;
  
  final currentFilter = LivreurFilter().obs;
  final selectedLivreur = Rxn<LivreurModel>();

  @override
  void onInit() {
    super.onInit();
    fetchLivreurs();
  }

  Future<void> fetchLivreurs() async {
    try {
      isLoading.value = true;
      var query = _client.from('livreurs').select();
      
      final filter = currentFilter.value;

      // Appliquer les filtres
      if (filter.query != null && filter.query!.isNotEmpty) {
        query = query.or('nom.ilike.%${filter.query}%,telephone.ilike.%${filter.query}%,nni.ilike.%${filter.query}%');
      }

      if (filter.statut != null && filter.statut != 'tous') {
        query = query.eq('statut', filter.statut!);
      }

      if (filter.zone != null) {
        query = query.eq('zone_service', filter.zone!);
      }

      final response = await query
          .order('created_at', ascending: false)
          .count(CountOption.exact);
      
      final List<dynamic> data = response.data;
      totalCount.value = response.count;
      livreurs.value = data.map((json) => LivreurModel.fromMap(json)).toList();
    } catch (e) {
      print('Fetch error: $e');
      Get.snackbar('Erreur', 'Impossible de charger les livreurs');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLivreur(LivreurModel livreur) async {
    try {
      isSaving.value = true;
      await _client.from('livreurs').insert(livreur.toMap());
      fetchLivreurs();
      Get.back();
      Get.snackbar('Succès', 'Livreur créé');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la création: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateLivreur(String id, Map<String, dynamic> data) async {
    try {
      isSaving.value = true;
      await _client.from('livreurs').update(data).eq('id', id);
      
      // Update local state if needed
      final index = livreurs.indexWhere((l) => l.id == id);
      if (index != -1) {
        // Optionnel: Re-fetch or manually update
        fetchLivreurs();
      }
      
      if (selectedLivreur.value?.id == id) {
        getLivreurDetails(id);
      }

      Get.snackbar('Succès', 'Livreur mis à jour');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la mise à jour: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteLivreur(String id) async {
    try {
      // Soft delete si vous avez un champ deleted_at, sinon delete physique
      await _client.from('livreurs').delete().eq('id', id);
      livreurs.removeWhere((l) => l.id == id);
      Get.snackbar('Succès', 'Livreur supprimé');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la suppression');
    }
  }

  Future<String?> uploadDocument(File file, String folder) async {
    try {
      return await _storageService.uploadImage(file, folder);
    } catch (e) {
       Get.snackbar('Erreur', 'Upload échoué: $e');
       return null;
    }
  }

  Future<void> toggleStatus(String id, String newStatus) async {
    await updateLivreur(id, {'statut': newStatus});
  }

  void searchLivreurs(String query) {
    currentFilter.update((val) {
      val?.query = query;
    });
    fetchLivreurs();
  }

  void filterLivreurs(LivreurFilter filter) {
    currentFilter.value = filter;
    fetchLivreurs();
  }

  Future<void> getLivreurDetails(String id) async {
    try {
      final response = await _client.from('livreurs').select().eq('id', id).single();
      selectedLivreur.value = LivreurModel.fromMap(response);
    } catch (e) {
      Get.snackbar('Erreur', 'Détails non trouvés');
    }
  }

  Future<void> exportToExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Livreurs'];

      // Headers
      sheetObject.appendRow([
        TextCellValue('ID'),
        TextCellValue('Nom'),
        TextCellValue('Téléphone'),
        TextCellValue('Statut'),
        TextCellValue('Zone'),
        TextCellValue('Livraisons Complétées'),
      ]);

      for (var l in livreurs) {
        sheetObject.appendRow([
          TextCellValue(l.id),
          TextCellValue(l.nom),
          TextCellValue(l.telephone),
          TextCellValue(l.statut),
          TextCellValue(l.zoneService ?? '-'),
          IntCellValue(l.nbLivraisonsCompletees),
        ]);
      }

      var fileBytes = excel.save();
      var directory = await getTemporaryDirectory();
      File("${directory.path}/livreurs_export.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      await Share.shareXFiles([XFile("${directory.path}/livreurs_export.xlsx")], text: 'Export des livreurs');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de l\'export: $e');
    }
  }
}
