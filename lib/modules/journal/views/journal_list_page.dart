import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/journal_controller.dart';
import '../widgets/journal_item.dart';
import 'journal_form_page.dart';
import '../../livreurs/models/livreur_model.dart';
import '../../../shared/widgets/loading.dart';

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
    controller.fetchEntries(widget.livreur.id);
  }
  
  @override
  void dispose() {
    // Optionally delete controller if unique per page, but keeping valid for returning matches Use Case
    // Get.delete<JournalController>(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal des courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => controller.exportPdf(widget.livreur),
            tooltip: 'Exporter PDF',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => JournalFormPage(livreurId: widget.livreur.id)),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Loading();
        }

        if (controller.entries.isEmpty) {
          return const Center(child: Text('Aucune course enregistrée'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.entries.length,
          itemBuilder: (context, index) {
            return JournalItem(entry: controller.entries[index]);
          },
        );
      }),
    );
  }
}
