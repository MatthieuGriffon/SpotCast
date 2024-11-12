import 'package:flutter/material.dart';
import '../widgets/common/carousel_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Positioned.fill(
            child: Image.asset(
              'assets/images/realistic_sunrise.webp',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 60,
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

                // Texte de description
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
                const SizedBox(height: 40),

                // Boutons "Découvrir" et "Rejoindre"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(207, 255, 255, 255),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 26, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: const Text(
                        'Inscription',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3A57),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(207, 255, 255, 255),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                      child: const Text(
                        'Connexion',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B3A57),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 110),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      // Retirer 'const' ici
                      padding: const EdgeInsets.all(
                          10), // Espace interne autour du texte
                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.7), // Fond noir avec opacité
                        borderRadius:
                            BorderRadius.circular(12), // Coins arrondis
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF9AACA9),
                            blurRadius: 6,
                            offset: Offset(0, 3), // Décalage ombre
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
                          color: Colors.white, // Couleur du texte en blanc
                        ),
                      ),
                    ),
                  ),
                ),

                // Ajout du carrousel d'images
                const ImageCarousel(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
