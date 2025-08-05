import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'global_pricing.dart';

class MaterialBreakdownScreen extends StatefulWidget {
  final GlobalPricing pricing;
  final String customerName;
  final String customerMobile;
  final String customerEmail;
  final String projectName;
  final double renderSQM;
  final double hebelSQM;
  final double acrylicSQM;
  final double foamSQM;
  final double labourHours;
  final double traderHours;
  final int quoins;
  final int bulkheads;
  final int plynth;
  final int columns;
  final int windowBands;

  const MaterialBreakdownScreen({
    super.key,
    required this.pricing,
    required this.customerName,
    required this.customerMobile,
    required this.customerEmail,
    required this.projectName,
    required this.renderSQM,
    required this.hebelSQM,
    required this.acrylicSQM,
    required this.foamSQM,
    required this.labourHours,
    required this.traderHours,
    required this.quoins,
    required this.bulkheads,
    required this.plynth,
    required this.columns,
    required this.windowBands,
  });

  @override
  State<MaterialBreakdownScreen> createState() =>
      _MaterialBreakdownScreenState();
}

class _MaterialBreakdownScreenState extends State<MaterialBreakdownScreen> {
  final TextEditingController _termsController = TextEditingController(
    text:
        "This quote is valid for 30 days from the date of issue\n"
        "Payment due within 14 days of completion\n"
        "50% deposit required to secure booking\n"
        "GST included where applicable",
  );
  final TextEditingController _managerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _getCurrentDate();
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
  String _formatNumber(double value) => value.toStringAsFixed(2);

  // Material calculations
  double get sandTonnes => widget.renderSQM / 35;
  double get cementBags => sandTonnes * 10;
  double get frBags => widget.hebelSQM / 6;
  double get p400Bags => widget.foamSQM / 6;
  double get acrylicBags => widget.acrylicSQM / 3;

  // Cost calculations
  double get labourCost {
    double cost = widget.labourHours * widget.pricing.labourHourlyRate;
    return cost < widget.pricing.minLabourCost
        ? widget.pricing.minLabourCost
        : cost;
  }

  double get traderCost {
    double cost = widget.traderHours * widget.pricing.traderHourlyRate;
    return cost < widget.pricing.minTraderCost
        ? widget.pricing.minTraderCost
        : cost;
  }

  double get totalLabourCost => labourCost + traderCost;

  double get frBagsCost => frBags * widget.pricing.hebalPrice;
  double get p400BagsCost => p400Bags * widget.pricing.foamPrice;
  double get acrylicBagsCost => acrylicBags * widget.pricing.brickPrice;

  double get quoinsCost => widget.quoins * widget.pricing.quoinsPerPiece;
  double get bulkheadsCost => widget.bulkheads * widget.pricing.bulkHeadPerLM;
  double get plynthCost => widget.plynth * widget.pricing.bandsPlinthsPerLM;
  double get columnsCost => widget.columns * widget.pricing.pillarsPerItem;
  double get windowBandsCost =>
      widget.windowBands * widget.pricing.windowPerItem;

  double get totalMaterialCost =>
      frBagsCost +
      p400BagsCost +
      acrylicBagsCost +
      quoinsCost +
      bulkheadsCost +
      plynthCost +
      columnsCost +
      windowBandsCost;

  double get baseCost => totalMaterialCost + totalLabourCost;
  double get profitAmount => baseCost * (widget.pricing.profitPercentage / 100);
  double get gst => (baseCost + profitAmount) * 0.10;
  double get totalJobCost => baseCost + profitAmount + gst;

  double get totalSQM =>
      widget.renderSQM + widget.hebelSQM + widget.acrylicSQM + widget.foamSQM;

