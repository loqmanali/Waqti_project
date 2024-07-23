import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waqti/app_router.dart';
import 'firebase_options.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const SplashPage(),
//       routes: {
//         '/login': (context) => const SignInPage(),
//         '/signup': (context) => const SignUpPage(),
//         '/hospitals': (context) => const HospitalsPage(),
//       },
//       onGenerateRoute: (settings) {
//         if (settings.name == '/login') {
//           return MaterialPageRoute(builder: (context) => const SignInPage());
//         }
//         return null;
//       },
//       onUnknownRoute: (settings) {
//         return MaterialPageRoute(builder: (context) => const UnknownScreen());
//       },
//     );
//   }
// }

late String initialRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      initialRoute = RouterName.hospitals;
    } else {
      initialRoute = RouterName.splash;
    }
  });

  runApp(MyApp(appRouter: AppRouter()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      onGenerateRoute: appRouter.generateRoute,
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
