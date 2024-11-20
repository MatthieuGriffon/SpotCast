class Event {
  final String name;
  final String date;
  final String time;
  final String location;
  final double latitude;
  final double longitude;
  final String type;
  final String description;

  Map<String, dynamic>? weather; // Contient description, icon et temperature
  String? error;
  List<String> participants; // Liste des participants
// Pour gérer les erreurs de récupération météo

  Event({
    required this.name,
    required this.date,
    required this.time,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.participants,
    required this.type,
    this.weather,
    this.error,
  });
}
