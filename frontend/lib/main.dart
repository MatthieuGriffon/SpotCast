import 'package:flutter/material.dart';
import 'widgets/splash/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_screen.dart';
import 'screens/groups_screen.dart';
import 'screens/spots_screen.dart';
import 'screens/profile_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Ajout du paramètre `key` pour le constructeur
  const MyApp({super.key}); 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SpotCast',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/events': (context) => const EventScreen(),
        '/groups': (context) => const GroupsScreen(),
        '/spots': (context) => const SpotsScreen(),
        '/profile': (context) => const ProfileScreen(),
        
        
      },
    );
  }
}
