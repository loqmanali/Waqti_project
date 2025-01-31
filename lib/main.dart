import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waqti/conferm_screen.dart';
import 'package:waqti/login_screen.dart';
import 'package:waqti/signup_screen.dart';
import 'package:waqti/splash_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashPage(),
      routes: {
        '/login': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/hospitals': (context) => const HospitalsPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => const SignInPage());
        }
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const UnknownScreen());
      },
    );
  }
}

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unknown Route')),
      body: const Center(
        child: Text('Unknown Route'),
      ),
    );
  }
}
