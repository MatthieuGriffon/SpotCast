import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/common/custom_bottom_navigation_bar.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class Event {
  final String name;
  final String date;
  final String time;
  final String location;
  final double latitude;
  final double longitude;
  final String type;
  Map<String, dynamic>? weather; // Contient description, icon et temperature
  String? error; // Pour gérer les erreurs de récupération météo

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.weather,
    this.error,
  });
}

class _EventScreenState extends State<EventScreen> {
  final int _selectedIndex = 3; // Index pour la page "Events"
  final List<Event> events = [
    Event(
      name: 'Pêche au Lac Bleu',
      date: '22/11/2024',
      time: '09:00',
      location: 'Lac Bleu, Paris',
      latitude: 48.8566,
      longitude: 2.3522,
      type: 'Public',
    ),
    Event(
      name: 'Sortie Groupe Privé',
      date: '25/11/2024',
      time: '14:00',
      location: 'Rivière Verte, Lyon',
      latitude: 45.764,
      longitude: 4.8357,
      type: 'Privé',
    ),
    Event(
      name: 'Rencontre au Port',
      date: '28/11/2024',
      time: '08:00',
      location: 'Port Sud, Marseille',
      latitude: 43.2965,
      longitude: 5.3698,
      type: 'Public',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeatherForEvents();
  }

  Future<void> _fetchWeatherForEvent(Event event) async {
    if (event.weather != null) {
      return; // La météo est déjà disponible
    }

    try {
      const String apiKey = '898b965d06a496f870aeb23876747c22';
      final Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${event.latitude}&lon=${event.longitude}&units=metric&lang=fr&appid=$apiKey',
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final weatherData = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          event.weather = {
            'description': weatherData['weather'][0]['description'],
            'icon': weatherData['weather'][0]['icon'],
            'temperature': weatherData['main']['temp'],
          };
          event.error = null; // Pas d’erreur
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        event.error = 'Erreur lors du chargement météo.';
      });
    }
  }

  Future<void> _fetchWeatherForEvents() async {
    for (var event in events) {
      await _fetchWeatherForEvent(event);
    }
  }

  // Méthode pour gérer la navigation
  void _onItemSelected(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacementNamed(
        context,
        _getRouteForIndex(index),
      );
    }
  }

  // Fonction utilitaire pour obtenir la route en fonction de l'index
  String _getRouteForIndex(int index) {
    switch (index) {
      case 0:
        return '/home';
      case 1:
        return '/spots';
      case 2:
        return '/groups';
      case 3:
        return '/events';
      case 4:
        return '/profile';
      default:
        return '/home';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Événements',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: ListView.builder(
        itemCount: events.length,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) {
          final event = events[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: event.weather != null && event.weather!['icon'] != null
                    ? Image.network(
                        'https://openweathermap.org/img/wn/${event.weather!['icon']}@2x.png',
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.cloud_off,
                              color: Colors.white);
                        },
                      )
                    : const CircularProgressIndicator(),
              ),
              title: Text(
                event.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: event.error != null
                  ? Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          event.error!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            '${event.date} à ${event.time}\n${event.location}'),
                        if (event.weather != null)
                          Text(
                            'Météo : ${event.weather!['description']} - ${event.weather!['temperature']}°C',
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                      ],
                    ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: event.type == 'Public'
                      ? Colors.greenAccent
                      : Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  event.type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onTap: () {
                if (event.error != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Erreur: Impossible de charger les détails météo pour "${event.name}".',
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Voir les détails de "${event.name}"'),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}
