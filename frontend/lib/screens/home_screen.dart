import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Utilisation des super paramètres simplifiée

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpotCast Home Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome to SpotCast!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
