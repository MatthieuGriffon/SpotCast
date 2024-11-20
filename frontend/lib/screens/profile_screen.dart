import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _selectedIndex = 4; // Index pour la page "Profil"
  File? _selectedImage; // Image sélectionnée
  bool _isEditingName = false; // État d'édition pour le nom
  String _userName = 'John Doe'; // Nom utilisateur (modifiable)
  String _userBio =
      'Passionné de pêche, j\'adore découvrir de nouveaux spots.'; // Biographie utilisateur
  bool _isEditingBio = false; // État d'édition pour la biographie

  // Événements récents et spots favoris (exemples statiques)
  final List<Map<String, String>> _recentEvents = [
    {'title': 'Pêche au lac', 'date': '20/11/2024', 'location': 'Lac Bleu'},
    {
      'title': 'Sortie rivière',
      'date': '15/11/2024',
      'location': 'Rivière Verte'
    },
    {
      'title': 'Tournoi de pêche',
      'date': '10/11/2024',
      'location': 'Étang privé'
    },
  ];
  final List<Map<String, String>> _favoriteSpots = [
    {'name': 'Lac Bleu', 'privacy': 'Public'},
    {'name': 'Rivière Verte', 'privacy': 'Privé'},
    {'name': 'Étang Merveilleux', 'privacy': 'Groupe'},
  ];

  // Statistiques du journal de pêche (exemples statiques)
  final int _totalCatches = 42;
  final String _bestCatch = '7 kg';

  // Méthode pour gérer la sélection d'une image
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo de profil
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : AssetImage('assets/default_profile.jpg')
                            as ImageProvider,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _pickImage, // Sélectionner une image
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nom d'utilisateur
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isEditingName
                      ? SizedBox(
                          width: 200,
                          child: TextFormField(
                            key: const ValueKey('edit'),
                            initialValue: _userName,
                            onFieldSubmitted: (newValue) {
                              if (newValue.isNotEmpty && newValue.length >= 3) {
                                setState(() {
                                  _userName = newValue;
                                  _isEditingName = false;
                                });
                              }
                            },
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        )
                      : Text(
                          _userName,
                          key: const ValueKey('read'),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(_isEditingName ? Icons.check : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditingName = !_isEditingName;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Email
            const Text(
              'johndoe@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Biographie
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Biographie',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(_isEditingBio ? Icons.check : Icons.edit),
                          onPressed: () {
                            setState(() {
                              _isEditingBio = !_isEditingBio;
                            });
                          },
                        ),
                      ],
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isEditingBio
                          ? TextFormField(
                              key: const ValueKey('edit_bio'),
                              initialValue: _userBio,
                              maxLines: 3,
                              onFieldSubmitted: (value) {
                                setState(() {
                                  _userBio = value;
                                  _isEditingBio = false;
                                });
                              },
                            )
                          : Text(
                              _userBio,
                              key: const ValueKey('read_bio'),
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Derniers événements
            _buildRecentEventsSection(),

            const SizedBox(height: 16),

            // Spots favoris
            _buildFavoriteSpotsSection(),

            const SizedBox(height: 16),

            // Journal de pêche
            _buildFishingJournalSummary(),

            const SizedBox(height: 16),

            // Déconnexion et suppression de compte
            _buildAccountActions(),
          ],
        ),
      ),
      // Barre de navigation inférieure
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Widget _buildRecentEventsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Derniers événements',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentEvents.length,
              itemBuilder: (context, index) {
                final event = _recentEvents[index];
                return ListTile(
                  leading: Icon(Icons.event, color: Colors.blue),
                  title: Text(event['title']!),
                  subtitle: Text('${event['date']} - ${event['location']}'),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    // Naviguer vers les détails de l'événement
                  },
                );
              },
            ),
            TextButton(
              onPressed: () {
                // Naviguer vers une page affichant tous les événements
              },
              child: const Text('Voir tous les événements'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteSpotsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spots favoris',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _favoriteSpots.length,
                itemBuilder: (context, index) {
                  final spot = _favoriteSpots[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 8),
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(spot['name']!),
                          Text('Confidentialité : ${spot['privacy']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFishingJournalSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Journal de pêche',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      'Total captures',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '$_totalCatches',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Meilleure prise',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      _bestCatch,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context,
                    '/fishing_journal'); // Naviguer vers le Journal de pêche
              },
              child: const Text('Voir tout le journal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions() {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            // Logique de déconnexion
          },
          child: const Text(
            'Déconnexion',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirmer'),
                content: const Text(
                    'Voulez-vous vraiment supprimer votre compte ? Cette action est irréversible.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Logique de suppression
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Supprimer',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Text(
            'Supprimer le compte',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
