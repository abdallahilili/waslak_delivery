import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/journal_controller.dart';
import '../widgets/journal_item.dart';
import 'journal_form_page.dart';
import '../../livreurs/models/livreur_model.dart';

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
    controller.fetchActiveJournal(widget.livreur.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal - ${widget.livreur.nom}'),
        actions: [
          Obx(() => controller.currentJournal.value != null 
            ? IconButton(
                icon: const Icon(Icons.print),
                onPressed: () => controller.exportPdf(
                  widget.livreur, 
                  controller.currentJournal.value!, 
                  controller.journalLines
                ),
                tooltip: 'Exporter PDF',
              )
            : const SizedBox.shrink()
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final journal = controller.currentJournal.value;

        if (journal == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.book_outlined, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('Aucun journal ouvert pour ce livreur'),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.createJournal(widget.livreur.id),
                  icon: const Icon(Icons.add),
                  label: const Text('OUVRIR UN NOUVEAU JOURNAL'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue.withOpacity(0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Journal ouvert le ${DateFormat('dd/MM HH:mm').format(journal.dateDebut)}', 
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Total: ${journal.total} MRU', 
                          style: const TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Clôturer',
                        middleText: 'Voulez-vous clôturer ce journal ?',
                        onConfirm: () {
                          controller.closeJournal(journal.id, widget.livreur.id);
                          Get.back();
                        },
                        textCancel: 'Non',
                        textConfirm: 'Oui, clôturer',
                        confirmTextColor: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                    child: const Text('CLÔTURER'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: controller.journalLines.isEmpty
                  ? const Center(child: Text('Aucune course dans ce journal'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.journalLines.length,
                      itemBuilder: (context, index) {
                        final line = controller.journalLines[index];
                        return JournalItem(entry: line);
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: Obx(() => controller.currentJournal.value != null 
        ? FloatingActionButton(
            onPressed: () => Get.to(() => JournalFormPage(
              livreurId: widget.livreur.id, 
              journalId: controller.currentJournal.value!.id
            )),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          )
        : const SizedBox.shrink()
      ),
    );
  }
}
