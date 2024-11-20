import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class SelectLocationEventScreen extends StatefulWidget {
  const SelectLocationEventScreen({super.key});

  @override
  State<SelectLocationEventScreen> createState() =>
      _SelectLocationEventScreenState();
}

class _SelectLocationEventScreenState extends State<SelectLocationEventScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  LatLng? _selectedPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }


Future<String?> _getAddressFromCoordinates(LatLng coordinates) async {
  const String apiKey = 'AIzaSyDpc8C2lW3WSsscTq_imvir_3ND5dhBPCU';
  final String url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      } else {
        print('Erreur dans la réponse : ${data['status']}');
        print('Détails de la réponse : $data');
      }
    } else {
      print('Erreur HTTP : ${response.statusCode}');
      print('Réponse : ${response.body}');
    }
  } catch (e) {
    print('Exception lors de la récupération de l\'adresse : $e');
  }

  return null; // Retourne null en cas d'échec
}


  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Services de localisation désactivés');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Permissions refusées en permanence');
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedPosition = LatLng(position.latitude, position.longitude);
        _markers.add(Marker(
          markerId: const MarkerId('user-location'),
          position: _selectedPosition!,
          infoWindow: const InfoWindow(title: 'Position actuelle'),
        ));
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur localisation : $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedPosition = position;
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('selected-location'),
        position: position,
        infoWindow: const InfoWindow(title: 'Position sélectionnée'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélectionnez un emplacement'),
        backgroundColor: const Color(0xFF1B3A57),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Retourne sans sélectionner de position
            },
            child: const Text(
              'Annuler',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    _selectedPosition ?? const LatLng(48.8566, 2.3522), // Paris
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
              },
              markers: _markers,
              onTap: _onMapTap,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
     floatingActionButton: FloatingActionButton.extended(
  onPressed: () async {
    if (_selectedPosition == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner un emplacement.'),
          ),
        );
      }
      return;
    }

    // Récupérer l'adresse
    String? address = await _getAddressFromCoordinates(_selectedPosition!);

    // Vérifiez si le widget est monté avant d'utiliser `context`
    if (!mounted) return;

    if (address != null) {
      Navigator.pop(context, address); // Renvoie l'adresse lisible
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de récupérer l\'adresse.'),
        ),
      );
    }
  },
  label: const Text('Confirmer'),
  icon: const Icon(Icons.check),
),

    );
  }
}
