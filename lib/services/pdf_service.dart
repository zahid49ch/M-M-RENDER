import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:m_m_render/screens/global_pricing.dart';

class PdfService {
  static Future<File> generateQuotePdf({
    required GlobalPricing pricing,
    required String customerName,
    required String customerMobile,
    required String customerEmail,
    required String projectName,
    required double renderSQM,
    required double hebelSQM,
    required double acrylicSQM,
    required double foamSQM,
    required double labourHours,
    required double traderHours,
    required int quoins,
    required int bulkheads,
    required int plynth,
    required int columns,
    required int windowBands,
    required String termsText,
    required String managerName,
    required String date,
    required bool includeTerms,
    required bool includeScope,
    required Uint8List logoBytes,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final quoteNumber = now.millisecondsSinceEpoch.toString().substring(5);
    final logoImage = pw.MemoryImage(logoBytes);

    // Helper functions
    String formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
    String formatNumber(double value) => value.toStringAsFixed(2);

    // Calculations
    double sandTonnes = renderSQM / 35;
    double cementBags = sandTonnes * 10;
    double frBags = hebelSQM / 6;
    double p400Bags = foamSQM / 6;
    double acrylicBags = acrylicSQM / 3;

    double labourCost = (labourHours * pricing.labourHourlyRate).clamp(
      pricing.minLabourCost,
      double.infinity,
    );
    double traderCost = (traderHours * pricing.traderHourlyRate).clamp(
      pricing.minTraderCost,
      double.infinity,
    );
    double totalLabourCost = labourCost + traderCost;

    double frBagsCost = frBags * pricing.hebalPrice;
    double p400BagsCost = p400Bags * pricing.foamPrice;
    double acrylicBagsCost = acrylicBags * pricing.brickPrice;

    double quoinsCost = quoins * pricing.quoinsPerPiece;
    double bulkheadsCost = bulkheads * pricing.bulkHeadPerLM;
    double plynthCost = plynth * pricing.bandsPlinthsPerLM;
    double columnsCost = columns * pricing.pillarsPerItem;
    double windowBandsCost = windowBands * pricing.windowPerItem;

    double totalMaterialCost =
        frBagsCost +
        p400BagsCost +
        acrylicBagsCost +
        quoinsCost +
        bulkheadsCost +
        plynthCost +
        columnsCost +
        windowBandsCost;

    double baseCost = totalMaterialCost + totalLabourCost;
    double profitAmount = baseCost * (pricing.profitPercentage / 100);
    double gst = (baseCost + profitAmount) * 0.10;
    double totalJobCost = baseCost + profitAmount + gst;
    double totalSQM = renderSQM + hebelSQM + acrylicSQM + foamSQM;

    // Build PDF content
    final content = [
      // Header with logo
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Image(logoImage, width: 100, height: 50),
          pw.Column(
            children: [
              pw.Text(
                'M & M RENDER',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'QUOTE',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Container(width: 100), // Spacer for balance
        ],
      ),
      pw.Divider(thickness: 1.5),
      pw.SizedBox(height: 20),

      // Customer info
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Customer:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(customerName),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Mobile: $customerMobile',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    'Email: $customerEmail',
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('Date: $date'),
                  pw.Text('Quote #: $quoteNumber'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Project: $projectName',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
      pw.SizedBox(height: 30),

      // Quote summary
      pw.Table(
        border: pw.TableBorder.all(),
        columnWidths: {
          0: const pw.FlexColumnWidth(2),
          1: const pw.FlexColumnWidth(1),
        },
        children: [
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Total Price (Inc. GST):'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  formatCurrency(totalJobCost),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('GST Included:'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  formatCurrency(gst),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Material Cost:'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  formatCurrency(totalMaterialCost),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
          pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text('Labour Cost:'),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  formatCurrency(totalLabourCost),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 30),

      // Scope of work (conditionally included)
      if (includeScope) ...[
        _buildScopeOfWork(
          renderSQM,
          hebelSQM,
          acrylicSQM,
          foamSQM,
          quoins,
          bulkheads,
          plynth,
          columns,
          windowBands,
          formatNumber,
        ),
        pw.SizedBox(height: 30),
      ],

      // Material breakdown
      _buildMaterialBreakdownTable(
        sandTonnes,
        cementBags,
        frBags,
        p400Bags,
        acrylicBags,
        quoins,
        bulkheads,
        plynth,
        columns,
        windowBands,
        renderSQM,
        hebelSQM,
        foamSQM,
        acrylicSQM,
        pricing,
        formatNumber,
        formatCurrency,
        frBagsCost,
        p400BagsCost,
        acrylicBagsCost,
        quoinsCost,
        bulkheadsCost,
        plynthCost,
        columnsCost,
        windowBandsCost,
        totalMaterialCost,
      ),
      pw.SizedBox(height: 30),

      // Terms & conditions (conditionally included)
      if (includeTerms) ...[
        _buildTermsAndConditions(termsText),
        pw.SizedBox(height: 20),
        _buildManagerApproval(managerName, date),
        pw.SizedBox(height: 20),
      ],

      // Footer
      _buildFooter(),
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (pw.Context context) => content,
      ),
    );

    // Save to file
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/quote_$quoteNumber.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildScopeOfWork(
    double renderSQM,
    double hebelSQM,
    double acrylicSQM,
    double foamSQM,
    int quoins,
    int bulkheads,
    int plynth,
    int columns,
    int windowBands,
    String Function(double) formatNumber,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SCOPE OF WORK',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(text: 'Render application: ${formatNumber(renderSQM)} m²'),
        pw.Bullet(text: 'Hebel application: ${formatNumber(hebelSQM)} m²'),
        pw.Bullet(text: 'Acrylic finish: ${formatNumber(acrylicSQM)} m²'),
        pw.Bullet(text: 'Foam application: ${formatNumber(foamSQM)} m²'),
        if (quoins > 0) pw.Bullet(text: 'Quoins: $quoins pieces'),
        if (bulkheads > 0) pw.Bullet(text: 'Bulkheads: $bulkheads LM'),
        if (plynth > 0) pw.Bullet(text: 'Plinths: $plynth LM'),
        if (columns > 0) pw.Bullet(text: 'Columns: $columns items'),
        if (windowBands > 0)
          pw.Bullet(text: 'Window bands: $windowBands items'),
      ],
    );
  }

  static pw.Widget _buildMaterialBreakdownTable(
    double sandTonnes,
    double cementBags,
    double frBags,
    double p400Bags,
    double acrylicBags,
    int quoins,
    int bulkheads,
    int plynth,
    int columns,
    int windowBands,
    double renderSQM,
    double hebelSQM,
    double foamSQM,
    double acrylicSQM,
    GlobalPricing pricing,
    String Function(double) formatNumber,
    String Function(double) formatCurrency,
    double frBagsCost,
    double p400BagsCost,
    double acrylicBagsCost,
    double quoinsCost,
    double bulkheadsCost,
    double plynthCost,
    double columnsCost,
    double windowBandsCost,
    double totalMaterialCost,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'MATERIAL BREAKDOWN',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(),
          columnWidths: {
            0: const pw.FixedColumnWidth(30),
            1: const pw.FixedColumnWidth(80),
            2: const pw.FixedColumnWidth(80),
            3: const pw.FixedColumnWidth(60),
            4: const pw.FixedColumnWidth(60),
            5: const pw.FixedColumnWidth(60),
            6: const pw.FixedColumnWidth(40),
          },
          children: [
            // Header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildPdfTableCell('Sr.', isHeader: true),
                _buildPdfTableCell('Substrate', isHeader: true),
                _buildPdfTableCell('Material', isHeader: true),
                _buildPdfTableCell('Qty', isHeader: true),
                _buildPdfTableCell('Unit \$', isHeader: true),
                _buildPdfTableCell('Total', isHeader: true),
                _buildPdfTableCell('SQM', isHeader: true),
              ],
            ),
            // Data rows
            _buildPdfMaterialRow(
              '1',
              'Sand & Cement',
              'Sand (T)',
              formatNumber(sandTonnes),
              formatCurrency(0.0),
              formatCurrency(0.0),
              formatNumber(renderSQM),
            ),
            _buildPdfMaterialRow(
              '2',
              'Sand & Cement',
              'Cement (Bags)',
              formatNumber(cementBags),
              formatCurrency(0.0),
              formatCurrency(0.0),
              formatNumber(renderSQM),
            ),
            _buildPdfMaterialRow(
              '3',
              'Hebel',
              'FR Bags',
              formatNumber(frBags),
              formatCurrency(pricing.hebalPrice),
              formatCurrency(frBagsCost),
              formatNumber(hebelSQM),
            ),
            _buildPdfMaterialRow(
              '4',
              'Foam',
              'P400 Bags',
              formatNumber(p400Bags),
              formatCurrency(pricing.foamPrice),
              formatCurrency(p400BagsCost),
              formatNumber(foamSQM),
            ),
            _buildPdfMaterialRow(
              '5',
              'Acrylic',
              'Acrylic Bags',
              formatNumber(acrylicBags),
              formatCurrency(pricing.brickPrice),
              formatCurrency(acrylicBagsCost),
              formatNumber(acrylicSQM),
            ),
            _buildPdfMaterialRow(
              '6',
              'Features',
              'Quoins',
              quoins.toString(),
              formatCurrency(pricing.quoinsPerPiece),
              formatCurrency(quoinsCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '7',
              'Features',
              'Bulkheads',
              bulkheads.toString(),
              formatCurrency(pricing.bulkHeadPerLM),
              formatCurrency(bulkheadsCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '8',
              'Features',
              'Plynths',
              plynth.toString(),
              formatCurrency(pricing.bandsPlinthsPerLM),
              formatCurrency(plynthCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '9',
              'Features',
              'Columns',
              columns.toString(),
              formatCurrency(pricing.pillarsPerItem),
              formatCurrency(columnsCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '10',
              'Features',
              'Win. Bands',
              windowBands.toString(),
              formatCurrency(pricing.windowPerItem),
              formatCurrency(windowBandsCost),
              '-',
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Total Material Cost: ${formatCurrency(totalMaterialCost)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTermsAndConditions(String termsText) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'TERMS & CONDITIONS',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text(termsText),
      ],
    );
  }

  static pw.Widget _buildManagerApproval(String managerName, String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'MANAGER APPROVAL',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [pw.Text('Manager: $managerName'), pw.Text('Date: $date')],
        ),
        pw.SizedBox(height: 20),
        pw.Center(child: pw.Text('Signature: _________________________')),
      ],
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Divider(thickness: 1.5),
        pw.SizedBox(height: 10),
        pw.Center(
          child: pw.Text(
            'Thank you for choosing M & M Render!',
            style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
          ),
        ),
        pw.Center(
          child: pw.Text(
            'Contact: info@mmrender.com.au | Phone: (08) 7123 4567',
          ),
        ),
      ],
    );
  }

  static pw.TableRow _buildPdfMaterialRow(
    String srNo,
    String substrate,
    String material,
    String quantity,
    String unitPrice,
    String total,
    String sqm,
  ) {
    return pw.TableRow(
      children: [
        _buildPdfTableCell(srNo),
        _buildPdfTableCell(substrate),
        _buildPdfTableCell(material),
        _buildPdfTableCell(quantity),
        _buildPdfTableCell(unitPrice),
        _buildPdfTableCell(total),
        _buildPdfTableCell(sqm),
      ],
    );
  }

  static pw.Widget _buildPdfTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static Future<void> sendEmailWithPdf({
    required File pdfFile,
    required String customerName,
    required String customerEmail,
    required String projectName,
  }) async {
    final Email email = Email(
      body:
          'Dear $customerName,\n\nPlease find attached your quote for "$projectName".\n\n'
          'If you have any questions, feel free to contact us at info@mmrender.com.au or call (08) 7123 4567.\n\n'
          'Best regards,\nM & M Render Team',
      subject: 'Quote for $projectName - M & M Render',
      recipients: [customerEmail],
      attachmentPaths: [pdfFile.absolute.path],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } on PlatformException catch (e) {
      throw 'Email Error: ${e.message} (Code: ${e.code})';
    } catch (e) {
      throw 'Failed to send email: ${e.toString()}';
    }
  }
}
