import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pricing_screen.dart';
import 'labour_calculation_screen.dart';
import 'profile_screen.dart';
import 'material_breakdown_screen.dart';
import 'global_pricing.dart';
import '../widgets/section_card.dart';
import '../widgets/input_field.dart';
import '../widgets/extra_item_card.dart';

class QuotePage extends StatefulWidget {
  final GlobalPricing pricing;
  const QuotePage({super.key, required this.pricing});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  // Controllers
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _renderSqmController = TextEditingController();
  final TextEditingController _hebelSqmController = TextEditingController();
  final TextEditingController _acrylicSqmController = TextEditingController();
  final TextEditingController _foamSqmController = TextEditingController();
  final TextEditingController _labourHoursController = TextEditingController();
  final TextEditingController _traderHoursController = TextEditingController();

  // Extra items
  final List<Map<String, dynamic>> _extraItems = [
    {
      'name': 'Quoins',
      'unit': 'each',
      'controller': TextEditingController(text: '0'),
    },
    {
      'name': 'Bulkheads',
      'unit': 'LM',
      'controller': TextEditingController(text: '0'),
    },
    {
      'name': 'Plinths',
      'unit': 'LM',
      'controller': TextEditingController(text: '0'),
    },
    {
      'name': 'Columns',
      'unit': 'each',
      'controller': TextEditingController(text: '0'),
    },
    {
      'name': 'Window Bands',
      'unit': 'each',
      'controller': TextEditingController(text: '0'),
    },
  ];

  // Custom extra items
  final List<Map<String, dynamic>> _customExtraItems = [];

  String _newItemName = '';
  String _newItemUnit = 'each';

  @override
  void initState() {
    super.initState();
    _loadDraft();
  }

  Future<void> _loadDraft() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      _customerNameController.text =
          prefs.getString('draft_customerName') ?? '';
      _mobileController.text = prefs.getString('draft_mobile') ?? '';
      _emailController.text = prefs.getString('draft_email') ?? '';
      _projectController.text = prefs.getString('draft_project') ?? '';
      _renderSqmController.text = prefs.getString('draft_renderSqm') ?? '';
      _hebelSqmController.text = prefs.getString('draft_hebelSqm') ?? '';
      _acrylicSqmController.text = prefs.getString('draft_acrylicSqm') ?? '';
      _foamSqmController.text = prefs.getString('draft_foamSqm') ?? '';
      _labourHoursController.text = prefs.getString('draft_labourHours') ?? '';
      _traderHoursController.text = prefs.getString('draft_traderHours') ?? '';

      for (var item in _extraItems) {
        item['controller'].text =
            prefs.getString('draft_${item['name']}') ?? '0';
      }

