import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenir la largeur de l'écran
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // On supprime l'AppBar pour que l'image de fond prenne tout l'écran
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              'assets/images/realistic_sunrise.webp', // Remplace par le chemin correct vers ton image
              fit: BoxFit.cover,
            ),
          ),
          // Contenu principal
          Positioned(
            top: 60, // Ajuster pour remonter le texte si nécessaire
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre de l'application
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
                // Texte de description limité à un tiers de la largeur de l'écran
                SizedBox(
                  width: screenWidth / 1.5,
                  child: const Text(
                    'Découvrez les meilleurs spots de pêche autour de vous.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xCC000000),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
