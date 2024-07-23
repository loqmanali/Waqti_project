import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/hospital.dart';
import 'hospital_tile.dart';

class HospitalListView extends StatelessWidget {
  final List<Hospital> hospitals;
  final Position userLocation;
  final Function(Hospital) onHospitalSelected;

  const HospitalListView({
    super.key,
    required this.hospitals,
    required this.userLocation,
    required this.onHospitalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListView.builder(
          itemCount: hospitals.length,
          itemBuilder: (context, index) => HospitalTile(
            hospital: hospitals[index],
            index: index,
            userLocation: userLocation,
            onTap: () => onHospitalSelected(hospitals[index]),
          ),
        ),
      ),
    );
  }
}