      final customCount = prefs.getInt('draft_customCount') ?? 0;
      for (int i = 0; i < customCount; i++) {
        _customExtraItems.add({
          'name': prefs.getString('draft_customName_$i') ?? 'Custom Item',
          'unit': prefs.getString('draft_customUnit_$i') ?? 'each',
          'controller': TextEditingController(
            text: prefs.getString('draft_customValue_$i') ?? '0',
          ),
        });
      }
    });
  }

  Future<void> _saveDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('draft_customerName', _customerNameController.text);
    await prefs.setString('draft_mobile', _mobileController.text);
    await prefs.setString('draft_email', _emailController.text);
    await prefs.setString('draft_project', _projectController.text);
    await prefs.setString('draft_renderSqm', _renderSqmController.text);
    await prefs.setString('draft_hebelSqm', _hebelSqmController.text);
    await prefs.setString('draft_acrylicSqm', _acrylicSqmController.text);
    await prefs.setString('draft_foamSqm', _foamSqmController.text);
    await prefs.setString('draft_labourHours', _labourHoursController.text);
    await prefs.setString('draft_traderHours', _traderHoursController.text);

    for (var item in _extraItems) {
      await prefs.setString('draft_${item['name']}', item['controller'].text);
    }

    await prefs.setInt('draft_customCount', _customExtraItems.length);
    for (int i = 0; i < _customExtraItems.length; i++) {
      await prefs.setString(
        'draft_customName_$i',
        _customExtraItems[i]['name'],
      );
      await prefs.setString(
        'draft_customUnit_$i',
        _customExtraItems[i]['unit'],
      );
      await prefs.setString(
        'draft_customValue_$i',
        _customExtraItems[i]['controller'].text,
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Draft saved successfully')));
    }
  }

  void _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _clearAllFields();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Draft cleared')));
    }
  }

  void _clearAllFields() {
    setState(() {
      _customerNameController.clear();
      _mobileController.clear();
      _emailController.clear();
      _projectController.clear();
      _renderSqmController.clear();
      _hebelSqmController.clear();
      _acrylicSqmController.clear();
      _foamSqmController.clear();
      _labourHoursController.clear();
      _traderHoursController.clear();

      for (var item in _extraItems) {
        item['controller'].text = '0';
      }

      _customExtraItems.clear();
    });
  }

  void _addCustomItem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Item Name',
                hintText: 'e.g., Special Trim',
              ),
              onChanged: (value) => _newItemName = value,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: 'each',
              items: const [
                DropdownMenuItem(value: 'each', child: Text('each')),
                DropdownMenuItem(value: 'LM', child: Text('LM')),
                DropdownMenuItem(value: 'SQM', child: Text('SQM')),
                DropdownMenuItem(value: 'hour', child: Text('hour')),
              ],
              onChanged: (value) => _newItemUnit = value ?? 'each',
              decoration: const InputDecoration(labelText: 'Unit'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newItemName.isNotEmpty) {
                setState(() {
                  _customExtraItems.add({
                    'name': _newItemName,
                    'unit': _newItemUnit,
                    'controller': TextEditingController(text: '0'),
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeCustomItem(int index) {
    setState(() {
      _customExtraItems.removeAt(index);
    });
  }

  void _navigateToMaterialBreakdown() {
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
    final acrylicSQM = double.tryParse(_acrylicSqmController.text) ?? 0;
    final foamSQM = double.tryParse(_foamSqmController.text) ?? 0;
    final labourHours = double.tryParse(_labourHoursController.text) ?? 0;
    final traderHours = double.tryParse(_traderHoursController.text) ?? 0;

    if (renderSQM <= 0 && hebelSQM <= 0 && acrylicSQM <= 0 && foamSQM <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one area value')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MaterialBreakdownScreen(
          pricing: widget.pricing,
          customerName: _customerNameController.text,
          projectName: _projectController.text,
          renderSQM: renderSQM,
          hebelSQM: hebelSQM,
          acrylicSQM: acrylicSQM,
          foamSQM: foamSQM,
          labourHours: labourHours,
          traderHours: traderHours,
          customerMobile: _mobileController.text,
          customerEmail: _emailController.text,
          quoins: int.tryParse(_extraItems[0]['controller'].text) ?? 0,
          bulkheads: int.tryParse(_extraItems[1]['controller'].text) ?? 0,
          plynth: int.tryParse(_extraItems[2]['controller'].text) ?? 0,
          columns: int.tryParse(_extraItems[3]['controller'].text) ?? 0,
          windowBands: int.tryParse(_extraItems[4]['controller'].text) ?? 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Create New Quote'),
        backgroundColor: const Color(0xFF550101),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDraft,
            tooltip: 'Save Draft',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearDraft,
            tooltip: 'Clear Draft',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Welcome Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              color: const Color(0xFF550101),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${_customerNameController.text.isNotEmpty ? _customerNameController.text : 'User'}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Create a new quote for your client',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: [
                  // Home/Quote Screen
                  SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Customer Details
                        SectionCard(
                          title: 'Customer Details',
                          children: [
                            InputField(
                              placeholder: 'Customer Name*',
                              controller: _customerNameController,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: InputField(
                                    placeholder: 'Mobile',
                                    controller: _mobileController,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InputField(
                                    placeholder: 'Email',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              placeholder: 'Project ID*',
                              controller: _projectController,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Quote Items
                        SectionCard(
                          title: 'Quote Items',
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 3,
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
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: InputField(
                                    placeholder: 'Labour Hours',
                                    controller: _labourHoursController,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
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
                        const SizedBox(height: 20),

                        // Extra Features
                        SectionCard(
                          title: 'Extra Features',
                          children: [
                            // Standard extra items
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 3,
                                  ),
                              itemCount: _extraItems.length,
                              itemBuilder: (context, index) {
                                final item = _extraItems[index];
                                return InputField(
                                  placeholder:
                                      '${item['name']} (${item['unit']})',
                                  controller: item['controller'],
                                  keyboardType: TextInputType.number,
                                );
                              },
                            ),

                            // Custom extra items
                            if (_customExtraItems.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Custom Items',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._customExtraItems.map(
                                (item) => ExtraItemCard(
                                  name: item['name'],
                                  unit: item['unit'],
                                  controller: item['controller'],
                                  onDelete: () => _removeCustomItem(
                                    _customExtraItems.indexOf(item),
                                  ),
                                ),
                              ),
                            ],

                            // Add custom item button
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _addCustomItem,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Custom Item'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF550101),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: const BorderSide(
                                  color: Color(0xFF550101),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Generate Quote Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _navigateToMaterialBreakdown,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'GENERATE QUOTE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),

                  // Pricing Screen
                  PricingScreen(pricing: widget.pricing),

                  // Labour Screen
                  LabourCalculationScreen(pricing: widget.pricing),

                  // Profile Screen
                  const ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        _pageController.jumpToPage(index);
        if (index == 0) {
          _scrollController.jumpTo(0);
        }
      },
      backgroundColor: const Color(0xFF550101),
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.white70,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Pricing',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.engineering), label: 'Labour'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _customerNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _projectController.dispose();
    _renderSqmController.dispose();
    _hebelSqmController.dispose();
    _acrylicSqmController.dispose();
    _foamSqmController.dispose();
    _labourHoursController.dispose();
    _traderHoursController.dispose();

    for (var item in _extraItems) {
      item['controller'].dispose();
    }

    for (var item in _customExtraItems) {
      item['controller'].dispose();
    }

    super.dispose();
  }
}
