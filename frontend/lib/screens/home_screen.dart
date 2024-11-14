import 'package:flutter/material.dart';
import '../widgets/common/carousel_widget.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/common/custom_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;

  // Méthode pour gérer l'inscription
  void _handleSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  // Méthode pour gérer la connexion
  void _handleLogin() {
    Navigator.pushNamed(context, '/login');
  }

  // Méthode pour la navigation entre les pages via la barre de navigation
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond qui prend toute la hauteur de l'écran
          Positioned.fill(
            child: Image.asset(
              'assets/images/realistic_sunrise.webp',
              fit: BoxFit.cover,
            ),
          ),

          // Intégration du CustomHeader pour les boutons "Inscription" et "Connexion"
          Positioned(
            top: statusBarHeight,
            left: 0,
            right: 0,
            child: CustomHeader(
              onSignUp: _handleSignUp,
              onLogin: _handleLogin,
            ),
          ),

          // Contenu principal
          Positioned(
            top: statusBarHeight + 80,
            left: 20,
            right: 20,
            bottom: 80, // Espace pour la barre de navigation
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SpotCast',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3A57),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: screenWidth / 1.5,
                    child: const Text(
                      'Découvrez les meilleurs spots de pêche autour de vous.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xCC000000),
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF9AACA9),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Parcourez notre application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Monsterrat',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ImageCarousel(),
                ],
              ),
            ),
          ),

          // Barre de navigation personnalisée en bas
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavigationBar(
              key: UniqueKey(), // Ajout d'une clé unique pour éviter les problèmes d'état
              currentIndex: _selectedIndex,
              onItemSelected: _onItemSelected,
            ),
          ),
        ],
      ),
    );
  }
}
