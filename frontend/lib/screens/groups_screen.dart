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
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController =
      TextEditingController();
  final String currentUserEmail =
      'benoit@example.com'; // Remplace par l'email réel
  final TextEditingController _groupLocationController =
      TextEditingController();
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
        'members': [
          'lucas@example.com',
          'emma@example.com',
          'jules@example.com',
          'nina@example.com',
          'maxime@example.com'
        ],
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
        'members': [
          'juliette@example.com',
          'theo@example.com',
          'arthur@example.com',
          'louise@example.com'
        ],
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
        'members': [
          'hugo@example.com',
          'lea@example.com',
          'paul@example.com',
          'chloe@example.com',
          'camille@example.com',
          'dylan@example.com'
        ],
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

  void _showAddGroupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Créer un nouveau groupe',
            style: TextStyle(
              fontSize: 16, // Taille de police du titre
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Champ pour le nom du groupe
                TextField(
                  controller: _groupNameController,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Nom du groupe',
                    hintText: 'Entrez le nom du groupe',
                    labelStyle: TextStyle(fontSize: 14),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),

                // Champ pour la description du groupe
                TextField(
                  controller: _groupDescriptionController,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Entrez une description',
                    labelStyle: TextStyle(fontSize: 14),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 10),

                // Nouveau champ pour le lieu du groupe
                TextField(
                  controller: _groupLocationController,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Lieu',
                    hintText: 'Entrez le lieu du groupe',
                    labelStyle: TextStyle(fontSize: 14),
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: _addGroup,
              child: const Text(
                'Créer',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isGroupNameTaken(String name) {
    return groups
        .any((group) => group['name'].toLowerCase() == name.toLowerCase());
  }

  void _addGroup() {
    final String groupName = _groupNameController.text.trim();
    final String groupDescription = _groupDescriptionController.text.trim();
    final String groupLocation = _groupLocationController.text.trim();

    if (_isGroupNameTaken(groupName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom du groupe est déjà pris.')),
      );
      return;
    }

    // Vérifier que tous les champs sont remplis
    if (groupName.isNotEmpty &&
        groupDescription.isNotEmpty &&
        groupLocation.isNotEmpty) {
      setState(() {
        groups.add({
          'name': groupName,
          'description': groupDescription,
          'type': 'public',
          'membersCount': 1,
          'location': groupLocation, // Ajout du lieu ici
          'roles': {
            'admin': [currentUserEmail],
            'members': [],
          },
          'createdBy': currentUserEmail,
        });
      });

      // Réinitialiser les champs après la création du groupe
      _groupNameController.clear();
      _groupDescriptionController.clear();
      _groupLocationController.clear();
      Navigator.of(context).pop();

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Groupe créé avec succès !')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupNameController.dispose();
    _groupDescriptionController.dispose();
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
        actions: [
          Row(
            children: [
              // Texte "Ajouter un groupe"
              const Padding(
                padding: EdgeInsets.only(right: 1.0),
                child: Text(
                  'Ajouter un groupe',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // Bouton avec l'icône "+"
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Ajouter un groupe',
                onPressed: () {
                  _showAddGroupDialog();
                },
              ),
            ],
          ),
        ],
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
