import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/screens/select_location_event_screen.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({super.key, required this.onPhotosUpdated});

  final Function(List<File>) onPhotosUpdated;

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _photos = [];

  Future<void> _pickImage(bool isCamera) async {
    final ImageSource source =
        isCamera ? ImageSource.camera : ImageSource.gallery;
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _photos.add(File(pickedFile.path));
        });
        widget.onPhotosUpdated(_photos);
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
        // Boutons pour ajouter une photo
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(false), // Galerie
              icon: const Icon(Icons.photo_library),
              label: const Text('Galerie'),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(true), // Caméra
              icon: const Icon(Icons.camera_alt),
              label: const Text('Caméra'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Aperçu des photos
        _photos.isEmpty
            ? const Text('Aucune photo sélectionnée',
                style: TextStyle(color: Colors.grey))
            : SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _photos.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      alignment: Alignment.topRight,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _photos[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _photos.removeAt(index);
                            });
                            widget.onPhotosUpdated(_photos);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
      ],
    );
  }
}

class FishingJournalScreen extends StatefulWidget {
  const FishingJournalScreen({super.key});

  @override
  State<FishingJournalScreen> createState() => _FishingJournalScreenState();
}

class _FishingJournalScreenState extends State<FishingJournalScreen> {
  final List<File> _photos = []; // Liste des photos partagées avec PhotoGallery
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  // Exemples de captures
  final List<Map<String, dynamic>> _captures = [
    {
      'type': 'Carpe',
      'weight': '3.5 kg',
      'spot': 'Lac Bleu',
      'date': '20/11/2024',
      'photo': '',
    },
    {
      'type': 'Brochet',
      'weight': '5.2 kg',
      'spot': 'Rivière Verte',
      'date': '18/11/2024',
      'photo': '',
    },
    {
      'type': 'Truite',
      'weight': '2.3 kg',
      'spot': 'Étang privé',
      'date': '15/11/2024',
      'photo': '',
    },
  ];
  // Statistiques globales (exemple statique)
  final int _totalCatches = 42;
  final String _bestCatch = '7 kg';
  final String _mostFrequentFish = 'Carpe';


  @override
  void dispose() {
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Gestion des photos mises à jour depuis PhotoGallery
  void _updatePhotos(List<File> newPhotos) {
    setState(() {
      _photos.clear();
      _photos.addAll(newPhotos);
    });
  }

   // Méthode pour supprimer une capture
  void _deleteCapture(int index) {
    setState(() {
      _captures.removeAt(index);
    });
  }

  void _openAddCaptureForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Champ Type de Poisson
                TextField(
                  decoration:
                      const InputDecoration(labelText: 'Type de Poisson'),
                ),

                // Champ Poids
                TextField(
                  decoration: const InputDecoration(labelText: 'Poids (kg)'),
                ),

                // Champ Lieu
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Lieu'),
                  readOnly: true,
                  onTap: () async {
                    final String? selectedLocation = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectLocationEventScreen(),
                      ),
                    );
                    if (selectedLocation != null) {
                      setState(() {
                        _locationController.text = selectedLocation;
                      });
                    }
                  },
                ),

                // Champ Date
                TextField(
                  controller: _dateController,
                  decoration:
                      const InputDecoration(labelText: 'Date (jj/mm/aaaa)'),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePickerDialog(
                      context: context,
                      initialDate: DateTime.now(),
                      minDate: DateTime(2020),
                      maxDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dateController.text =
                            '${pickedDate.day.toString().padLeft(2, '0')}/'
                            '${pickedDate.month.toString().padLeft(2, '0')}/'
                            '${pickedDate.year}';
                      });
                    }
                  },
                ),

                // PhotoGallery intégré
                const SizedBox(height: 16),
                PhotoGallery(onPhotosUpdated: _updatePhotos),

                // Bouton de validation
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Logique d'ajout de la capture
                    Navigator.pop(context);
                  },
                  child: const Text('Ajouter Capture'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal de pêche'),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Résumé des statistiques
            _buildStatisticsSummary(),

            const SizedBox(height: 16),

            // Liste des captures
            _buildCaptureList(),

            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddCaptureForm,
        backgroundColor: const Color(0xFF1B3A57),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Résumé des statistiques
  Widget _buildStatisticsSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Captures', style: TextStyle(color: Colors.grey)),
            Text('$_totalCatches',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Meilleure Prise', style: TextStyle(color: Colors.grey)),
            Text(_bestCatch,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Poisson Fréquent',
                style: TextStyle(color: Colors.grey)),
            Text(_mostFrequentFish,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Liste des captures
  Widget _buildCaptureList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _captures.length,
      itemBuilder: (context, index) {
        final capture = _captures[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Gestion de l'image ou d'une alternative
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child:
                      capture['photo'] != null && capture['photo']!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(capture['photo']),
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.image,
                              size: 30,
                              color: Colors.blue,
                            ),
                ),
                const SizedBox(width: 16),

                // Détails de la capture
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capture['type'],
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Lieu : ${capture['spot']} - Poids : ${capture['weight']} - Date : ${capture['date']}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // Bouton de suppression
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteCapture(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}