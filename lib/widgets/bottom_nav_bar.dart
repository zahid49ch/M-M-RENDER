// bottom_nav_bar.dart
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
        BottomNavigationBarItem(icon: Icon(Icons.engineering), label: 'Labour'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
