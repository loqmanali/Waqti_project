import 'package:flutter/material.dart';

class HospitalDetailsWidget extends StatelessWidget {
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalContact;

  const HospitalDetailsWidget({
    super.key,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalContact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Text(hospitalName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(hospitalAddress, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 20),
          Text(hospitalContact, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}
