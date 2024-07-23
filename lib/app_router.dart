import 'package:flutter/material.dart';
import 'package:waqti/main.dart';
import 'package:waqti/splash_page.dart';
import 'conferm_screen/conferm_screen.dart';
import 'auth/pages/login_screen.dart';
import 'auth/pages/signup_screen.dart';

class AppRouter {

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouterName.splash:
        return MaterialPageRoute(
          builder: (context) => const SplashPage(),
        );
      case RouterName.login:
        return MaterialPageRoute(
          builder: (context) => const SignInPage(),
        );
      case RouterName.signup:
        return MaterialPageRoute(builder: (context) => const SignUpPage());
      case RouterName.hospitals:
        return MaterialPageRoute(builder: (context) => const HospitalsPage());

      default:
        return MaterialPageRoute(builder: (context) => const UnknownScreen());
    }
  }
}

class RouterName {
  static const String home = '/';
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String hospitals = '/hospitals';
}

