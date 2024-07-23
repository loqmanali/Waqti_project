import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/hospital.dart';

class HospitalTile extends StatelessWidget {
  final Hospital hospital;
  final int index;
  final Position userLocation;
  final VoidCallback onTap;

  const HospitalTile({
    super.key,
    required this.hospital,
    required this.index,
    required this.userLocation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double hospitalLat = 24.774265 + index * 0.01;
    final double hospitalLong = 46.738586 + index * 0.01;
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      hospitalLat,
      hospitalLong,
    );
    final travelTime = (distance / 500).ceil();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(hospital.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: hospital.crowdLevel / 20000,
              color: _getCrowdLevelColor(hospital.crowdLevel),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Text('Crowd Level: ${hospital.crowdLevel.toStringAsFixed(2)}'),
            Text('Distance: ${(distance / 1000).toStringAsFixed(2)} km'),
            Text('Travel Time: $travelTime min'),
          ],
        ),
      ),
    );
  }

  Color _getCrowdLevelColor(double crowdLevel) {
    if (crowdLevel < 5000) return Colors.green;
    if (crowdLevel < 10000) return Colors.yellow;
    return Colors.red;
  }
}
