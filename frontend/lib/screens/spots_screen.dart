import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class SpotsScreen extends StatefulWidget {
  const SpotsScreen({super.key});

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  final int _selectedIndex = 1; // Index pour la page "Spots"

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/spots');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/groups');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/events');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spots'),
      ),
      body: const Center(
        child: Text('Bienvenue sur la page des Spots'),
      ),
      // Utilisation de la propriété `bottomNavigationBar`
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