  Future<void> _generateAndShowPdf() async {
    try {
      final pdf = pw.Document();

      // Build PDF content
      final content = [
        // Header
        _buildPdfHeader(),
        pw.SizedBox(height: 20),

        // Customer and project info
        _buildCustomerInfo(),
        pw.SizedBox(height: 30),

        // Quote summary table
        _buildQuoteSummaryTable(),
        pw.SizedBox(height: 30),

        // Scope of work
        _buildScopeOfWork(),
        pw.SizedBox(height: 30),

        // Material breakdown table
        _buildMaterialBreakdownTable(),
        pw.SizedBox(height: 30),

        // Terms & conditions
        _buildTermsAndConditions(),
        pw.SizedBox(height: 20),

        // Manager approval
        _buildManagerApproval(),
        pw.SizedBox(height: 20),

        // Footer
        _buildFooter(),
      ];

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: content,
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File(
        '${output.path}/quote_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => file.readAsBytes(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to generate PDF: $e')));
      }
    }
  }

  pw.Widget _buildPdfHeader() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            'M & M RENDER',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.red,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'QUOTE',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(thickness: 1.5),
        ],
      ),
    );
  }

  pw.Widget _buildCustomerInfo() {
    return pw.Column(
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
                pw.Text(widget.customerName),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Mobile: ${widget.customerMobile}',
                  style: pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Email: ${widget.customerEmail}',
                  style: pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text('Date: ${_dateController.text}'),
                pw.Text(
                  'Quote #: ${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Project: ${widget.projectName}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildQuoteSummaryTable() {
    return pw.Table(
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
                _formatCurrency(totalJobCost),
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
                _formatCurrency(gst),
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
                _formatCurrency(totalMaterialCost),
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
                _formatCurrency(totalLabourCost),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildScopeOfWork() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'SCOPE OF WORK',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Bullet(
          text: 'Render application: ${_formatNumber(widget.renderSQM)} m²',
        ),
        pw.Bullet(
          text: 'Hebel application: ${_formatNumber(widget.hebelSQM)} m²',
        ),
        pw.Bullet(
          text: 'Acrylic finish: ${_formatNumber(widget.acrylicSQM)} m²',
        ),
        pw.Bullet(
          text: 'Foam application: ${_formatNumber(widget.foamSQM)} m²',
        ),
        if (widget.quoins > 0)
          pw.Bullet(text: 'Quoins: ${widget.quoins} pieces'),
        if (widget.bulkheads > 0)
          pw.Bullet(text: 'Bulkheads: ${widget.bulkheads} LM'),
        if (widget.plynth > 0) pw.Bullet(text: 'Plinths: ${widget.plynth} LM'),
        if (widget.columns > 0)
          pw.Bullet(text: 'Columns: ${widget.columns} items'),
        if (widget.windowBands > 0)
          pw.Bullet(text: 'Window bands: ${widget.windowBands} items'),
      ],
    );
  }

  pw.Widget _buildMaterialBreakdownTable() {
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
            0: const pw.FixedColumnWidth(30), // Sr. No.
            1: const pw.FixedColumnWidth(80), // Substrate
            2: const pw.FixedColumnWidth(80), // Material
            3: const pw.FixedColumnWidth(60), // Quantity
            4: const pw.FixedColumnWidth(60), // Unit Price
            5: const pw.FixedColumnWidth(60), // Total
            6: const pw.FixedColumnWidth(40), // SQM
          },
          children: [
            // Table header
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                _buildPdfTableCell('Sr. No.', isHeader: true),
                _buildPdfTableCell('Substrate', isHeader: true),
                _buildPdfTableCell('Material', isHeader: true),
                _buildPdfTableCell('Quantity', isHeader: true),
                _buildPdfTableCell('Unit Price', isHeader: true),
                _buildPdfTableCell('Total', isHeader: true),
                _buildPdfTableCell('SQM', isHeader: true),
              ],
            ),
            // Data rows
            _buildPdfMaterialRow(
              '1',
              'Sand & Cement',
              'Sand (Tonnes)',
              _formatNumber(sandTonnes),
              _formatCurrency(0.0),
              _formatCurrency(0.0),
              _formatNumber(widget.renderSQM),
            ),
            _buildPdfMaterialRow(
              '2',
              'Sand & Cement',
              'Cement (Bags)',
              _formatNumber(cementBags),
              _formatCurrency(0.0),
              _formatCurrency(0.0),
              _formatNumber(widget.renderSQM),
            ),
            _buildPdfMaterialRow(
              '3',
              'Hebel',
              'FR Bags',
              _formatNumber(frBags),
              _formatCurrency(widget.pricing.hebalPrice),
              _formatCurrency(frBagsCost),
              _formatNumber(widget.hebelSQM),
            ),
            _buildPdfMaterialRow(
              '4',
              'Foam',
              'P400 Bags',
              _formatNumber(p400Bags),
              _formatCurrency(widget.pricing.foamPrice),
              _formatCurrency(p400BagsCost),
              _formatNumber(widget.foamSQM),
            ),
            _buildPdfMaterialRow(
              '5',
              'Acrylic',
              'Acrylic Bags',
              _formatNumber(acrylicBags),
              _formatCurrency(widget.pricing.brickPrice),
              _formatCurrency(acrylicBagsCost),
              _formatNumber(widget.acrylicSQM),
            ),
            _buildPdfMaterialRow(
              '6',
              'Features',
              'Quoins',
              widget.quoins.toString(),
              _formatCurrency(widget.pricing.quoinsPerPiece),
              _formatCurrency(quoinsCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '7',
              'Features',
              'Bulkheads',
              widget.bulkheads.toString(),
              _formatCurrency(widget.pricing.bulkHeadPerLM),
              _formatCurrency(bulkheadsCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '8',
              'Features',
              'Plynths',
              widget.plynth.toString(),
              _formatCurrency(widget.pricing.bandsPlinthsPerLM),
              _formatCurrency(plynthCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '9',
              'Features',
              'Columns',
              widget.columns.toString(),
              _formatCurrency(widget.pricing.pillarsPerItem),
              _formatCurrency(columnsCost),
              '-',
            ),
            _buildPdfMaterialRow(
              '10',
              'Features',
              'Window Bands',
              widget.windowBands.toString(),
              _formatCurrency(widget.pricing.windowPerItem),
              _formatCurrency(windowBandsCost),
              '-',
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Total Material Cost: ${_formatCurrency(totalMaterialCost)}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    );
  }

  pw.TableRow _buildPdfMaterialRow(
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

  pw.Widget _buildPdfTableCell(String text, {bool isHeader = false}) {
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

  pw.Widget _buildTermsAndConditions() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'TERMS & CONDITIONS',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 10),
        pw.Text(_termsController.text),
      ],
    );
  }

  pw.Widget _buildManagerApproval() {
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
          children: [
            pw.Text('Manager: ${_managerController.text}'),
            pw.Text('Date: ${_dateController.text}'),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Center(child: pw.Text('Signature: _________________________')),
      ],
    );
  }

  pw.Widget _buildFooter() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Breakdown'),
        backgroundColor: const Color(0xFF550101),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: const Color(0xFF731112),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header section
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // Material breakdown card - centered with proper layout
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: _buildMaterialBreakdownCard(),
                ),
              ),
              const SizedBox(height: 16),

              // Quote summary card
              _buildQuoteSummaryCard(),
              const SizedBox(height: 16),

              // Terms & Conditions
              _buildTermsConditionsCard(),
              const SizedBox(height: 16),

              // Manager approval
              _buildManagerApprovalCard(),
              const SizedBox(height: 16),

              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Assuming this is the active screen
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => _getScreenForIndex(index, widget.pricing),
            ),
          );
        },
        backgroundColor: const Color(0xFF550101),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Pricing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.engineering),
            label: 'Labour',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _getScreenForIndex(int index, GlobalPricing pricing) {
    switch (index) {
      case 0:
        // Return your home screen with pricing passed
        return Container(); // Replace with actual home screen
      case 1:
        // Return pricing screen
        return Container(); // Replace with actual pricing screen
      case 2:
        // Return labour screen
        return Container(); // Replace with actual labour screen
      case 3:
        // Return profile screen
        return Container(); // Replace with actual profile screen
      default:
        return Container();
    }
  }

  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'M & M RENDER',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Customer: ${widget.customerName}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            Text(
              'Project: ${widget.projectName}',
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuoteSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF550101),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFB3B3B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quote Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFB3B3B),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      'ID250718',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    widget.customerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.share, color: Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Job Price (Inc. GST):',
            _formatCurrency(totalJobCost),
          ),
          _buildSummaryRow(
            'Material Cost:',
            _formatCurrency(totalMaterialCost),
          ),
          _buildSummaryRow('Labour Cost:', _formatCurrency(totalLabourCost)),
          _buildSummaryRow('Total SQM:', _formatNumber(totalSQM)),
          _buildSummaryRow('Profit (Exc. GST):', _formatCurrency(profitAmount)),
          _buildSummaryRow('GST:', _formatCurrency(gst)),
        ],
      ),
    );
  }

  Widget _buildMaterialBreakdownCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF550101),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFB3B3B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Material Breakdown',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Table(
              border: TableBorder.all(color: const Color(0xFFFB3B3B)),
              columnWidths: const {
                0: FixedColumnWidth(40), // Sr. No.
                1: FixedColumnWidth(100), // Substrate
                2: FixedColumnWidth(100), // Material
                3: FixedColumnWidth(70), // Quantity
                4: FixedColumnWidth(80), // Unit Price
                5: FixedColumnWidth(80), // Total
                6: FixedColumnWidth(50), // SQM
              },
              children: [
                // Table header
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFF98353F)),
                  children: [
                    _buildTableHeader('Sr.'),
                    _buildTableHeader('Substrate'),
                    _buildTableHeader('Material'),
                    _buildTableHeader('Quantity'),
                    _buildTableHeader('Unit Price'),
                    _buildTableHeader('Total'),
                    _buildTableHeader('SQM'),
                  ],
                ),
                // Data rows
                _buildMaterialRow(
                  '1',
                  'Sand & Cement',
                  'Sand (Tonnes)',
                  _formatNumber(sandTonnes),
                  _formatCurrency(0.0),
                  _formatCurrency(0.0),
                  _formatNumber(widget.renderSQM),
                ),
                _buildMaterialRow(
                  '2',
                  'Sand & Cement',
                  'Cement (Bags)',
                  _formatNumber(cementBags),
                  _formatCurrency(0.0),
                  _formatCurrency(0.0),
                  _formatNumber(widget.renderSQM),
                ),
                _buildMaterialRow(
                  '3',
                  'Hebel',
                  'FR Bags',
                  _formatNumber(frBags),
                  _formatCurrency(widget.pricing.hebalPrice),
                  _formatCurrency(frBagsCost),
                  _formatNumber(widget.hebelSQM),
                ),
                _buildMaterialRow(
                  '4',
                  'Foam',
                  'P400 Bags',
                  _formatNumber(p400Bags),
                  _formatCurrency(widget.pricing.foamPrice),
                  _formatCurrency(p400BagsCost),
                  _formatNumber(widget.foamSQM),
                ),
                _buildMaterialRow(
                  '5',
                  'Acrylic',
                  'Acrylic Bags',
                  _formatNumber(acrylicBags),
                  _formatCurrency(widget.pricing.brickPrice),
                  _formatCurrency(acrylicBagsCost),
                  _formatNumber(widget.acrylicSQM),
                ),
                _buildMaterialRow(
                  '6',
                  'Features',
                  'Quoins',
                  widget.quoins.toString(),
                  _formatCurrency(widget.pricing.quoinsPerPiece),
                  _formatCurrency(quoinsCost),
                  '-',
                ),
                _buildMaterialRow(
                  '7',
                  'Features',
                  'Bulkheads',
                  widget.bulkheads.toString(),
                  _formatCurrency(widget.pricing.bulkHeadPerLM),
                  _formatCurrency(bulkheadsCost),
                  '-',
                ),
                _buildMaterialRow(
                  '8',
                  'Features',
                  'Plynths',
                  widget.plynth.toString(),
                  _formatCurrency(widget.pricing.bandsPlinthsPerLM),
                  _formatCurrency(plynthCost),
                  '-',
                ),
                _buildMaterialRow(
                  '9',
                  'Features',
                  'Columns',
                  widget.columns.toString(),
                  _formatCurrency(widget.pricing.pillarsPerItem),
                  _formatCurrency(columnsCost),
                  '-',
                ),
                _buildMaterialRow(
                  '10',
                  'Features',
                  'Window Bands',
                  widget.windowBands.toString(),
                  _formatCurrency(widget.pricing.windowPerItem),
                  _formatCurrency(windowBandsCost),
                  '-',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total Material Cost: ${_formatCurrency(totalMaterialCost)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsConditionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF550101),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFB3B3B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Terms & Conditions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _termsController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Edit terms and conditions...',
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManagerApprovalCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF550101),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFB3B3B)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Manager Approval',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _managerController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Manager Name',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextField(
                  controller: _dateController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Signature: _________________________',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _generateAndShowPdf,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF550101),
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: Color(0xFFFB3B3B)),
          ),
          child: const Text(
            'Generate Quote PDF',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email export functionality coming soon!'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF550101),
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: Color(0xFFFB3B3B)),
          ),
          child: const Text(
            'Export to Email',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  TableRow _buildMaterialRow(
    String srNo,
    String substrate,
    String material,
    String quantity,
    String unitPrice,
    String total,
    String sqm,
  ) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFF550101)),
      children: [
        _buildTableCell(srNo),
        _buildTableCell(substrate),
        _buildTableCell(material),
        _buildTableCell(quantity),
        _buildTableCell(unitPrice),
        _buildTableCell(total),
        _buildTableCell(sqm),
      ],
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white)),
          ),
          Container(
            width: 150,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF98353F),
              border: Border.all(color: const Color(0xFFFB3B3B)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
