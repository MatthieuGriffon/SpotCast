import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedIndex = 4; // Index pour la page "Profil"

  // Méthode pour gérer la navigation via la barre inférieure
  void _onItemSelected(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacementNamed(
        context,
        _getRouteForIndex(index),
      );
    }
  }

  // Fonction utilitaire pour récupérer la route en fonction de l'index
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
        title: const Text('Profil'),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: const Center(
        child: Text(
          'Bienvenue sur la page de votre Profil',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      // Utilisation du `CustomBottomNavigationBar`
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
