import 'package:flutter/material.dart';
import './group_card.dart';

class GroupList extends StatelessWidget {
  final List<Map<String, dynamic>> groups;
  final String searchQuery;

  const GroupList({super.key, required this.groups, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
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
