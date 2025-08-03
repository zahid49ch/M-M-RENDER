import 'package:flutter/material.dart';
import 'global_pricing.dart';

class PricingPage extends StatefulWidget {
  final GlobalPricing pricing;
  const PricingPage({super.key, required this.pricing});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  late TextEditingController _pricePerSqmController;
  late TextEditingController _brickPriceController;
  late TextEditingController _foamPriceController;
  late TextEditingController _hebalPriceController;
  late TextEditingController _cementSandPriceController;

  @override
  void initState() {
    super.initState();
    _pricePerSqmController = TextEditingController(
      text: widget.pricing.pricePerSqm.toString(),
    );
    _brickPriceController = TextEditingController(
      text: widget.pricing.brickPrice.toString(),
    );
    _foamPriceController = TextEditingController(
      text: widget.pricing.foamPrice.toString(),
    );
    _hebalPriceController = TextEditingController(
      text: widget.pricing.hebalPrice.toString(),
    );
    _cementSandPriceController = TextEditingController(
      text: widget.pricing.cementSandPrice.toString(),
    );
  }

  @override
  void dispose() {
    _pricePerSqmController.dispose();
    _brickPriceController.dispose();
    _foamPriceController.dispose();
    _hebalPriceController.dispose();
    _cementSandPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF731112),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Material(
          // ADDED MATERIAL WIDGET HERE
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
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
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

                  // Title
                  const Text(
                    'RENDER & Substrate Prices',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const Divider(color: Colors.white, height: 24),

              // Price Inputs
              _buildPriceRow(
                label: 'Price/m² or \$/m²',
                controller: _pricePerSqmController,
                onChanged: (value) {
                  widget.pricing.pricePerSqm =
                      double.tryParse(value) ?? widget.pricing.pricePerSqm;
                },
              ),

              _buildPriceRow(
                label: 'Brick (Acrylic) - 1bag/3m²',
                controller: _brickPriceController,
                onChanged: (value) {
                  widget.pricing.brickPrice =
                      double.tryParse(value) ?? widget.pricing.brickPrice;
                },
              ),

              _buildPriceRow(
                label: 'Foam - 1bag/6m² = Price/m²',
                controller: _foamPriceController,
                onChanged: (value) {
                  widget.pricing.foamPrice =
                      double.tryParse(value) ?? widget.pricing.foamPrice;
                },
              ),

              _buildPriceRow(
                label: 'Hebal - 1bag/6m² = Price/m²',
                controller: _hebalPriceController,
                onChanged: (value) {
                  widget.pricing.hebalPrice =
                      double.tryParse(value) ?? widget.pricing.hebalPrice;
                },
              ),

              // Cement/Sand Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Text(
                          'Cement 10 bags + 1 ton sand = 35m²',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Material(
                          // ADDED MATERIAL WIDGET HERE
                          color: const Color(0xFF550101),
                          child: TextField(
                            controller: _cementSandPriceController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              widget.pricing.cementSandPrice =
                                  double.tryParse(value) ??
                                  widget.pricing.cementSandPrice;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sand Ton = SQM / 35, Cement = Sand ton / 10',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  const Divider(color: Colors.white, height: 24),
                ],
              ),

              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: const Color(0x40000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 35,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                  child: const Text('SAVE PRICES'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 8,
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
            flex: 4,
            child: Material(
              // ADDED MATERIAL WIDGET HERE
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
}
