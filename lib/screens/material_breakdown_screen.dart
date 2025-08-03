import 'package:flutter/material.dart';
import 'global_pricing.dart';

class MaterialBreakdownScreen extends StatefulWidget {
  final GlobalPricing pricing;
  final String customerName;
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
  late TextEditingController _profitPercentageController;
  double profitPercentage = 20.0; // Default profit percentage

  @override
  void initState() {
    super.initState();
    _profitPercentageController = TextEditingController(
      text: profitPercentage.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _profitPercentageController.dispose();
    super.dispose();
  }

  // Helper method to format currency as AUD
  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }

  // Helper method to format numbers
  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate material quantities and costs
    double sandTonnes = widget.renderSQM / 35;
    double cementBags = sandTonnes * 10;
    double frBags = widget.hebelSQM / 6;
    double p400Bags = widget.foamSQM / 6;
    double acrylicBags = widget.acrylicSQM / 3;

    // Labour cost calculation
    double labourRate = double.tryParse(widget.pricing.labourHourlyRate) ?? 0.0;
    double traderRate = double.tryParse(widget.pricing.traderHourlyRate) ?? 0.0;
    double minLabour = double.tryParse(widget.pricing.minLabourCost) ?? 0.0;
    double minTrader = double.tryParse(widget.pricing.minTraderCost) ?? 0.0;

    double labourCost = widget.labourHours * labourRate;
    if (labourCost < minLabour) labourCost = minLabour;

    double traderCost = widget.traderHours * traderRate;
    if (traderCost < minTrader) traderCost = minTrader;

    double totalLabourCost = labourCost + traderCost;

    // Calculate costs using pricing instance
    double sandCost = 0; // Not defined in pricing
    double cementCost = 0; // Not defined in pricing
    double frBagsCost = frBags * widget.pricing.hebalPrice;
    double p400BagsCost = p400Bags * widget.pricing.foamPrice;
    double acrabatchCost = 0; // Not defined in pricing
    double acrylicBagsCost = acrylicBags * widget.pricing.brickPrice;
    double textureCost = 0; // Not defined in pricing

    // Calculate extra features costs
    double quoinsCost =
        widget.quoins * double.parse(widget.pricing.quoinsPerPiece);
    double bulkheadsCost =
        widget.bulkheads * double.parse(widget.pricing.bulkHeadPerLM);
    double plynthCost =
        widget.plynth * double.parse(widget.pricing.bandsPlinthsPerLM);
    double columnsCost =
        widget.columns * double.parse(widget.pricing.pillarsPerItem);
    double windowBandsCost =
        widget.windowBands * double.parse(widget.pricing.windowPerItem);

    double totalMaterialCost =
        sandCost +
        cementCost +
        frBagsCost +
        p400BagsCost +
        acrabatchCost +
        acrylicBagsCost +
        textureCost +
        quoinsCost +
        bulkheadsCost +
        plynthCost +
        columnsCost +
        windowBandsCost;

    double baseCost = totalMaterialCost + totalLabourCost;

    // Calculate profit based on percentage
    double profitAmount = baseCost * (profitPercentage / 100);

    // GST calculation (10% in Australia)
    double gst = (baseCost + profitAmount) * 0.10;

