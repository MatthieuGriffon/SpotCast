import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/common/weather_info_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  final Map<String, dynamic> spot;

  const MapScreen({super.key, required this.spot});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int _selectedIndex = 1;
  bool isFavorite = false;

  // Variables pour stocker les données météo
  Map<String, dynamic>? weatherData;
  bool isLoadingWeather = true;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadWeatherData();
  }

  // Fonction pour vérifier et demander l'accès à la localisation
  Future<void> _checkLocationPermission() async {
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.location.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  // Fonction pour récupérer la météo
  Future<void> _loadWeatherData() async {
    try {
      weatherData = await fetchWeather(
        double.parse(widget.spot['latitude'].toString()),
        double.parse(widget.spot['longitude'].toString()),
      );
    } catch (e) {
      print('Erreur lors de la récupération des données météo: $e');
    } finally {
      setState(() {
        isLoadingWeather = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    const String apiKey = '898b965d06a496f870aeb23876747c22';
    final Uri url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&lang=fr&appid=$apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données météo: $e');
      rethrow;
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

  // Fonction utilitaire pour récupérer la route en fonction de l'index
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
    final spot = widget.spot;
    final double mapHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          spot['name'] ?? 'Spot',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris',
                  ),
                ),
              );
            },
          ),
        ],
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              height: mapHeight,
              child: GoogleMap(
                onMapCreated: (controller) => mapController = controller,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    double.parse(spot['latitude'].toString()),
                    double.parse(spot['longitude'].toString()),
                  ),
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('spot'),
                    position: LatLng(
                      double.parse(spot['latitude'].toString()),
                      double.parse(spot['longitude'].toString()),
                    ),
                    infoWindow: InfoWindow(title: spot['name']),
                  ),
                },
              ),
            ),
          ),

          buildWeatherSection(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => openGoogleMaps(
                double.parse(spot['latitude'].toString()),
                double.parse(spot['longitude'].toString()),
              ),
              icon: const Icon(Icons.directions, color: Colors.white),
              label: const Text(
                'Obtenir un itinéraire',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  Widget buildWeatherSection() {
    if (isLoadingWeather) {
      return const Center(child: CircularProgressIndicator());
    }
    if (weatherData == null) {
      return const Text('Aucune donnée météo disponible');
    }

    final double temperature = weatherData!['main']['temp'];
    final String description = weatherData!['weather'][0]['description'];
    final String iconCode = weatherData!['weather'][0]['icon'];

    return WeatherInfoCard(
      temperature: temperature,
      description: description,
      iconCode: iconCode,
    );
  }

  Future<void> openGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Impossible d\'ouvrir Google Maps');
    }
  }
}
