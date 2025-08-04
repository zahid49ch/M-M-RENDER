import 'package:flutter/material.dart';
import 'material_breakdown_screen.dart';
import 'global_pricing.dart';

class ExtraSectionPrices extends StatefulWidget {
  final GlobalPricing pricing;
  final double renderSQM;
  final double hebelSQM;
  final double acrylicSQM;
  final double foamSQM;
  final double labourHours;
  final double traderHours;
  final String customerName;
  final String projectName;

  const ExtraSectionPrices({
    super.key,
    required this.pricing,
    required this.renderSQM,
    required this.hebelSQM,
    required this.acrylicSQM,
    required this.foamSQM,
    required this.labourHours,
    required this.traderHours,
    required this.customerName,
    required this.projectName,
  });

  @override
  State<ExtraSectionPrices> createState() => _ExtraSectionPricesState();
}

class _ExtraSectionPricesState extends State<ExtraSectionPrices> {
  final TextEditingController _quoinsController = TextEditingController();
  final TextEditingController _bandsController = TextEditingController();
  final TextEditingController _bulkheadsController = TextEditingController();
  final TextEditingController _pillarsController = TextEditingController();
  final TextEditingController _fenceTopController = TextEditingController();
  final TextEditingController _fenceMinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'M & M RENDER',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF550101),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'M & M RENDER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 35,
                        color: const Color(0xFFFB3B3B),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Back',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Text(
                    'Extra Section Prices',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const Divider(color: Colors.white, height: 20),

              // Customer and project info
              Text('Customer: ${widget.customerName}'),
              Text('Project: ${widget.projectName}'),
              const SizedBox(height: 16),

              // Area summaries
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Render SQM: ${widget.renderSQM.toStringAsFixed(2)}',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Hebel SQM: ${widget.hebelSQM.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Acrylic SQM: ${widget.acrylicSQM.toStringAsFixed(2)}',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Foam SQM: ${widget.foamSQM.toStringAsFixed(2)}',
                    ),
                  ),
                ],
              ),
              // NEW: Labour hours display
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Labour Hours: ${widget.labourHours.toStringAsFixed(1)}',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Trader Hours: ${widget.traderHours.toStringAsFixed(1)}',
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white, height: 24),

              // Extra features inputs
              _buildInputRow(
                'Quoins : Per piece',
                widget.pricing.quoinsPerPiece,
                (value) =>
                    widget.pricing.updateExtraSectionPrices(quoins: value),
              ),
              const SizedBox(height: 16),

              _buildInputRow(
                'Bands/Plinths - Per LM',
                widget.pricing.bandsPlinthsPerLM,
                (value) =>
                    widget.pricing.updateExtraSectionPrices(bands: value),
              ),
              const SizedBox(height: 16),

              _buildInputRow(
                'Bulk Head - Per LM',
                widget.pricing.bulkHeadPerLM,
                (value) =>
                    widget.pricing.updateExtraSectionPrices(bulkHead: value),
              ),
              const SizedBox(height: 16),

              _buildInputRow(
                'Pillars - Per Item',
                widget.pricing.pillarsPerItem,
                (value) =>
                    widget.pricing.updateExtraSectionPrices(pillars: value),
              ),
              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Fence Panel Min or LM for Top',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildLabeledInput(
                      'LM for Top',
                      widget.pricing.fenceTopLM,
                      (value) => widget.pricing.updateExtraSectionPrices(
                        fenceTop: value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLabeledInput(
                      'Min',
                      widget.pricing.fenceMin,
                      (value) => widget.pricing.updateExtraSectionPrices(
                        fenceMin: value,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MaterialBreakdownScreen(
                          pricing: widget.pricing,
                          customerName: widget.customerName,
                          projectName: widget.projectName,
                          renderSQM: widget.renderSQM,
                          hebelSQM: widget.hebelSQM,
                          acrylicSQM: widget.acrylicSQM,
                          foamSQM: widget.foamSQM,
                          labourHours: widget.labourHours,
                          traderHours: widget.traderHours,
                          quoins: int.tryParse(_quoinsController.text) ?? 0,
                          bulkheads:
                              int.tryParse(_bulkheadsController.text) ?? 0,
                          plynth: int.tryParse(_bandsController.text) ?? 0,
                          columns: int.tryParse(_pillarsController.text) ?? 0,
                          windowBands: 0, // Placeholder
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFFB3B3B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'NEXT : Get Material Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: TextEditingController(text: value),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF550101),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInput(
    String label,
    String value,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF550101),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}
