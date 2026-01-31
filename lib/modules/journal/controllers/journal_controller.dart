import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_model.dart';
import '../../livreurs/models/livreur_model.dart';
import '../../../core/utils/pdf_helper.dart';

class JournalController extends GetxController {
  final _client = Supabase.instance.client;
  
  final entries = <JournalModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  Future<void> fetchEntries(String livreurId) async {
    try {
      isLoading.value = true;
      final response = await _client
          .from('journal')
          .select()
          .eq('livreur_id', livreurId)
          .order('date', ascending: false);
          
      final data = response as List<dynamic>;
      entries.value = data.map((json) => JournalModel.fromMap(json)).toList();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger le journal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addEntry({
    required String livreurId,
    required double montant,
    required String depart,
    required String arrivee,
    String? description,
    required DateTime date,
  }) async {
    try {
      isSaving.value = true;
      await _client.from('journal').insert({
        'livreur_id': livreurId,
        'montant': montant,
        'lieu_depart': depart,
        'lieu_arrivee': arrivee,
        'description': description,
        'date': date.toIso8601String(),
      });
      
      fetchEntries(livreurId);
      Get.back();
      Get.snackbar('Succès', 'Course ajoutée');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de l\'ajout: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> exportPdf(LivreurModel livreur) async {
    try {
      await PdfHelper.generateAndPrintJournalPdf(livreur, entries);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de générer le PDF: $e');
    }
  }
}
