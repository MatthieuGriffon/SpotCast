import 'package:flutter/material.dart';
import 'package:frontend/models/event.dart';



class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informations de base
              Text(
                event.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('${event.date} à ${event.time}'),
              const SizedBox(height: 8),
              Text('Lieu : ${event.location}'),
              const SizedBox(height: 16),

              // Prévisions météo
              if (event.weather != null) ...[
                const Text('Prévisions météo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (event.weather!['icon'] != null)
                      Image.network(
                        'https://openweathermap.org/img/wn/${event.weather!['icon']}@2x.png',
                        width: 50,
                        height: 50,
                      ),
                    const SizedBox(width: 16),
                    Text(
                      '${event.weather!['description']} - ${event.weather!['temperature']}°C',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Description complète
              const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(event.description),

              const SizedBox(height: 16),

              // Liste des participants
              const Text('Participants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (event.participants.isEmpty)
                const Text('Aucun participant pour le moment.')
              else
                ...event.participants.map((participant) => Text('- $participant')).toList(),

              const SizedBox(height: 16),

              // Boutons d'interaction
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour s'inscrire
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('S\'inscrire'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logique pour partager
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Partager'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
