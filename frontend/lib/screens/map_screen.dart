import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';

class MapScreen extends StatefulWidget {
  final Map<String, dynamic> spot;

  const MapScreen({
    super.key,
    required this.spot,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
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

  // Fonction pour ouvrir Google Maps avec un itinéraire
Future<void> openGoogleMaps(double latitude, double longitude) async {
  final Uri googleMapsUrl = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
  );

  // Utiliser `launchUrl` avec le mode approprié
  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(
      googleMapsUrl,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw Exception('Impossible d\'ouvrir Google Maps');
  }
}

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/spots');
        break;
      case 2:
        Navigator.pushNamed(context, '/groups');
        break;
      case 3:
        Navigator.pushNamed(context, '/events');
        break;
      case 4:
        Navigator.pushNamed(context, '/profile');
        break;
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
                      isFavorite ? 'Ajouté aux favoris' : 'Retiré des favoris'),
                ),
              );
            },
          ),
        ],
        backgroundColor: const Color(0xFF1B3A57),
      ),
      endDrawer: _buildDrawer(spot),
      body: Column(
        children: [
          // Afficher la carte
          Card(
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              height: mapHeight,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
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
                    infoWindow: InfoWindow(
                      title: spot['name'],
                    ),
                  ),
                },
              ),
            ),
          ),

          // Bouton pour ouvrir le Drawer en dessous de la carte
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: const Icon(Icons.info, color: Colors.white),
              label: const Text('Voir les détails',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {
                openGoogleMaps(
                  double.parse(widget.spot['latitude'].toString()),
                  double.parse(widget.spot['longitude'].toString()),
                );
              },
              icon: const Icon(Icons.directions, color: Colors.white),
              label: const Text(
                'Obtenir un itinéraire',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B3A57),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDrawer(Map<String, dynamic> spot) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1B3A57)),
            child: Text(
              spot['name'] ?? 'Spot',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: const Text('Description'),
            subtitle: Text(spot['description'] ?? 'No description available.'),
          ),
          ListTile(
            title: const Text('Type de poisson'),
            subtitle: Text(spot['fishType'] ?? 'Unknown'),
          ),
          ListTile(
            title: const Text('Location'),
            subtitle: Text(spot['location'] ?? 'Unknown'),
          ),
        ],
      ),
    );
  }
}
