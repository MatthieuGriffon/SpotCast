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
      'admin': ['alexandre@example.com', 'sophie@example.com'],
      'members': ['lucas@example.com', 'emma@example.com', 'jules@example.com', 'nina@example.com', 'maxime@example.com'],
    },
    'createdBy': 'alexandre@example.com',
  },
  {
    'name': 'Les Rois de la Truite',
    'description': 'Passionnés de pêche à la truite en rivière.',
    'type': 'private',
    'membersCount': 10,
    'location': 'Lyon, France',
    'roles': {
      'admin': ['benoit@example.com', 'claire@example.com'],
      'members': ['juliette@example.com', 'theo@example.com', 'arthur@example.com', 'louise@example.com'],
    },
    'createdBy': 'benoit@example.com',
  },
  {
    'name': 'Pêcheurs Urbains',
    'description': 'Pour ceux qui pêchent dans les environnements urbains.',
    'type': 'group',
    'membersCount': 24,
    'location': 'Paris, France',
    'roles': {
      'admin': ['martin@example.com', 'cecile@example.com'],
      'members': ['hugo@example.com', 'lea@example.com', 'paul@example.com', 'chloe@example.com', 'camille@example.com', 'dylan@example.com'],
    },
    'createdBy': 'martin@example.com',
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
