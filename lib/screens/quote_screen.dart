import 'package:flutter/material.dart';
import 'pricing_screen.dart';
import '../widgets/section_card.dart';
import '../widgets/input_field.dart';
import 'extra_features_screen.dart';
import 'global_pricing.dart';

class QuotePage extends StatefulWidget {
  final GlobalPricing pricing;
  const QuotePage({super.key, required this.pricing});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  final TextEditingController _renderSqmController = TextEditingController();
  final TextEditingController _hebelSqmController = TextEditingController();
  final TextEditingController _acrylicSqmController = TextEditingController();
  final TextEditingController _foamSqmController = TextEditingController();
  final TextEditingController _labourHoursController = TextEditingController();
  final TextEditingController _traderHoursController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Welcome, user!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    side: const BorderSide(color: Color(0xFFFB3B3B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    // Clear all fields for new quote
                    setState(() {
                      _customerNameController.clear();
                      _projectController.clear();
                      _emailController.clear();
                      _phoneController.clear();
                      _renderSqmController.clear();
                      _hebelSqmController.clear();
                      _acrylicSqmController.clear();
                      _foamSqmController.clear();
                      _labourHoursController.clear();
                      _traderHoursController.clear();
                    });
                  },
                  child: const Text(
                    'New Quote',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    side: const BorderSide(color: Color(0xFFFB3B3B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PricingPage(pricing: widget.pricing),
                      ),
                    );
                  },
                  child: const Text(
                    'Update Prices',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SectionCard(
            title: 'Customer Details',
            children: [
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      placeholder: 'Enter Your Name',
                      controller: _customerNameController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InputField(
                      placeholder: 'Enter Project',
                      controller: _projectController,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      placeholder: 'Enter Your Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InputField(
                      placeholder: 'Enter Your Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SectionCard(
            title: 'Quote Items',
            children: [
              InputField(
                placeholder: 'Render SQM',
                controller: _renderSqmController,
                keyboardType: TextInputType.number,
              ),
              InputField(
                placeholder: 'Hebel SQM',
                controller: _hebelSqmController,
                keyboardType: TextInputType.number,
              ),
              InputField(
                placeholder: 'Acrylic SQM',
                controller: _acrylicSqmController,
                keyboardType: TextInputType.number,
              ),
              InputField(
                placeholder: 'Foam SQM',
                controller: _foamSqmController,
                keyboardType: TextInputType.number,
              ),
              // NEW: Labour hours inputs
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      placeholder: 'Labour Hours',
                      controller: _labourHoursController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InputField(
                      placeholder: 'Trader Hours',
                      controller: _traderHoursController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF550101),
              side: const BorderSide(color: Color(0xFFFB3B3B)),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              // Validate inputs before showing breakdown
              if (_customerNameController.text.isEmpty ||
                  _projectController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter customer and project details'),
                  ),
                );
                return;
              }

              final renderSQM = double.tryParse(_renderSqmController.text) ?? 0;
              final hebelSQM = double.tryParse(_hebelSqmController.text) ?? 0;
              final acrylicSQM =
                  double.tryParse(_acrylicSqmController.text) ?? 0;
              final foamSQM = double.tryParse(_foamSqmController.text) ?? 0;
              final labourHours =
                  double.tryParse(_labourHoursController.text) ?? 0;
              final traderHours =
                  double.tryParse(_traderHoursController.text) ?? 0;

              if (renderSQM <= 0 &&
                  hebelSQM <= 0 &&
                  acrylicSQM <= 0 &&
                  foamSQM <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter at least one area value'),
                  ),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExtraSectionPrices(
                    pricing: widget.pricing,
                    renderSQM: renderSQM,
                    hebelSQM: hebelSQM,
                    acrylicSQM: acrylicSQM,
                    foamSQM: foamSQM,
                    labourHours: labourHours,
                    traderHours: traderHours,
                    customerName: _customerNameController.text,
                    projectName: _projectController.text,
                  ),
                ),
              );
            },
            child: const Text(
              'Next: Extra Features',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _renderSqmController.dispose();
    _hebelSqmController.dispose();
    _acrylicSqmController.dispose();
    _foamSqmController.dispose();
    _labourHoursController.dispose();
    _traderHoursController.dispose();
    _customerNameController.dispose();
    _projectController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
