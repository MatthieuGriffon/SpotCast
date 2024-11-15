import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final String name;
  final bool isAdmin;
  final VoidCallback? onRemove;

  const MemberCard({
    super.key,
    required this.name,
    required this.isAdmin,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(235, 236, 236, 236),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(name),
        trailing: isAdmin
            ? const Text('Admin', style: TextStyle(color: Colors.red))
            : onRemove != null
                ? IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onRemove,
                  )
                : null,
      ),
    );
  }
}

