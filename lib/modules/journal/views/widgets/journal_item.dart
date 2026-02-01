import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../models/journal_ligne_model.dart';

class JournalItem extends StatelessWidget {
  final JournalLigneModel entry;

  const JournalItem({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formatters.formatShortDate(entry.date),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  Formatters.formatCurrency(entry.montant),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.secondaryColor,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.placeDepartNom ?? 'ID: ${entry.placeDepartId}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Container(
                height: 10,
                width: 2,
                color: Colors.grey.shade300,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.placeArriveeNom ?? 'ID: ${entry.placeArriveeId}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            if (entry.description != null && entry.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                entry.description!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
