import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/spots_screen.dart'; // Écran après connexion
import '../screens/home_screen.dart'; // Écran pour les non-connectés
import '../providers/auth_provider.dart'; // AuthProvider

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Navigation conditionnelle basée sur l'état d'authentification
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: Future.microtask(() {
            if (authState.isLoggedIn) {
              // Redirige vers l'écran des Spots
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SpotsScreen()),
              );
            } else {
              // Redirige vers l'écran d'accueil
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            }
          }),
          builder: (context, snapshot) {
            // Animation de chargement pendant la redirection
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

