import 'package:flutter/material.dart';

class PhoneSignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const PhoneSignInButton({super.key, required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
        onPressed: onPressed,
        child: const Text('Phone Sign In')
    );
  }
}
