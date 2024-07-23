import 'package:flutter/material.dart';

class SignUpPrompt extends StatelessWidget {
  final VoidCallback onSignUp;

  const SignUpPrompt({super.key, required this.onSignUp});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.black),
        ),
        TextButton(
          onPressed: onSignUp,
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Color(0xFF06929B)),
          ),
        ),
      ],
    );
  }
}
