import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class PdfService {
  static Future<File> generateQuotePdf({
    required String customerName,
    required String projectName,
    required double totalJobCost,
    required List<Map<String, dynamic>> materials,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Header(
                level: 0,
                child: pw.Text(
                  'M & M RENDER QUOTE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Customer Info
              pw.Row(
                children: [
                  pw.Text(
                    'Customer: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(customerName),
                ],
              ),
              pw.Row(
                children: [
                  pw.Text(
                    'Project: ',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(projectName),
                ],
              ),
              pw.Divider(),

              // Quote Total
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total Price: \$${totalJobCost.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // Materials Table
              pw.Text(
                'Materials Breakdown:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Table.fromTextArray(
                context: context,
                border: pw.TableBorder.all(),
                headers: ['Material', 'Quantity', 'Unit Price', 'Total'],
                data: materials.map((material) {
                  return [
                    material['name'],
                    material['quantity'].toStringAsFixed(2),
                    '\$${material['unitPrice'].toStringAsFixed(2)}',
                    '\$${material['total'].toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),
              pw.SizedBox(height: 20),

              // Footer
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  'Thank you for choosing M & M Render!',
                  style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save PDF to temporary directory
    final output = await getTemporaryDirectory();
    final file = File(
      '${output.path}/quote_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());

    return file;
  }
}
