import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/journal_model.dart';
import '../models/journal_ligne_model.dart';
import '../../livreurs/models/livreur_model.dart';
import '../../../core/utils/pdf_helper.dart';

class JournalController extends GetxController {
  final _client = Supabase.instance.client;
  
  final currentJournal = Rxn<JournalModel>(); // Keeps track of the OPEN journal for easy access
  final journals = <JournalModel>[].obs; // List of all journals
  
  // Map to store lines for each journal: key is journalId
  final journalLinesMap = <String, List<JournalLigneModel>>{}.obs;
  
  final isLoading = false.obs;
  final isSaving = false.obs;

  // Helper to get lines for a specific journal
  List<JournalLigneModel> getLinesForJournal(String journalId) {
    return journalLinesMap[journalId] ?? [];
  }

  Future<void> fetchJournals(String livreurId) async {
    try {
      isLoading.value = true;
      final response = await _client
          .from('journaux')
          .select()
          .eq('livreur_id', livreurId)
          .order('date_debut', ascending: false);
          
      final data = response as List<dynamic>;
      final list = data.map((json) => JournalModel.fromMap(json)).toList();

      // Sort: 'ouvert' first, then by date desc (already sorted by query mostly, but let's ensure 'ouvert' is top)
      list.sort((a, b) {
        if (a.statut == 'ouvert' && b.statut != 'ouvert') return -1;
        if (a.statut != 'ouvert' && b.statut == 'ouvert') return 1;
        // If same status, keep existing order (date desc)
        return b.dateDebut.compareTo(a.dateDebut);
      });

      journals.value = list;

      // Update currentJournal reference to the open one if exists
      try {
        currentJournal.value = list.firstWhere((j) => j.statut == 'ouvert');
        // Automatically fetch lines for the open journal
        await fetchLinesForJournal(currentJournal.value!.id);
      } catch (e) {
        currentJournal.value = null;
      }
      
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger les journaux: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLinesForJournal(String journalId) async {
    try {
      final response = await _client
          .from('journal_lignes')
          .select('*, places_depart:place_depart_id(nom), places_arrivee:place_arrivee_id(nom)')
          .eq('journal_id', journalId)
          .order('date', ascending: false);
          
      final data = response as List<dynamic>;
      final lines = data.map((json) => JournalLigneModel.fromMap(json)).toList();
      
      journalLinesMap[journalId] = lines;
      // Force update of the map to trigger Obx
      journalLinesMap.refresh(); 
      
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
      
      final newJournal = JournalModel.fromMap(response);
      
      // Add to list and sort
      journals.add(newJournal);
      // Re-sort
      journals.sort((a, b) {
        if (a.statut == 'ouvert' && b.statut != 'ouvert') return -1;
         if (a.statut != 'ouvert' && b.statut == 'ouvert') return 1;
        return b.dateDebut.compareTo(a.dateDebut);
      });
      
      currentJournal.value = newJournal;
      journalLinesMap[newJournal.id] = [];
      
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

      // Calculate new total
      final linesResponse = await _client
          .from('journal_lignes')
          .select('montant')
          .eq('journal_id', journalId);
          
      final linesData = linesResponse as List<dynamic>;
      double newTotal = 0;
      for (var line in linesData) {
        newTotal += (line['montant'] as num).toDouble();
      }

      // Update journal total in database
      await _client.from('journaux').update({
        'total': newTotal
      }).eq('id', journalId);
      
      await fetchLinesForJournal(journalId);
      // Refresh journals to get updated total
      await fetchJournals(livreurId);
      
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
      
      // Refresh list to update status and sorting
      await fetchJournals(livreurId);
      
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
