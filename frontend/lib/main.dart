import 'package:flutter/material.dart';
import 'widgets/splash/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/spots_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_event_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpotCast',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 167, 183, 194), // Couleur de fond globale
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B3A57), // Couleur de fond de l'AppBar
          iconTheme: IconThemeData(
            color: Colors.white, // Couleur des icônes, y compris la flèche de retour
          ),
          titleTextStyle: TextStyle(
            color: Colors.white, // Couleur du texte dans l'AppBar
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialRoute: '/', // Utilise les routes pour naviguer
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/events': (context) => const EventScreen(),
        '/groups': (context) => const GroupsScreen(),
        '/spots': (context) => const SpotsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/create-event': (context) => const CreateEventScreen(),
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
