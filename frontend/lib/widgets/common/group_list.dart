import 'package:flutter/material.dart';
import './group_card.dart';

class GroupList extends StatelessWidget {
  final String searchQuery;

  GroupList({super.key, required this.searchQuery});

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
      'name': 'Amateurs de Carpe',
      'description': 'Groupe dédié à la pêche de la carpe dans les lacs.',
      'type': 'public',
      'membersCount': 30,
      'location': 'Bordeaux, France',
      'roles': {
        'admin': ['Guillaume', 'Isabelle'],
        'members': ['Élodie', 'Nathan', 'Thomas', 'Sarah', 'Axel', 'Manon'],
      },
      'createdBy': 'Guillaume',
    },
    {
      'name': 'Les Aventuriers du Lac',
      'description':
          'Exploration de nouveaux lacs pour découvrir les meilleurs spots.',
      'type': 'private',
      'membersCount': 15,
      'location': 'Annecy, France',
      'roles': {
        'admin': ['Vincent', 'Amélie'],
        'members': ['Bastien', 'Charlotte', 'Raphaël', 'Alice', 'Florian'],
      },
      'createdBy': 'Vincent',
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Filtrer les groupes en fonction du nom et de la localisation
    final filteredGroups = groups.where((group) {
      final name = group['name']!.toLowerCase();
      final location = group['location']!.toLowerCase();
      return name.contains(searchQuery) || location.contains(searchQuery);
    }).toList();

    if (filteredGroups.isEmpty) {
      return const Center(
        child: Text(
          'Aucun groupe trouvé.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredGroups.length,
      itemBuilder: (context, index) {
        return GroupCard(group: filteredGroups[index]);
      },
    );
  }
}
