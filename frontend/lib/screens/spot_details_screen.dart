import 'package:flutter/material.dart';

class SpotDetailsScreen extends StatelessWidget {
  final Map<String, String> spot;

  // Le constructeur accepte un paramètre 'spot'
  const SpotDetailsScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spot['name'] ?? 'Détails du Spot'),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot['description'] ?? 'Pas de description disponible.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              'Location: ${spot['location']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Type de poissons : ${spot['fishType']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
