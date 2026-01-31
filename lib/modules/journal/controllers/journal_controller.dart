import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_model.dart';
import '../models/journal_ligne_model.dart';
import '../../livreurs/models/livreur_model.dart';
import '../../../core/utils/pdf_helper.dart';

class JournalController extends GetxController {
  final _client = Supabase.instance.client;
  
  final currentJournal = Rxn<JournalModel>();
  final journalLines = <JournalLigneModel>[].obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Journals list for history
  final journals = <JournalModel>[].obs;

  Future<void> fetchActiveJournal(String livreurId) async {
    try {
      isLoading.value = true;
      final response = await _client
          .from('journaux')
          .select()
          .eq('livreur_id', livreurId)
          .eq('statut', 'ouvert')
          .maybeSingle();
          
      if (response != null) {
        currentJournal.value = JournalModel.fromMap(response);
        await fetchJournalLines(currentJournal.value!.id);
      } else {
        currentJournal.value = null;
        journalLines.clear();
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger le journal actif: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchJournalLines(String journalId) async {
    try {
      final response = await _client
          .from('journal_lignes')
          .select('*, places_depart:place_depart_id(nom), places_arrivee:place_arrivee_id(nom)')
          .eq('journal_id', journalId)
          .order('date', ascending: false);
          
      final data = response as List<dynamic>;
      journalLines.value = data.map((json) => JournalLigneModel.fromMap(json)).toList();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les lignes du journal: $e');
    }
  }

  Future<void> createJournal(String livreurId) async {
    try {
      isSaving.value = true;
      final response = await _client.from('journaux').insert({
        'livreur_id': livreurId,
        'date_debut': DateTime.now().toIso8601String(),
        'statut': 'ouvert',
        'total': 0,
      }).select().single();
      
      currentJournal.value = JournalModel.fromMap(response);
      journalLines.clear();
      Get.snackbar('Succès', 'Nouveau journal ouvert');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de l\'ouverture du journal: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> addJournalLine({
    required String journalId,
    required String livreurId,
    required String placeDepartId,
    required String placeArriveeId,
    String? restaurantId,
    required double montant,
    String? description,
  }) async {
    try {
      isSaving.value = true;
      await _client.from('journal_lignes').insert({
        'journal_id': journalId,
        'livreur_id': livreurId,
        'place_depart_id': placeDepartId,
        'place_arrivee_id': placeArriveeId,
        'restaurant_id': restaurantId,
        'montant': montant,
        'description': description,
        'date': DateTime.now().toIso8601String(),
      });
      
      await fetchJournalLines(journalId);
      // Refresh journal to get updated total (if updated by function)
      await fetchActiveJournal(livreurId);
      
      Get.back();
      Get.snackbar('Succès', 'Ligne ajoutée');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de l\'ajout: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> closeJournal(String journalId, String livreurId) async {
    try {
      isSaving.value = true;
      await _client.from('journaux').update({
        'statut': 'cloture',
        'date_fin': DateTime.now().toIso8601String(),
      }).eq('id', journalId);
      
      currentJournal.value = null;
      journalLines.clear();
      Get.snackbar('Succès', 'Journal clôturé');
    } catch (e) {
      Get.snackbar('Erreur', 'Erreur lors de la clôture: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> exportPdf(LivreurModel livreur, JournalModel journal, List<JournalLigneModel> lines) async {
    try {
      await PdfHelper.generateAndPrintJournalPdf(livreur, journal, lines);
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de générer le PDF: $e');
    }
  }
}
