import 'package:flutter/material.dart';
import 'global_pricing.dart';
import 'quote_screen.dart'; // Make sure to import your actual screens
import 'pricing_screen.dart';
import 'profile_screen.dart';

class LabourCalculationScreen extends StatefulWidget {
  final GlobalPricing pricing;
  const LabourCalculationScreen({super.key, required this.pricing});

  @override
  State<LabourCalculationScreen> createState() =>
      _LabourCalculationScreenState();
}

class _LabourCalculationScreenState extends State<LabourCalculationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final List<TextEditingController> _controllers;
  int _currentIndex = 2; // Labour screen is index 2

  @override
  void initState() {
    super.initState();
    _controllers = [
      TextEditingController(text: widget.pricing.labourHourlyRate.toString()),
      TextEditingController(text: widget.pricing.traderHourlyRate.toString()),
      TextEditingController(text: widget.pricing.minLabourCost.toString()),
      TextEditingController(text: widget.pricing.minTraderCost.toString()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Labour Rules')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Labour Rates
              _buildSectionHeader('Hourly Rates'),
              _buildLabourInput('Labour Rate (\$/hr)', _controllers[0], (v) {
                widget.pricing.labourHourlyRate =
                    double.tryParse(v) ?? widget.pricing.labourHourlyRate;
              }),
              _buildLabourInput('Trader Rate (\$/hr)', _controllers[1], (v) {
                widget.pricing.traderHourlyRate =
                    double.tryParse(v) ?? widget.pricing.traderHourlyRate;
              }),

              // Minimum Costs
              _buildSectionHeader('Minimum Job Costs'),
              _buildLabourInput('Minimum Labour Cost', _controllers[2], (v) {
                widget.pricing.minLabourCost =
                    double.tryParse(v) ?? widget.pricing.minLabourCost;
              }),
              _buildLabourInput('Minimum Trader Cost', _controllers[3], (v) {
                widget.pricing.minTraderCost =
                    double.tryParse(v) ?? widget.pricing.minTraderCost;
              }),

              // Rules Explanation
              _buildSectionHeader('Calculation Rules'),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Labour Cost Formula:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('MAX(Hours × Rate, Minimum Cost)'),
                      SizedBox(height: 16),
                      Text(
                        'Estimated Days Formula:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '(Profit / 240) / 7\n(2 trades @ \$85 + 1 labourer @ \$70 = \$240/hr)',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAndFinish,
                child: const Text('Save All Pricing'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Added navigation method
  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return QuotePage(pricing: widget.pricing);
      case 1:
        return PricingScreen(pricing: widget.pricing);
      case 2:
        return LabourCalculationScreen(pricing: widget.pricing);
      case 3:
        return const ProfileScreen();
      default:
        return QuotePage(pricing: widget.pricing);
    }
  }

  // Your original methods remain unchanged
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLabourInput(
    String label,
    TextEditingController controller,
    Function(String) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: onChanged,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(prefixText: '\$ '),
            ),
          ),
        ],
      ),
    );
  }

  void _saveAndFinish() {
    if (_formKey.currentState!.validate()) {
      widget.pricing.updateLabourRates(
        labour: double.tryParse(_controllers[0].text),
        trader: double.tryParse(_controllers[1].text),
        minLabour: double.tryParse(_controllers[2].text),
        minTrader: double.tryParse(_controllers[3].text),
      );
      Navigator.pop(context);
    }
  }
}

// Your original _buildInputRow function remains unchanged
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
