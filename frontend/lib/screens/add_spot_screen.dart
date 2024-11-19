import 'package:flutter/material.dart';

class AddSpotScreen extends StatelessWidget {
  const AddSpotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un nouveau spot'),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: const Center(
        child: Text(
          'Page pour ajouter un spot',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
