import 'package:flutter/material.dart';
import '../../screens//group_details_screen.dart';

class GroupCard extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(235, 236, 236, 236),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Icon(
            group['type'] == 'private'
                ? Icons.lock
                : group['type'] == 'group'
                    ? Icons.group
                    : Icons.public,
            color: group['type'] == 'private'
                ? Colors.red
                : group['type'] == 'group'
                    ? Colors.blue
                    : Colors.green,
          ),
          title: Text(
            group['name'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  group['location'] ?? 'Non spécifié',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  overflow:
                      TextOverflow.ellipsis, // Tronquer le texte si trop long
                ),
              ),
            ],
          ),
          trailing: SizedBox(
            width:
                80, // Limite la largeur à 80 pixels pour éviter le débordement
            child: Text(
              '${group['membersCount']} membres',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              overflow:
                  TextOverflow.ellipsis, // Tronquer si le texte est trop long
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailsScreen(
                  group: group,
                  currentUser: 'Benoît',
                ),
              ),
            );
          }),
    );
  }
}
