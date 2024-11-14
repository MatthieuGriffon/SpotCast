import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import 'map_screen.dart';
import '../widgets/common/review_section.dart';
import '../widgets/common/photo_gallery.dart';

class SpotDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> spot;

  const SpotDetailsScreen({super.key, required this.spot});

  @override
  State<SpotDetailsScreen> createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  bool isFavorite = false;

  // Nouveau : TextEditingController pour la note
  final TextEditingController _noteController = TextEditingController();

  // Liste temporaire pour stocker les notes pendant la session
  final List<String> _notes = [];

   @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

   void _addNote() {
    final note = _noteController.text.trim();
    if (note.isNotEmpty) {
      setState(() {
        _notes.add(note);
        _noteController.clear();
      });
    }
  }
   // Fonction pour supprimer une note
  void _deleteNoteAt(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  // Méthode pour gérer la navigation via la barre inférieure
  void _onItemSelected(int index) {
    if (index != 1) { // On évite de naviguer vers la même page
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
    final spot = widget.spot;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          spot['name'] ?? 'Détails du Spot',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: const Color(0xFF1B3A57),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite
                        ? 'Spot ajouté aux favoris'
                        : 'Spot retiré des favoris',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Afficher l'image du spot s'il y en a une
            if (spot.containsKey('imageUrl') && spot['imageUrl']!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  spot['imageUrl']!,
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
            const SizedBox(height: 20),

            // Nom du spot
            Text(
              spot['name'] ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            
            // Description du spot
            Text(
              spot['description'] ?? 'Pas de description disponible.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Emplacement du spot
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    spot['location'] ?? 'Emplacement inconnu',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Types de poissons disponibles
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.set_meal, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Types de poissons : ${spot['fishType']}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Type de spot (public, privé, groupe)
            Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Type : ${spot['type']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Bouton pour afficher la carte
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(spot: widget.spot),
                  ),
                );
              },
              icon: const Icon(Icons.map, color: Colors.white, size: 32),
              label: const Text(
                'Voir sur la carte',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),

            // Section des avis
            const ReviewSection(),
            const SizedBox(height: 20),

            // Galerie de photos
            const PhotoGallery(),
            // Section pour ajouter une note
            const Text(
              'Ajouter une note personnelle :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                hintText: 'Écrivez votre note ici...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _addNote,
              icon: const Icon(Icons.save),
              label: const Text('Sauvegarder la note'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            
            const SizedBox(height: 20),
             // Affichage des notes ajoutées avec option de suppression
            if (_notes.isNotEmpty) ...[
              const Text(
                'Vos Notes :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(_notes[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteNoteAt(index),
                      ),
                    ),
                  );
                },
              ),
            ] else
              const Text('Aucune note ajoutée pour l\'instant.'),
          ],
        ),
        
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
