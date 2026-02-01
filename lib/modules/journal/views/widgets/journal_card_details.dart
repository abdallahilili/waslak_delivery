import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../models/journal_model.dart';
import '../../controllers/journal_controller.dart';
import '../widgets/journal_item.dart';
import '../../../livreurs/models/livreur_model.dart';

class JournalCardDetails extends StatelessWidget {
  final JournalModel journal;
  final LivreurModel livreur;
  final JournalController controller;

  const JournalCardDetails({
    Key? key,
    required this.journal,
    required this.livreur,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1),
        Container(
          color: Colors.grey.withOpacity(0.02),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (journal.statut == 'ouvert')
                ElevatedButton.icon(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Clôturer',
                      middleText: 'Voulez-vous vraiment clôturer ce journal ?',
                      textConfirm: 'Oui, clôturer',
                      textCancel: 'Annuler',
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        controller.closeJournal(journal.id, livreur.id);
                        Get.back();
                      },
                      buttonColor: Colors.red,
                    );
                  },
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Clôturer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              if (journal.statut != 'ouvert')
                Text(
                  "Fermé le ${journal.dateFin != null ? DateFormat('dd/MM HH:mm').format(journal.dateFin!) : '-'}",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                tooltip: 'Télécharger PDF',
                onPressed: () {
                  final lines = controller.getLinesForJournal(journal.id);
                  controller.exportPdf(livreur, journal, lines);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Obx(() {
          final lines = controller.getLinesForJournal(journal.id);
          if (lines.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(
                child: Text(
                  "Aucune course dans ce journal",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: lines.length,
            itemBuilder: (context, index) {
              return JournalCardItem(entry: lines[index]);
            },
          );
        }),
      ],
    );
  }
}

// Rename the internal item to avoid confusion with existing JournalItem if it exists
// Looking at the view_file of journal_item.dart might be needed if I wanted to rename it, 
// but I'll use JournalItem for now as seen in journal_list_page.dart (line 6)
// Wait, the original code used `JournalItem(entry: lines[index])`
// I'll assume JournalItem is already a widget in ../widgets/journal_item.dart
class JournalCardItem extends StatelessWidget {
  final dynamic entry; // Using dynamic because I don't see the model for lines here yet
  const JournalCardItem({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return JournalItem(entry: entry);
  }
}
