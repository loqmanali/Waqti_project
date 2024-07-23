import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/hospital.dart';
import '../widgets/footer_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/hospital_list_view.dart';

class HospitalListPage extends StatelessWidget {
  final bool isLoading;
  final Position? userLocation;
  final List<Hospital> hospitals;
  final Function(Hospital) onHospitalSelected;

  const HospitalListPage({
    super.key,
    required this.isLoading,
    required this.userLocation,
    required this.hospitals,
    required this.onHospitalSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : userLocation == null
              ? const Center(child: Text('Error getting location'))
              : HospitalListView(
            hospitals: hospitals,
            userLocation: userLocation!,
            onHospitalSelected: onHospitalSelected,
          ),
        ),
        const FooterWidget(),
      ],
    );
  }
}
