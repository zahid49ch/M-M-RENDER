import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'global_pricing.dart';
import 'labour_calculation_screen.dart';

class PreparationBulkheadPrices extends StatefulWidget {
  const PreparationBulkheadPrices({super.key});

  @override
  State<PreparationBulkheadPrices> createState() =>
      _PreparationBulkheadPricesState();
}

class _PreparationBulkheadPricesState extends State<PreparationBulkheadPrices> {
  @override
  Widget build(BuildContext context) {
    final pricing = Provider.of<GlobalPricing>(context);

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                const Text(
                  'M & M RENDER',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),

                // Back Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button with icon
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
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    const Text(
                      'Preparation & Bulkhead Prices',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),

                const Divider(color: Colors.white, height: 20),

                // Input Sections
                _buildInputRow(
                  'Cover Trape, caulking, window Protection & Plastic: Per m²',
                  pricing.coverTrapePerSqm,
                  (value) =>
                      pricing.updatePrepBulkheadPrices(coverTrape: value),
                  isSuperscript: true,
                ),
                const SizedBox(height: 16),

                _buildInputRow(
                  'Plastic - Per Roll (50LM)',
                  pricing.plasticPerRoll,
                  (value) => pricing.updatePrepBulkheadPrices(plastic: value),
                ),
                const SizedBox(height: 16),

                _buildInputRow(
                  'Window - Per Item',
                  pricing.windowPerItem,
                  (value) => pricing.updatePrepBulkheadPrices(window: value),
                ),
                const SizedBox(height: 16),

                _buildInputRow(
                  'Pillars - Per Item',
                  pricing.prepPillarsPerItem,
                  (value) => pricing.updatePrepBulkheadPrices(pillars: value),
                ),
                const SizedBox(height: 16),

                _buildInputRow(
                  'Expansion Joints - Per Item',
                  pricing.expansionJointsPerItem,
                  (value) => pricing.updatePrepBulkheadPrices(expansion: value),
                ),

                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Bulk head-Corner Bead per 3m',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 16),

                // Corner Bead and Spray Glue inputs
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledInput(
                        'Each per 3m',
                        pricing.cornerBeadPer3m,
                        (value) =>
                            pricing.updatePrepBulkheadPrices(cornerBead: value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLabeledInput(
                        'Spray Glue per Can(covers 30LM)',
                        pricing.sprayGluePerCan,
                        (value) =>
                            pricing.updatePrepBulkheadPrices(sprayGlue: value),
                        isLongLabel: true,
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
                          builder: (context) => ChangeNotifierProvider.value(
                            value: pricing,
                            child: const LabourCalculationScreen(),
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
                      'NEXT: Labour Calculation & Rules',
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
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    String value,
    ValueChanged<String> onChanged, {
    bool isSuperscript = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: isSuperscript
              ? RichText(
                  text: TextSpan(
                    text: label.replaceAll('m²', 'm'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    children: const [
                      TextSpan(
                        text: '2',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
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
              isDense: true,
              filled: true,
              fillColor: const Color(0xFF550101),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInput(
    String label,
    String value,
    ValueChanged<String> onChanged, {
    bool isLongLabel = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLongLabel ? 14 : 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF550101),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            ),
          ),
        ),
      ],
    );
  }
}
