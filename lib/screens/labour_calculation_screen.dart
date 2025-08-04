import 'package:flutter/material.dart';
import 'global_pricing.dart';

class LabourCalculationScreen extends StatefulWidget {
  final GlobalPricing pricing;
  const LabourCalculationScreen({super.key, required this.pricing});

  @override
  State<LabourCalculationScreen> createState() => _LabourCalculationScreenState();
}

class _LabourCalculationScreenState extends State<LabourCalculationScreen> {
  late TextEditingController _labourController;
  late TextEditingController _traderController;
  late TextEditingController _minLabourController;
  late TextEditingController _minTraderController;

  @override
  void initState() {
    super.initState();
    _labourController = TextEditingController(text: widget.pricing.labourHourlyRate);
    _traderController = TextEditingController(text: widget.pricing.traderHourlyRate);
    _minLabourController = TextEditingController(text: widget.pricing.minLabourCost);
    _minTraderController = TextEditingController(text: widget.pricing.minTraderCost);
  }

  @override
  void dispose() {
    _labourController.dispose();
    _traderController.dispose();
    _minLabourController.dispose();
    _minTraderController.dispose();
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
                    'Labour Calculation & Rules',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const Divider(color: Colors.white, height: 24),

              // Labour Rate Inputs
              _buildInputRow(
                'Labour Hourly Rate (\$/hr)',
                _labourController,
                (value) => widget.pricing.labourHourlyRate = value,
              ),
              const SizedBox(height: 16),

              _buildInputRow(
                'Trader Labour Hourly Rate (\$/hr)',
                _traderController,
                (value) => widget.pricing.traderHourlyRate = value,
              ),
              const SizedBox(height: 20),

              // Minimum Cost Rules
              const Center(
                child: Text(
                  'Minimum Cost Rules',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              _buildInputRow(
                'Minimum Labour Cost',
                _minLabourController,
                (value) => widget.pricing.minLabourCost = value,
              ),
              const SizedBox(height: 16),

              _buildInputRow(
                'Minimum Trader Labour Cost',
                _minTraderController,
                (value) => widget.pricing.minTraderCost = value,
              ),
              const SizedBox(height: 24),

              // Info Text
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Note: These rates will be used to calculate labour costs for quotes. Minimum costs ensure small jobs remain profitable.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'SAVE LABOUR RATES',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF550101),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              prefixText: '\$ ',
              prefixStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}