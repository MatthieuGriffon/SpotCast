import 'package:flutter/material.dart';

class WeatherInfoCard extends StatelessWidget {
  final double temperature;
  final String description;
  final String iconCode;

  const WeatherInfoCard({
    super.key,
    required this.temperature,
    required this.description,
    required this.iconCode,
  });

    @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image de l'icône météo
            Image.network(
              'https://openweathermap.org/img/wn/$iconCode@2x.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 16),

            // Utilisation de Flexible pour éviter le dépassement
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Température: ${temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${description[0].toUpperCase()}${description.substring(1)}',
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
