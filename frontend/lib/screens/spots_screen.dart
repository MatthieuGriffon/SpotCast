import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import 'add_spot_screen.dart';
import 'spot_details_screen.dart';

class SpotsScreen extends StatefulWidget {
  const SpotsScreen({super.key});

  @override
  State<SpotsScreen> createState() => _SpotsScreenState();
}

class _SpotsScreenState extends State<SpotsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final String currentUserEmail = 'benoit@example.com';

  // Rôle et groupes de l'utilisateur actuel
  static const String currentUserRole = 'groupAdmin'; // 'admin', 'groupAdmin', 'member'
  static final List<String> adminGroups = ['Group3', 'Group5']; // Groupes administrés
  static final List<String> currentUserGroups = ['Group3']; // Groupes où l'utilisateur est membre

  final List<Map<String, dynamic>> spots = [
    {
      'id': '1',
      'name': 'Lac Tranquille',
      'description': 'Un lac très calme pour pêcher en toute tranquillité',
      'location': 'Paris, France',
      'fishType': 'Truite, Brochet',
      'type': 'public',
      'latitude': 48.8566,
      'longitude': 2.3522,
      'owner': 'User1',
    },
    {
      'id': '2',
      'name': 'Étang Secret',
      'description': 'Un étang caché pour les amateurs de pêche',
      'location': 'Lyon, France',
      'fishType': 'Carpe',
      'type': 'private',
      'latitude': 45.7640,
      'longitude': 4.8357,
      'owner': 'User2',
    },
    {
      'id': '3',
      'name': 'Rivière Amicale',
      'description': 'Une rivière idéale pour pêcher en groupe',
      'location': 'Bordeaux, France',
      'fishType': 'Sandre, Perche',
      'type': 'group',
      'latitude': 44.8378,
      'longitude': -0.5792,
      'owner': 'Group3',
    },
    {
      'id': '4',
      'name': 'Canal de l\'Amitié',
      'description': 'Un canal parfait pour pêcher entre amis',
      'location': 'Marseille, France',
      'fishType': 'Brochet, Carpe',
      'type': 'public',
      'latitude': 43.2965,
      'longitude': 5.3698,
      'owner': 'User1',
    },
    {
      'id': '5',
      'name': 'Lac de Toulouse le Rose',
      'description': 'Un lac rose pour une pêche romantique',
      'location': 'Toulouse, France',
      'fishType': 'Truite, Brochet',
      'type': 'group',
      'latitude': 43.6045,
      'longitude': 1.4442,
      'owner': 'User1',
    },
  ];

  // Obtenir les spots visibles
  List<Map<String, dynamic>> _getVisibleSpots() {
    if (currentUserRole == 'admin') {
      return spots; // Administrateurs globaux voient tout
    }

    return spots.where((spot) {
      if (spot['type'] == 'public') {
        return true; // Spots publics visibles par tous
      } else if (spot['type'] == 'private') {
        return spot['owner'] == currentUserEmail; // Spots privés visibles uniquement par le propriétaire
      } else if (spot['type'] == 'group') {
        // Spots de groupe visibles si membre ou admin du groupe
        return currentUserGroups.contains(spot['owner']) ||
            (currentUserRole == 'groupAdmin' && adminGroups.contains(spot['owner']));
      }
      return false;
    }).toList();
  }

  // Supprimer un spot
  void _deleteSpot(String spotId) {
    setState(() {
      spots.removeWhere((spot) => spot['id'] == spotId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Spot supprimé avec succès !')),
    );
  }

  // Confirmer la suppression (vérification des droits incluse)
  void _confirmDeletion(String spotId, String spotOwner, String spotType) {
    final bool canDelete = currentUserRole == 'admin' || // Admin global
        (currentUserRole == 'groupAdmin' && adminGroups.contains(spotOwner) && spotType == 'group') || // Admin du groupe
        (spotType == 'private' && spotOwner == currentUserEmail); // Propriétaire du spot privé

    if (canDelete) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce spot ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _deleteSpot(spotId);
                Navigator.pop(context);
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vous n\'avez pas les droits pour supprimer ce spot.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> visibleSpots = _getVisibleSpots();
    final List<Map<String, dynamic>> filteredSpots = visibleSpots
        .where((spot) =>
            spot['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            spot['fishType']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            spot['location']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spots'),
        backgroundColor: const Color(0xFF1B3A57),
        actions: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(right: 2.0),
              child: Text(
                'Créer un spot',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Créer un nouveau spot',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddSpotScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                labelText: 'Rechercher un spot',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSpots.length,
              itemBuilder: (context, index) {
                final spot = filteredSpots[index];

                return Card(
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
                    title: Text(spot['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: ${spot['location']}'),
                        Text(
                          'Type: ${spot['type'] == "private" ? "Privé" : spot['type'] == "group" ? "Groupe" : "Public"}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: spot['type'] == "private"
                                ? Colors.red
                                : spot['type'] == "group"
                                    ? Colors.blue
                                    : Colors.green,
                          ),
                        ),
                      ],
                    ),
                    trailing: (currentUserRole == 'admin' ||
                            (currentUserRole == 'groupAdmin' &&
                                adminGroups.contains(spot['owner']) &&
                                spot['type'] == 'group') ||
                            (spot['type'] == 'private' && spot['owner'] == currentUserEmail))
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _confirmDeletion(spot['id'], spot['owner'], spot['type']),
                          )
                        : null,
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
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onItemSelected: (index) => Navigator.pushReplacementNamed(
          context,
          _getRouteForIndex(index),
        ),
      ),
    );
  }

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
}
