import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final int _selectedIndex = 3; // Index pour la page "Events"

  // Méthode pour gérer la navigation
  void _onItemSelected(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacementNamed(
        context,
        _getRouteForIndex(index),
      );
    }
  }

  // Fonction utilitaire pour obtenir la route en fonction de l'index
  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/spots';
      case 2:
        return '/groups';
      case 3:
        return '/events';
      case 4:
        return '/profile';
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Événements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur la page des Événements',
          style: TextStyle(fontSize: 16),
        ),
      ),
      // Utilisation de `CustomBottomNavigationBar`
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
