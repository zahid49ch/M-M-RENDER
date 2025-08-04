import 'package:flutter/material.dart';
import 'global_pricing.dart';
import 'labour_calculation_screen.dart';

class PreparationBulkheadPrices extends StatefulWidget {
  final GlobalPricing pricing;
  const PreparationBulkheadPrices({super.key, required this.pricing});

  @override
  State<PreparationBulkheadPrices> createState() => _PreparationBulkheadPricesState();
}

class _PreparationBulkheadPricesState extends State<PreparationBulkheadPrices> {
  late TextEditingController _coverTrapeController;
  late TextEditingController _plasticController;
  late TextEditingController _windowController;
  late TextEditingController _pillarsController;
  late TextEditingController _expansionController;
  late TextEditingController _cornerBeadController;
  late TextEditingController _sprayGlueController;

  @override
  void initState() {
    super.initState();
    _coverTrapeController = TextEditingController(text: widget.pricing.coverTrapePerSqm.toString());
    _plasticController = TextEditingController(text: widget.pricing.plasticPerRoll.toString());
    _windowController = TextEditingController(text: widget.pricing.windowPerItem.toString());
    _pillarsController = TextEditingController(text: widget.pricing.prepPillarsPerItem.toString());
    _expansionController = TextEditingController(text: widget.pricing.expansionJointsPerItem.toString());
    _cornerBeadController = TextEditingController(text: widget.pricing.cornerBeadPer3m.toString());
    _sprayGlueController = TextEditingController(text: widget.pricing.sprayGluePerCan.toString());
  }

  @override
  void dispose() {
    _coverTrapeController.dispose();
    _plasticController.dispose();
    _windowController.dispose();
    _pillarsController.dispose();
    _expansionController.dispose();
    _cornerBeadController.dispose();
    _sprayGlueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF731112),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Material(
          color: const Color(0xFF731112),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'M & M RENDER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Back Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 25),
                        SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'Preparation & Bulkhead Prices',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const Divider(color: Colors.white, height: 24),

              // Input Sections
              _buildInputRow(
                'Cover Trape, caulking, window Protection & Plastic: Per m²',
                _coverTrapeController,
                (value) => widget.pricing.coverTrapePerSqm = double.tryParse(value) ?? widget.pricing.coverTrapePerSqm,
              ),
              _buildInputRow(
                'Plastic - Per Roll (50LM)',
                _plasticController,
                (value) => widget.pricing.plasticPerRoll = double.tryParse(value) ?? widget.pricing.plasticPerRoll,
              ),
              _buildInputRow(
                'Window - Per Item',
                _windowController,
                (value) => widget.pricing.windowPerItem = double.tryParse(value) ?? widget.pricing.windowPerItem,
              ),
              _buildInputRow(
                'Pillars - Per Item',
                _pillarsController,
                (value) => widget.pricing.prepPillarsPerItem = double.tryParse(value) ?? widget.pricing.prepPillarsPerItem,
              ),
              _buildInputRow(
                'Expansion Joints - Per Item',
                _expansionController,
                (value) => widget.pricing.expansionJointsPerItem = double.tryParse(value) ?? widget.pricing.expansionJointsPerItem,
              ),
              
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Bulk head-Corner Bead per 3m',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Corner Bead and Spray Glue inputs
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledInput(
                      'Each per 3m',
                      _cornerBeadController,
                      (value) => widget.pricing.cornerBeadPer3m = double.tryParse(value) ?? widget.pricing.cornerBeadPer3m,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLabeledInput(
                      'Spray Glue per Can(covers 30LM)',
                      _sprayGlueController,
                      (value) => widget.pricing.sprayGluePerCan = double.tryParse(value) ?? widget.pricing.sprayGluePerCan,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Next Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LabourCalculationScreen(pricing: widget.pricing),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'NEXT: Labour Calculation & Rules',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
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
            child: Material(
              color: const Color(0xFF550101),
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledInput(
    String label,
    TextEditingController controller,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Material(
          color: const Color(0xFF550101),
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}