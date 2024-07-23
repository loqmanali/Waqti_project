import 'package:flutter/material.dart';

class ErrorWidgetApp extends StatelessWidget {
  const ErrorWidgetApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('An error occurred $message'),
      ),
    );
  }
}
