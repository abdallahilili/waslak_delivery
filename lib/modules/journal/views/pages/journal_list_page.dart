import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/journal_controller.dart';
import '../widgets/journal_empty_state.dart';
import '../widgets/journal_list_tile.dart';
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
          return JournalEmptyState(
            onCreatePressed: () => controller.createJournal(widget.livreur.id),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: controller.journals.length,
          itemBuilder: (context, index) {
            final journal = controller.journals[index];
            return JournalListTile(
              journal: journal,
              livreur: widget.livreur,
              controller: controller,
              initiallyExpanded: index == 0 && journal.statut == 'ouvert',
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
}