    double totalJobCost = baseCost + profitAmount + gst;

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'M & M RENDER',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Customer: ${widget.customerName}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Project: ${widget.projectName}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quote Summary Card
              Container(
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

                    // Job ID and Customer
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

                    // NEW: Profit percentage input
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Profit Percentage:',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: _profitPercentageController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF731112),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: const BorderSide(
                                  color: Color(0xFFFB3B3B),
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                            ),
                            onChanged: (value) {
                              final percentage = double.tryParse(value);
                              if (percentage != null && percentage >= 0) {
                                setState(() {
                                  profitPercentage = percentage;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('%', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Summary Rows
                    _buildSummaryRow(
                      'Job Price (Inc. GST):',
                      _formatCurrency(totalJobCost),
                    ),
                    _buildSummaryRow(
                      'Material Cost:',
                      _formatCurrency(totalMaterialCost),
                    ),
                    _buildSummaryRow(
                      'Labour Cost:',
                      _formatCurrency(totalLabourCost),
                    ),
                    _buildSummaryRow(
                      'Labour Hours:',
                      '${widget.labourHours.toStringAsFixed(1)} hrs',
                    ),
                    _buildSummaryRow(
                      'Trader Hours:',
                      '${widget.traderHours.toStringAsFixed(1)} hrs',
                    ),
                    _buildSummaryRow(
                      'Total SQM:',
                      _formatNumber(
                        widget.renderSQM +
                            widget.hebelSQM +
                            widget.acrylicSQM +
                            widget.foamSQM,
                      ),
                    ),
                    _buildSummaryRow(
                      'Profit (Exc. GST):',
                      _formatCurrency(profitAmount),
                    ),
                    _buildSummaryRow('GST:', _formatCurrency(gst)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Material Breakdown Card
              Container(
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

                    // Material Table
                    Table(
                      border: TableBorder.all(color: const Color(0xFFFB3B3B)),
                      columnWidths: const {
                        0: FlexColumnWidth(0.5),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1.5),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1),
                      },
                      children: [
                        // Header
                        TableRow(
                          decoration: const BoxDecoration(
                            color: Color(0xFF98353F),
                          ),
                          children: [
                            _buildTableHeader('Sr. No.'),
                            _buildTableHeader('Substrate'),
                            _buildTableHeader('Material'),
                            _buildTableHeader('Quantity'),
                            _buildTableHeader('Unit Price'),
                            _buildTableHeader('Total'),
                            _buildTableHeader('SQM'),
                          ],
                        ),

                        // Sand & Cement - Sand
                        _buildMaterialRow(
                          '1',
                          'Sand & Cement',
                          'Sand (Tonnes)',
                          sandTonnes,
                          0, // Placeholder price
                          sandCost,
                          widget.renderSQM,
                        ),

                        // Sand & Cement - Cement
                        _buildMaterialRow(
                          '2',
                          'Sand & Cement',
                          'Cement (Bags)',
                          cementBags,
                          0, // Placeholder price
                          cementCost,
                          widget.renderSQM,
                        ),

                        // Hebel
                        _buildMaterialRow(
                          '3',
                          'Hebel',
                          'FR Bags',
                          frBags,
                          widget.pricing.hebalPrice,
                          frBagsCost,
                          widget.hebelSQM,
                        ),

                        // Foam
                        _buildMaterialRow(
                          '4',
                          'Foam',
                          'P400 Bags',
                          p400Bags,
                          widget.pricing.foamPrice,
                          p400BagsCost,
                          widget.foamSQM,
                        ),

                        // Bulkhead
                        _buildMaterialRow(
                          '5',
                          'Bulkhead',
                          'Acrabatch (Buckets)',
                          1, // Placeholder quantity
                          0, // Placeholder price
                          acrabatchCost,
                          0, // Placeholder SQM
                        ),

                        // Acrylic
                        _buildMaterialRow(
                          '6',
                          'Acrylic',
                          'Acrylic Bags',
                          acrylicBags,
                          widget.pricing.brickPrice,
                          acrylicBagsCost,
                          widget.acrylicSQM,
                        ),

                        // All Areas
                        _buildMaterialRow(
                          '7',
                          'All Areas',
                          'Texture',
                          1, // Placeholder quantity
                          0, // Placeholder price
                          textureCost,
                          0, // Placeholder SQM
                        ),
                      ],
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
              ),
              const SizedBox(height: 16),

              // Action Buttons
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'PDF generation functionality coming soon!',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF550101),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Color(0xFFFB3B3B)),
                ),
                child: const Text(
                  'Generate Quote PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildMaterialRow(
    String srNo,
    String substrate,
    String material,
    double quantity,
    double unitPrice,
    double total,
    double sqm,
  ) {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFF550101)),
      children: [
        _buildTableCell(srNo),
        _buildTableCell(substrate),
        _buildTableCell(material),
        _buildTableCell(_formatNumber(quantity)),
        _buildTableCell(_formatCurrency(unitPrice)),
        _buildTableCell(_formatCurrency(total)),
        _buildTableCell(_formatNumber(sqm)),
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
