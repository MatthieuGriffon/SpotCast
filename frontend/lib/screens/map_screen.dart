import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String spotName;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.spotName,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.spotName),
        backgroundColor: const Color(0xFF1B3A57),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('spot'),
            position: LatLng(widget.latitude, widget.longitude),
            infoWindow: InfoWindow(
              title: widget.spotName,
            ),
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
