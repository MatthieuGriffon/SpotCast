import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class FishingJournalScreen extends StatefulWidget {
  const FishingJournalScreen({super.key});

  @override
  State<FishingJournalScreen> createState() => _FishingJournalScreenState();
}

class _FishingJournalScreenState extends State<FishingJournalScreen> {
  final List<File> _photos = []; // Liste des photos sélectionnées
  final ImagePicker _picker = ImagePicker();

  // Exemples de captures (remplacer par des données dynamiques si besoin)
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

  // Méthode pour sélectionner une photo
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

  // Formulaire pour ajouter une capture
  void _openAddCaptureForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        // Utiliser StatefulBuilder pour gérer le changement d'état localement
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Champs texte pour les détails de la capture
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Type de Poisson'),
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Poids (kg)'),
                    ),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Lieu'),
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Date et Heure'),
                    ),
                    const SizedBox(height: 16),

                    // Section pour ajouter une photo
                    Card(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ajouter une photo',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await _pickImage(false);
                                    // Mettre à jour le `BottomSheet` via `setModalState`
                                    setModalState(() {});
                                  },
                                  icon: const Icon(Icons.photo_library),
                                  label: const Text('Galerie'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    await _pickImage(true);
                                    // Mettre à jour le `BottomSheet` via `setModalState`
                                    setModalState(() {});
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Caméra'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Aperçu des photos sélectionnées
                    const SizedBox(height: 16),
                    _photos.isEmpty
                        ? const Text(
                            'Aucune photo sélectionnée',
                            style: TextStyle(color: Colors.grey),
                          )
                        : SizedBox(
                            height: 120,
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
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () {
                                        setModalState(() {
                                          _photos.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                    const SizedBox(height: 16),

                    // Bouton pour valider l'ajout
                    ElevatedButton(
                      onPressed: () {
                        // Logique pour valider et ajouter la capture
                        Navigator.pop(context); // Fermer le formulaire
                      },
                      child: const Text('Ajouter Capture'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Méthode pour supprimer une capture
  void _deleteCapture(int index) {
    setState(() {
      _captures.removeAt(index);
    });
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
                  child: capture['photo'] != null &&
                          capture['photo']!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(capture['photo']),
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            capture['type'][0], // Initiale du type de poisson
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
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
