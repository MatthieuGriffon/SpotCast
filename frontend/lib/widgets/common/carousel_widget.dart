import 'package:flutter/material.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/image_slider01.webp',
      'assets/images/image_slider02.webp',
      'assets/images/image_slider03.webp',
    ];

    final List<String> titles = [
      'Découvrez des spots',
      'Rejoignez un groupe',
      'Planifiez votre sortie'
    ];

    final List<String> routes = [
      '/spots', // Route pour "Découvrez des spots"
      '/groups', // Route pour "Rejoignez un groupe"
      '/events', // Route pour "Planifiez votre sortie"
    ];

    return SizedBox(
      height: 110, // Hauteur ajustée pour le carrousel
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Naviguer vers la route associée
              Navigator.pushNamed(context, routes[index]);
            },
            child: Container(
              width: 90, // Largeur ajustée pour voir les images côte à côte
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 8,
                right: 14,
                top: 20,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Stack(
                  children: [
                    // Image
                    AspectRatio(
                      aspectRatio: 1, // Maintient le ratio carré
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Superposition du texte
                    Positioned(
                      bottom: 20,
                      left: 7,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            titles[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
