import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import 'spot_details_screen.dart';

class SpotsScreen extends StatefulWidget {
  const SpotsScreen({super.key});

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  int _selectedIndex = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> spots = [
    {
      'name': 'Lac Tranquille',
      'description': 'Un lac très calme pour pêcher en toute tranquillité',
      'location': 'Paris, France',
      'fishType': 'Truite, Brochet',
      'type': 'public'
    },
    {
      'name': 'Étang Secret',
      'description': 'Un étang caché pour les amateurs de pêche',
      'location': 'Lyon, France',
      'fishType': 'Carpe',
      'type': 'private'
    },
    {
      'name': 'Rivière Amicale',
      'description': 'Une rivière idéale pour pêcher en groupe',
      'location': 'Bordeaux, France',
      'fishType': 'Sandre, Perche',
      'type': 'group'
    },
    {
      'name': 'Canal de l\'Amitié',
      'description': 'Un canal parfait pour pêcher entre amis',
      'location': 'Marseille, France',
      'fishType': 'Brochet, Carpe',
      'type': 'public'
    },
    {
      'name': 'Lac de Toulouse le Rose',
      'description': 'Un lac rose pour une pêche romantique',
      'location': 'Toulouse, France',
      'fishType': 'Truite, Brochet',
      'type': 'group'
    },
    {
      'name': 'Rivière de la Liberté',
      'description': 'Une rivière pour pêcher en toute liberté',
      'location': 'Nantes, France',
      'fishType': 'Sandre, Perche',
      'type': 'public'
    },
    {
      'name': 'Étang de la Paix',
      'description': 'Un étang paisible pour une pêche relaxante',
      'location': 'Nice, France',
      'fishType': 'Carpe',
      'type': 'private'
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/spots');
        break;
      case 2:
        Navigator.pushNamed(context, '/groups');
        break;
      case 3:
        Navigator.pushNamed(context, '/events');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les spots en fonction de la recherche
    final List<Map<String, String>> filteredSpots = spots
        .where((spot) =>
            spot['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            spot['fishType']!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            spot['location']!.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spots'),
        backgroundColor: const Color(0xFF1B3A57),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Rechercher un spot',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),

          // Limiter l'affichage à 3 cartes avec un défilement
          Expanded(
            child: ListView.builder(
              itemCount: filteredSpots.length,
              itemBuilder: (context, index) {
                final spot = filteredSpots[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(
                      spot['type'] == 'private'
                          ? Icons.lock
                          : spot['type'] == 'group'
                              ? Icons.group
                              : Icons.public,
                      color: spot['type'] == 'private'
                          ? Colors.red
                          : spot['type'] == 'group'
                              ? Colors.blue
                              : Colors.green,
                    ),
                    title: Text(spot['name']!),
                    subtitle: Text(
                      'Location: ${spot['location']}\nFish: ${spot['fishType']}',
                    ),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                       Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpotDetailsScreen(spot: spot),
                  ),
                );
                    },
                  ),
                );
              },
            ),
          ),

          // Bouton d'ajout de spot
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: ElevatedButton(
              onPressed: () {
                print('Add Spot button clicked');
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(16),
                backgroundColor: const Color(0xFF1B3A57),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        key: UniqueKey(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
