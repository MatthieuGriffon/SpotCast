import 'package:flutter/material.dart';
import '../../screens/home_screen.dart';
import '../../screens/spots_screen.dart';
import '../../screens/groups_screen.dart';
import '../../screens/event_screen.dart';
import '../../screens/profile_screen.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected; // <- Assurez-vous que ce nom est correct

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  // Liste des pages à afficher pour chaque index
  final List<Widget> _pages = [
    HomeScreen(),
    SpotsScreen(),
    GroupsScreen(),
    EventScreen(),
    ProfileScreen(),
  ];

  void _handleNavigation(int index) {
    if (index != widget.currentIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => _pages[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1B3A57),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          _handleNavigation(index);
          widget.onItemSelected(index); // <- Utilisation du paramètre ici
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Spots',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
