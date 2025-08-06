import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';
import 'dart:typed_data';
import 'global_pricing.dart';
import 'package:m_m_render/services/pdf_service.dart';
import 'quote_screen.dart';
import 'pricing_screen.dart';
import 'labour_calculation_screen.dart';
import 'profile_screen.dart';

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
  late Uint8List _logoBytes;
  bool _isLoadingLogo = true;

  // Toggle controls
  bool _includeTerms = true;
  bool _includeScope = true;

  @override
  void initState() {
    super.initState();
    _dateController.text = _getCurrentDate();
    _loadLogo();
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  Future<void> _loadLogo() async {
    try {
      final byteData = await rootBundle.load('assets/logo.png');
      setState(() {
        _logoBytes = byteData.buffer.asUint8List();
        _isLoadingLogo = false;
      });
    } catch (e) {
      setState(() {
        _logoBytes = Uint8List(0);
        _isLoadingLogo = false;
      });
    }
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
      if (_isLoadingLogo) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Logo is still loading')));
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final file = await PdfService.generateQuotePdf(
        pricing: widget.pricing,
        customerName: widget.customerName,
        customerMobile: widget.customerMobile,
        customerEmail: widget.customerEmail,
        projectName: widget.projectName,
        renderSQM: widget.renderSQM,
        hebelSQM: widget.hebelSQM,
        acrylicSQM: widget.acrylicSQM,
        foamSQM: widget.foamSQM,
        labourHours: widget.labourHours,
        traderHours: widget.traderHours,
        quoins: widget.quoins,
        bulkheads: widget.bulkheads,
        plynth: widget.plynth,
        columns: widget.columns,
        windowBands: widget.windowBands,
        termsText: _termsController.text,
        managerName: _managerController.text,
        date: _dateController.text,
        includeTerms: _includeTerms,
        includeScope: _includeScope,
        logoBytes: _logoBytes,
      );

      if (mounted) Navigator.pop(context);

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => file.readAsBytes(),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _exportToEmail() async {
    try {
      if (_isLoadingLogo) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Logo is still loading')));
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      final file = await PdfService.generateQuotePdf(
        pricing: widget.pricing,
        customerName: widget.customerName,
        customerMobile: widget.customerMobile,
        customerEmail: widget.customerEmail,
        projectName: widget.projectName,
        renderSQM: widget.renderSQM,
        hebelSQM: widget.hebelSQM,
        acrylicSQM: widget.acrylicSQM,
        foamSQM: widget.foamSQM,
        labourHours: widget.labourHours,
        traderHours: widget.traderHours,
        quoins: widget.quoins,
        bulkheads: widget.bulkheads,
        plynth: widget.plynth,
        columns: widget.columns,
        windowBands: widget.windowBands,
        termsText: _termsController.text,
        managerName: _managerController.text,
        date: _dateController.text,
        includeTerms: _includeTerms,
        includeScope: _includeScope,
        logoBytes: _logoBytes,
      );

      if (mounted) Navigator.pop(context);

      await PdfService.sendEmailWithPdf(
        pdfFile: file,
        customerName: widget.customerName,
        customerEmail: widget.customerEmail,
        projectName: widget.projectName,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quote sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
              _buildHeaderSection(),
              const SizedBox(height: 16),

              // Toggle Section
              _buildToggleSection(isMobile),
              const SizedBox(height: 16),

              _buildQuoteSummaryCard(),
              const SizedBox(height: 16),

              _buildMaterialBreakdownCard(isMobile),
              const SizedBox(height: 16),

              if (_includeScope) _buildScopeOfWorkCard(),
              if (_includeScope) const SizedBox(height: 16),

              if (_includeTerms) _buildTermsConditionsCard(),
              if (_includeTerms) const SizedBox(height: 16),

              if (_includeTerms) _buildManagerApprovalCard(),
              if (_includeTerms) const SizedBox(height: 16),

              _buildActionButtons(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
        return QuotePage(pricing: pricing);
      case 1:
        return PricingScreen(pricing: pricing);
      case 2:
        return LabourCalculationScreen(pricing: pricing);
      case 3:
        return const ProfileScreen();
      default:
        return QuotePage(pricing: pricing);
    }
  }

  Widget _buildToggleSection(bool isMobile) {
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
            'PDF Sections',
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
                child: _buildToggleOption(
                  'Include Terms & Conditions',
                  _includeTerms,
                  (value) => setState(() => _includeTerms = value),
                ),
              ),
              if (!isMobile) const SizedBox(width: 20),
              Expanded(
                child: _buildToggleOption(
                  'Include Scope of Work',
                  _includeScope,
                  (value) => setState(() => _includeScope = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(val!),
          checkColor: Colors.white,
          activeColor: const Color(0xFFFB3B3B),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(label, style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
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
                    child: Text(
                      'ID${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
                      style: const TextStyle(
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

  Widget _buildMaterialBreakdownCard(bool isMobile) {
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
              columnWidths: _getColumnWidths(isMobile),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table header
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFF98353F)),
                  children: [
                    _buildTableHeader('Sr.'),
                    _buildTableHeader('Substrate'),
                    _buildTableHeader('Material'),
                    _buildTableHeader('Qty'),
                    _buildTableHeader('Unit \$'),
                    _buildTableHeader('Total'),
                    _buildTableHeader('SQM'),
                  ],
                ),
                // Data rows
                _buildMaterialRow(
                  '1',
                  'Sand & Cement',
                  'Sand (T)',
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
                  'Win. Bands',
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

  Map<int, TableColumnWidth> _getColumnWidths(bool isMobile) {
    if (isMobile) {
      return {
        0: const FixedColumnWidth(32),
        1: const FixedColumnWidth(70),
        2: const FixedColumnWidth(70),
        3: const FixedColumnWidth(50),
        4: const FixedColumnWidth(60),
        5: const FixedColumnWidth(60),
        6: const FixedColumnWidth(40),
      };
    } else {
      return {
        0: const FixedColumnWidth(40),
        1: const FixedColumnWidth(100),
        2: const FixedColumnWidth(100),
        3: const FixedColumnWidth(70),
        4: const FixedColumnWidth(80),
        5: const FixedColumnWidth(80),
        6: const FixedColumnWidth(50),
      };
    }
  }

  Widget _buildScopeOfWorkCard() {
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
            'Scope of Work',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScopeItem(
                'Render application: ${_formatNumber(widget.renderSQM)} m²',
              ),
              _buildScopeItem(
                'Hebel application: ${_formatNumber(widget.hebelSQM)} m²',
              ),
              _buildScopeItem(
                'Acrylic finish: ${_formatNumber(widget.acrylicSQM)} m²',
              ),
              _buildScopeItem(
                'Foam application: ${_formatNumber(widget.foamSQM)} m²',
              ),
              if (widget.quoins > 0)
                _buildScopeItem('Quoins: ${widget.quoins} pieces'),
              if (widget.bulkheads > 0)
                _buildScopeItem('Bulkheads: ${widget.bulkheads} LM'),
              if (widget.plynth > 0)
                _buildScopeItem('Plinths: ${widget.plynth} LM'),
              if (widget.columns > 0)
                _buildScopeItem('Columns: ${widget.columns} items'),
              if (widget.windowBands > 0)
                _buildScopeItem('Window bands: ${widget.windowBands} items'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScopeItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white)),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
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
          onPressed: _exportToEmail,
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
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
