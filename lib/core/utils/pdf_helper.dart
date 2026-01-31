// import 'dart:io';
// import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../../modules/journal/models/journal_model.dart';
import '../../modules/livreurs/models/livreur_model.dart';

class PdfHelper {
  static Future<void> generateAndPrintJournalPdf(
    LivreurModel livreur,
    List<JournalModel> entries,
  ) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.rubikRegular();
    final fontBold = await PdfGoogleFonts.rubikBold();
    
    double total = entries.fold(0, (sum, item) => sum + item.montant);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (context) => [
          _buildHeader(livreur),
          pw.SizedBox(height: 20),
          _buildTable(entries),
           pw.SizedBox(height: 20),
           pw.Row(
             mainAxisAlignment: pw.MainAxisAlignment.end,
             children: [
               pw.Text("Total: ${NumberFormat.simpleCurrency(name: 'MRU', decimalDigits: 0).format(total)}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
             ]
           )
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildHeader(LivreurModel livreur) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Journal de livraison',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Livreur: ${livreur.nom}'),
        pw.Text('Téléphone: ${livreur.telephone}'),
        pw.Text('Date d\'impression: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
      ],
    );
  }

  static pw.Widget _buildTable(List<JournalModel> entries) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Départ', 'Arrivée', 'Montant', 'Description'],
      data: entries.map((entry) {
        return [
          DateFormat('dd/MM/yyyy HH:mm').format(entry.date),
          entry.lieuDepart,
          entry.lieuArrivee,
          "${entry.montant} MRU",
          entry.description ?? '-',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }
}
