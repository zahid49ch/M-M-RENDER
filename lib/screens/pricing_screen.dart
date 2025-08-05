import 'package:flutter/material.dart';
import 'global_pricing.dart';
import 'labour_calculation_screen.dart';
import 'quote_screen.dart'; // Make sure to import these
import 'profile_screen.dart'; // Make sure to import these

class PricingScreen extends StatefulWidget {
  final GlobalPricing pricing;
  const PricingScreen({super.key, required this.pricing});

  @override
  State<PricingScreen> createState() => _PricingScreenState();
}

class _PricingScreenState extends State<PricingScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 1; // Pricing screen is index 1

  // Controllers for all pricing fields
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      // Material prices
      TextEditingController(text: widget.pricing.pricePerSqm.toString()),
      TextEditingController(text: widget.pricing.brickPrice.toString()),
      TextEditingController(text: widget.pricing.foamPrice.toString()),
      TextEditingController(text: widget.pricing.hebalPrice.toString()),
      TextEditingController(text: widget.pricing.cementSandPrice.toString()),

      // Preparation & bulkhead
      TextEditingController(text: widget.pricing.coverTrapePerSqm.toString()),
      TextEditingController(text: widget.pricing.plasticPerRoll.toString()),
      TextEditingController(text: widget.pricing.windowPerItem.toString()),
      TextEditingController(text: widget.pricing.prepPillarsPerItem.toString()),
      TextEditingController(
        text: widget.pricing.expansionJointsPerItem.toString(),
      ),
      TextEditingController(text: widget.pricing.cornerBeadPer3m.toString()),
      TextEditingController(text: widget.pricing.sprayGluePerCan.toString()),

      // Profit
      TextEditingController(text: widget.pricing.profitPercentage.toString()),
    ];
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pricing Configuration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Material Prices Section
              _buildSectionHeader('Material Prices (per m²)'),
              _buildPriceInput('Render Base Price', _controllers[0], (v) {
                widget.pricing.pricePerSqm =
                    double.tryParse(v) ?? widget.pricing.pricePerSqm;
              }),
              _buildPriceInput('Brick (Acrylic)', _controllers[1], (v) {
                widget.pricing.brickPrice =
                    double.tryParse(v) ?? widget.pricing.brickPrice;
              }),
              _buildPriceInput('Foam', _controllers[2], (v) {
                widget.pricing.foamPrice =
                    double.tryParse(v) ?? widget.pricing.foamPrice;
              }),
              _buildPriceInput('Hebel', _controllers[3], (v) {
                widget.pricing.hebalPrice =
                    double.tryParse(v) ?? widget.pricing.hebalPrice;
              }),
              _buildPriceInput('Cement & Sand', _controllers[4], (v) {
                widget.pricing.cementSandPrice =
                    double.tryParse(v) ?? widget.pricing.cementSandPrice;
              }),

              // Preparation & Bulkhead Section
              _buildSectionHeader('Preparation & Bulkhead'),
              _buildPriceInput('Cover Trape/m²', _controllers[5], (v) {
                widget.pricing.coverTrapePerSqm =
                    double.tryParse(v) ?? widget.pricing.coverTrapePerSqm;
              }),
              _buildPriceInput('Plastic per Roll', _controllers[6], (v) {
                widget.pricing.plasticPerRoll =
                    double.tryParse(v) ?? widget.pricing.plasticPerRoll;
              }),
              _buildPriceInput('Window per Item', _controllers[7], (v) {
                widget.pricing.windowPerItem =
                    double.tryParse(v) ?? widget.pricing.windowPerItem;
              }),
              _buildPriceInput('Pillars per Item', _controllers[8], (v) {
                widget.pricing.prepPillarsPerItem =
                    double.tryParse(v) ?? widget.pricing.prepPillarsPerItem;
              }),
              _buildPriceInput('Expansion Joints', _controllers[9], (v) {
                widget.pricing.expansionJointsPerItem =
                    double.tryParse(v) ?? widget.pricing.expansionJointsPerItem;
              }),
              _buildPriceInput('Corner Bead per 3m', _controllers[10], (v) {
                widget.pricing.cornerBeadPer3m =
                    double.tryParse(v) ?? widget.pricing.cornerBeadPer3m;
              }),
              _buildPriceInput('Spray Glue per Can', _controllers[11], (v) {
                widget.pricing.sprayGluePerCan =
                    double.tryParse(v) ?? widget.pricing.sprayGluePerCan;
              }),

              // Profit
              _buildSectionHeader('Profit'),
              _buildPriceInput('Profit Percentage', _controllers[12], (v) {
                widget.pricing.profitPercentage =
                    double.tryParse(v) ?? widget.pricing.profitPercentage;
              }, isPercentage: true),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveAndContinue,
                child: const Text('Continue to Labour Rules'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => _getScreenForIndex(index),
              ),
            );
          }
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPriceInput(
    String label,
    TextEditingController controller,
    Function(String) onChanged, {
    bool isPercentage = false,
  }) {
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
              decoration: InputDecoration(
                prefixText: '\$ ',
                suffix: isPercentage ? const Text('%') : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveAndContinue() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LabourCalculationScreen(pricing: widget.pricing),
        ),
      );
    }
  }
}
