import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _photos = [];

  // Fonction pour sélectionner une image depuis la galerie ou la caméra
  Future<void> _pickImage(bool isCamera) async {
    final ImageSource source =
        isCamera ? ImageSource.camera : ImageSource.gallery;

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _photos.add(File(pickedFile.path));
        });
      } else {
        print('Aucune image sélectionnée');
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card pour "Ajouter une photo" et les boutons
        Card(
          color: const Color.fromARGB(0, 236, 236, 236)
              .withOpacity(0.9), // Fond gris transparent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ajouter une photo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3A57), // Couleur du texte
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(false), // Galerie
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF1B3A57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(true), // Caméra
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        iconColor: Colors.white,
                        backgroundColor: const Color(0xFF1B3A57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
// Afficher les photos sélectionnées ou un message si la liste est vide
        _photos.isEmpty
            ? Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Card(
                  color:
                      const Color.fromARGB(0, 236, 236, 236).withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No photos added yet.',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  color:
                      const Color.fromARGB(0, 236, 236, 236).withOpacity(0.9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _photos.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _photos[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Bouton pour supprimer l'image
                                IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _photos.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
