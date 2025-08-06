import 'package:flutter/material.dart';
import 'auth_screen.dart';
import 'pricing_screen.dart';
import 'global_pricing.dart';
import 'labour_calculation_screen.dart';
import 'quote_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 3; // Profile is index 3

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF731112),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF550101),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.amber,
              child: Icon(Icons.person, size: 60, color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Admin User',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'admin@mmrender.com.au',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  // Implement settings
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF550101),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'ACCOUNT SETTINGS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getScreenForIndex(int index) {
    final pricing = GlobalPricing(); // Or get from provider
    switch (index) {
      case 0:
        return QuotePage(pricing: pricing);
      case 1:
        return PricingScreen(pricing: pricing);
      case 2:
        return LabourCalculationScreen(pricing: pricing);
      case 3:
        return const ProfileScreen();
      default:
        return QuotePage(pricing: pricing);
    }
  }
}
