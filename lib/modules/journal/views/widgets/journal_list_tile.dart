import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/journal_model.dart';
import 'journal_card_details.dart';
import '../../controllers/journal_controller.dart';
import '../../../livreurs/models/livreur_model.dart';

class JournalListTile extends StatelessWidget {
  final JournalModel journal;
  final LivreurModel livreur;
  final JournalController controller;
  final bool initiallyExpanded;

  const JournalListTile({
    Key? key,
    required this.journal,
    required this.livreur,
    required this.controller,
    required this.initiallyExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        initiallyExpanded: initiallyExpanded,
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
          DateFormat('dd MMMM yyyy HH:mm', 'fr').format(journal.dateDebut),
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
        children: [
          JournalCardDetails(
            journal: journal,
            livreur: livreur,
            controller: controller,
          )
        ],
      ),
    );
  }
}
