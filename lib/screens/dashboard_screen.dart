import 'package:flutter/material.dart';
import 'quote_screen.dart';
import 'pricing_screen.dart';
import 'labour_calculation_screen.dart';
import 'profile_screen.dart';
import 'auth_screen.dart';
import 'global_pricing.dart';

class DashboardPage extends StatefulWidget {
  final GlobalPricing pricing;
  const DashboardPage({super.key, required this.pricing});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      QuotePage(pricing: widget.pricing),
      PricingScreen(pricing: widget.pricing),
      LabourCalculationScreen(pricing: widget.pricing),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // M&M Logo in amber box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'M&M',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // RENDER text
            const Text(
              'RENDER',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF550101),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
}
