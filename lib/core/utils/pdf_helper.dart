import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../modules/journal/models/journal_model.dart';
import '../../modules/journal/models/journal_ligne_model.dart';
import '../../modules/livreurs/models/livreur_model.dart';

class PdfHelper {
  static Future<void> generateAndPrintJournalPdf(
    LivreurModel livreur,
    JournalModel journal,
    List<JournalLigneModel> lines,
  ) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.rubikRegular();
    final fontBold = await PdfGoogleFonts.rubikBold();
    
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (context) => [
          _buildHeader(livreur, journal),
          pw.SizedBox(height: 20),
          _buildTable(lines),
           pw.SizedBox(height: 20),
           pw.Row(
             mainAxisAlignment: pw.MainAxisAlignment.end,
             children: [
               pw.Text("Total: ${NumberFormat.simpleCurrency(name: 'MRU', decimalDigits: 0).format(journal.total)}", 
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
             ]
           )
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildHeader(LivreurModel livreur, JournalModel journal) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Journal de livraison',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Livreur: ${livreur.nom}'),
        pw.Text('Téléphone: ${livreur.telephone}'),
        pw.Text('Période: ${DateFormat('dd/MM/yyyy').format(journal.dateDebut)} - ${journal.dateFin != null ? DateFormat('dd/MM/yyyy').format(journal.dateFin!) : 'En cours'}'),
        pw.Text('Statut: ${journal.statut.toUpperCase()}'),
        pw.Text('Date d\'impression: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}'),
      ],
    );
  }

  static pw.Widget _buildTable(List<JournalLigneModel> lines) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Départ', 'Arrivée', 'Montant', 'Description'],
      data: lines.map((line) {
        return [
          DateFormat('dd/MM/yyyy HH:mm').format(line.date),
          line.placeDepartNom ?? 'ID: ${line.placeDepartId}',
          line.placeArriveeNom ?? 'ID: ${line.placeArriveeId}',
          "${line.montant} MRU",
          line.description ?? '-',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellAlignment: pw.Alignment.centerLeft,
    );
  }
}
