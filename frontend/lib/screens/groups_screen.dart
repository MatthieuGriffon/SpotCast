import 'package:flutter/material.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/common/group_list.dart';
import 'dart:async';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  final int _selectedIndex = 2;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  Timer? _debounce;

  // Liste des groupes (déplacé depuis `GroupList`)
  final List<Map<String, dynamic>> groups = [
    {
      'name': 'Pêcheurs de la Côte',
      'description': 'Un groupe pour ceux qui aiment pêcher en bord de mer.',
      'type': 'public',
      'membersCount': 18,
      'location': 'Marseille, France',
      'roles': {
        'admin': ['Alexandre', 'Sophie'],
        'members': ['Lucas', 'Emma', 'Jules', 'Nina', 'Maxime'],
      },
      'createdBy': 'Alexandre',
    },
    {
      'name': 'Les Rois de la Truite',
      'description': 'Passionnés de pêche à la truite en rivière.',
      'type': 'private',
      'membersCount': 10,
      'location': 'Lyon, France',
      'roles': {
        'admin': ['Benoît', 'Claire'],
        'members': ['Juliette', 'Théo', 'Arthur', 'Louise'],
      },
      'createdBy': 'Benoît',
    },
    {
      'name': 'Pêcheurs Urbains',
      'description': 'Pour ceux qui pêchent dans les environnements urbains.',
      'type': 'group',
      'membersCount': 24,
      'location': 'Paris, France',
      'roles': {
        'admin': ['Martin', 'Cécile'],
        'members': ['Hugo', 'Léa', 'Paul', 'Chloé', 'Camille', 'Dylan'],
      },
      'createdBy': 'Martin',
    },
     {
    'name': 'Les Maîtres du Brochet',
    'description': 'Un groupe dédié aux passionnés de pêche au brochet dans les lacs et rivières.',
    'type': 'public',
    'membersCount': 22,
    'location': 'Lille, France',
    'roles': {
      'admin': ['François', 'Amélie'],
      'members': ['Luc', 'Catherine', 'Gérard', 'Isabelle', 'Julien', 'Émilie'],
    },
    'createdBy': 'François',
  },
  {
    'name': 'Pêcheurs Nocturnes',
    'description': 'Pour ceux qui aiment pêcher la nuit à la recherche des plus gros spécimens.',
    'type': 'private',
    'membersCount': 15,
    'location': 'Nice, France',
    'roles': {
      'admin': ['Léo', 'Sabrina'],
      'members': ['Olivier', 'Marc', 'Sarah', 'Élodie', 'Victor'],
    },
    'createdBy': 'Léo',
  },
  {
    'name': 'Les Aventuriers de la Mouche',
    'description': 'Amateurs de pêche à la mouche en montagne et en rivière.',
    'type': 'group',
    'membersCount': 20,
    'location': 'Chamonix, France',
    'roles': {
      'admin': ['Claire', 'Nicolas'],
      'members': ['Thibault', 'Sophie', 'Max', 'Anaïs', 'Lilian', 'Nina'],
    },
    'createdBy': 'Claire',
  },
  {
    'name': 'Carpes XXL',
    'description': 'Groupe pour les amateurs de pêche de carpes géantes.',
    'type': 'public',
    'membersCount': 30,
    'location': 'Bordeaux, France',
    'roles': {
      'admin': ['Guillaume', 'Chloé'],
      'members': ['Nathalie', 'Pierre', 'Amandine', 'Lucas', 'Hugo'],
    },
    'createdBy': 'Guillaume',
  },
  {
    'name': 'Pêche en Kayak',
    'description': 'Pêche en kayak pour les plus aventureux, sur lac et rivière.',
    'type': 'public',
    'membersCount': 12,
    'location': 'Lac d’Annecy, France',
    'roles': {
      'admin': ['Samuel', 'Aurore'],
      'members': ['Adrien', 'Lucie', 'Pauline', 'Vincent'],
    },
    'createdBy': 'Samuel',
  },
  {
    'name': 'Chasseurs de Silures',
    'description': 'Pour les pêcheurs expérimentés à la recherche des silures géants.',
    'type': 'private',
    'membersCount': 18,
    'location': 'Toulouse, France',
    'roles': {
      'admin': ['Bastien', 'Laura'],
      'members': ['Romain', 'Eva', 'Matthieu', 'Léna'],
    },
    'createdBy': 'Bastien',
  },
  {
    'name': 'Pêcheurs de Rivière Sauvage',
    'description': 'Exploration des rivières sauvages pour pêcher des espèces rares.',
    'type': 'group',
    'membersCount': 14,
    'location': 'Perpignan, France',
    'roles': {
      'admin': ['Yann', 'Sonia'],
      'members': ['Aurélien', 'Marine', 'Clara', 'Alban'],
    },
    'createdBy': 'Yann',
  },
  {
    'name': 'Pêcheurs Exotiques',
    'description': 'Adeptes de pêche en mer à l’étranger, à la recherche de poissons exotiques.',
    'type': 'public',
    'membersCount': 25,
    'location': 'Saint-Tropez, France',
    'roles': {
      'admin': ['Patrick', 'Elise'],
      'members': ['Antoine', 'Corinne', 'Sébastien', 'Justine', 'Florian'],
    },
    'createdBy': 'Patrick',
  },
  {
    'name': 'Les Mordus de la Daurade',
    'description': 'Spécialistes de la pêche à la daurade sur la côte Atlantique.',
    'type': 'private',
    'membersCount': 17,
    'location': 'La Rochelle, France',
    'roles': {
      'admin': ['David', 'Marion'],
      'members': ['Mickael', 'Fanny', 'Nicolas', 'Julie'],
    },
    'createdBy': 'David',
  },
  {
    'name': 'Pêcheurs en Famille',
    'description': 'Pour ceux qui aiment partager la pêche avec leurs enfants.',
    'type': 'public',
    'membersCount': 27,
    'location': 'Nantes, France',
    'roles': {
      'admin': ['Éric', 'Laurence'],
      'members': ['Zoé', 'Thomas', 'Benoît', 'Manon', 'Célia', 'Philippe'],
    },
    'createdBy': 'Éric',
  },
  ];

  void _onItemSelected(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacementNamed(
        context,
        _getRouteForIndex(index),
      );
    }
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

  // Fonction pour gérer la recherche avec un debounce
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = value.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Groupes',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                labelText: 'Rechercher un groupe',
                hintText: 'Nom ou lieu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: GroupList(groups: groups, searchQuery: _searchQuery),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
