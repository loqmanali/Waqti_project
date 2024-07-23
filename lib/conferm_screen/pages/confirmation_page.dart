import 'package:flutter/material.dart';

import '../widgets/confirmation_button.dart';
import '../widgets/header_widget.dart';
import '../widgets/hospital_details_widget.dart';

class ConfirmationPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onConfirm;
  final String hospitalName;
  final String hospitalAddress;
  final String hospitalContact;

  const ConfirmationPage({
    super.key,
    required this.onBack,
    required this.onConfirm,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.hospitalContact,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  HospitalDetailsWidget(
                    hospitalName: hospitalName,
                    hospitalAddress: hospitalAddress,
                    hospitalContact: hospitalContact,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConfirmationButton(text: 'Back', color: Colors.red, onPressed: onBack),
                      ConfirmationButton(text: 'Confirm', color: const Color(0xFF8BE0C1), onPressed: onConfirm),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}