import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'screens/home_screen.dart';
import 'screens/event_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/spots_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_event_screen.dart';
import 'screens/fishing_journal_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Charge les variables d'environnement
  runApp(
    ProviderScope( // Enveloppe l'application dans un ProviderScope pour Riverpod
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpotCast',
      theme: ThemeData(
        scaffoldBackgroundColor:
            const Color.fromARGB(255, 167, 183, 194), // Couleur de fond globale
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B3A57), // Couleur de fond de l'AppBar
          iconTheme: IconThemeData(
            color: Colors
                .white, // Couleur des icônes, y compris la flèche de retour
          ),
          titleTextStyle: TextStyle(
            color: Colors.white, // Couleur du texte dans l'AppBar
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/home', // Utilise les routes pour naviguer
      routes: {
        '/home': (context) => const HomeScreen(),
        '/events': (context) => const EventScreen(),
        '/groups': (context) => const GroupsScreen(),
        '/spots': (context) => const SpotsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/create-event': (context) => const CreateEventScreen(),
        '/fishing_journal': (context) =>
            const FishingJournalScreen(), // Écran Journal de Pêche
      },
      locale: const Locale('fr', 'FR'), // Définit la locale par défaut
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', 'GB'),
        Locale('en', 'US'),
        Locale('fr', 'FR'),
        Locale('ar'),
        Locale('zh'),
      ],
    );
  }
}
