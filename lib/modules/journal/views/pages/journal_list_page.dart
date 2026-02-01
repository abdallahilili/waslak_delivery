import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/journal_controller.dart';
import '../../models/journal_model.dart';
import '../widgets/journal_item.dart';
import 'journal_form_page.dart';
import '../../../livreurs/models/livreur_model.dart';

class JournalListPage extends StatefulWidget {
  final LivreurModel livreur;
  const JournalListPage({Key? key, required this.livreur}) : super(key: key);

  @override
  State<JournalListPage> createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  final controller = Get.put(JournalController());

  @override
  void initState() {
    super.initState();
    controller.fetchJournals(widget.livreur.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journaux - ${widget.livreur.nom}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchJournals(widget.livreur.id),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.journals.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.book_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Aucun journal trouvé'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.createJournal(widget.livreur.id),
                  icon: const Icon(Icons.add),
                  label: const Text('OUVRIR UN NOUVEAU JOURNAL'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80), // Space for FAB
          itemCount: controller.journals.length,
          itemBuilder: (context, index) {
            final journal = controller.journals[index];
            final isOpen = journal.statut == 'ouvert';

            return Card(
              elevation: isOpen ? 4 : 1,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: isOpen
                    ? BorderSide(color: Theme.of(context).primaryColor, width: 1.5)
                    : BorderSide.none,
              ),
              child: ExpansionTile(
                initiallyExpanded: index == 0 && isOpen,
                shape: Border.all(color: Colors.transparent),
                leading: CircleAvatar(
                  backgroundColor: isOpen
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  child: Icon(
                    isOpen ? Icons.lock_open : Icons.lock,
                    color: isOpen ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                ),
                title: Text(
                  DateFormat(
                    'dd MMMM yyyy HH:mm',
                    'fr',
                  ).format(journal.dateDebut),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOpen ? Colors.black : Colors.grey[700],
                  ),
                ),
                subtitle: Text(
                  "Total: ${journal.total} MRU",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOpen ? Theme.of(context).primaryColor : Colors.grey,
                    fontSize: 16,
                  ),
                ),
                onExpansionChanged: (expanded) {
                  if (expanded) {
                    controller.fetchLinesForJournal(journal.id);
                  }
                },
                children: [_buildJournalDetails(journal)],
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        final openJournal = controller.currentJournal.value;
        if (openJournal == null) {
          return FloatingActionButton.extended(
            onPressed: () => controller.createJournal(widget.livreur.id),
            label: const Text("Nouveau Journal"),
            icon: const Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
          );
        } else {
          return FloatingActionButton(
            onPressed: () => Get.to(
              () => JournalFormPage(
                livreurId: widget.livreur.id,
                journalId: openJournal.id,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.bike_scooter, color: Colors.white),
            tooltip: "Ajouter course",
          );
        }
      }),
    );
  }

  Widget _buildJournalDetails(JournalModel journal) {
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
                        controller.closeJournal(journal.id, widget.livreur.id);
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
                  controller.exportPdf(widget.livreur, journal, lines);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Obx(() {
          final lines = controller.getLinesForJournal(journal.id);
          // Check if lines are loaded or loading
          // Note: fetchLines doesn't have a per-journal loading state nicely exposed yet,
          // but Obx will update when it arrives.

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
              return JournalItem(entry: lines[index]);
            },
          );
        }),
      ],
    );
  }
}
