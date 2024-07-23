import 'package:flutter/material.dart';

class ConfirmationButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const ConfirmationButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == Colors.red ? Colors.white : Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }
}
