import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:waqti/auth/widgets/error_widget.dart';
import '../../conferm_screen/conferm_screen.dart';
import 'dart:convert';
import 'package:waqti/auth/pages/signup_screen.dart';

import '../widgets/sign_in_form.dart';

// class SignInPage extends StatefulWidget {
//   const SignInPage({super.key});
//
//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }
//
// class _SignInPageState extends State<SignInPage> {
//   void _navigateToHospitals(BuildContext context) {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const HospitalsPage()),
//     );
//   }
//
//   void _navigateToSignUp(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(builder: (context) => const SignUpPage()),
//     );
//   }
//
//   bool isLoading = false;
//
//   Future<void> _signInWithCredentials(
//     BuildContext context,
//     String identifier,
//     String password,
//   ) async {
//     setState(() {
//       isLoading = true;
//     });
//     print('isLoading = $isLoading');
//     try {
//       QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .where('phoneNumber', isEqualTo: identifier)
//           .get();
//
//       if (querySnapshot.docs.isEmpty) {
//         querySnapshot = await FirebaseFirestore.instance
//             .collection('users')
//             .where('id', isEqualTo: identifier)
//             .get();
//       }
//
//       if (querySnapshot.docs.isEmpty) {
//         // ignore: use_build_context_synchronously
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text('User not found.')));
//         return;
//       }
//
//       // DocumentSnapshot userDoc = querySnapshot.docs.first;
//       // String storedPassword = userDoc['password'];
//
//       // String hashedPassword = sha256.convert(utf8.encode(password)).toString();
//       //
//       // if (hashedPassword != storedPassword) {
//       //   // ignore: use_build_context_synchronously
//       //   ScaffoldMessenger.of(context)
//       //       .showSnackBar(const SnackBar(content: Text('Incorrect password.')));
//       //   return;
//       // }
//
//       setState(() {
//         isLoading = false;
//       });
//       print('isLoading after sign-in = $isLoading');
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Sign-in successful!')));
//       // ignore: use_build_context_synchronously
//       _navigateToHospitals(context);
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       print('isLoading error sign-in = $isLoading');
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Sign-in failed: $e')));
//     }
//   }
//
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   final TextEditingController identifierController =
//   TextEditingController(text: '+6281295486105');
//   final TextEditingController passwordController =
//   TextEditingController(text: '123456789');
//
//   phoneSignIn() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//
//     setState(() {
//       isLoading = true;
//     });
//     await auth.verifyPhoneNumber(
//       phoneNumber: identifierController.text,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         // ANDROID ONLY!
//
//         // Sign the user in (or link) with the auto-generated credential
//         await auth.signInWithCredential(credential);
//       },
//       verificationFailed: (FirebaseAuthException error) {
//         if (error.code == 'invalid-phone-number') {
//           print('The provided phone number is not valid.');
//         }
//         print(error.message);
//         setState(() {
//           isLoading = false;
//         });
//       },
//       codeSent: (String verificationId, int? forceResendingToken) async {
//         // Update the UI - wait for the user to enter the SMS code
//         String smsCode = '123456';
//
//         // Create a PhoneAuthCredential with the code
//         PhoneAuthCredential credential = PhoneAuthProvider.credential(
//             verificationId: verificationId, smsCode: smsCode);
//
//         // Sign the user in (or link) with the credential
//         await auth.signInWithCredential(credential);
//         setState(() {
//           isLoading = false;
//         });
//         _navigateToHospitals(context);
//         // _updateUserProfile();
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }
//
//   Future<void> _updateUserProfile() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'fullName': 'Loqman Ali',
//         'id': '12345',
//         'phoneNumber': user.phoneNumber,
//         'uId': user.uid,
//         'password': '123456789',
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return const Scaffold(
//                 body: Center(
//                   child: Text('An error occurred'),
//                 ),
//               );
//             } else if (snapshot.hasData) {
//               return const HospitalsPage();
//             } else {
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     Container(
//                       height: 200,
//                       decoration: const BoxDecoration(
//                         color: Color(0xFF8BE0C1),
//                         borderRadius:
//                             BorderRadius.vertical(bottom: Radius.circular(30)),
//                       ),
//                       child: const Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Sign In',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             SizedBox(height: 20),
//                             Text(
//                               'Welcome back!',
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 70),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           const Text(
//                             'ID or Phone Number',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: identifierController,
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: const Color(0xFFDCEAF3),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Password',
//                             style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: passwordController,
//                             obscureText: true,
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: const Color(0xFFDCEAF3),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           isLoading == true
//                               ? const Center(child: CircularProgressIndicator())
//                               : ElevatedButton(
//                                   onPressed: () {
//                                     // _signInWithCredentials(
//                                     //     context,
//                                     //     identifierController.text.trim(),
//                                     //     passwordController.text.trim());
//                                     phoneSignIn();
//                                     // authService.signInWithId(identifierController.text.trim(), passwordController.text.trim());
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: const Color(0xFF8BE0C1),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16, horizontal: 50),
//                                   ),
//                                   child: const Text(
//                                     'Sign In',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 18,
//                                     ),
//                                   ),
//                                 ),
//                           const SizedBox(height: 16),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Text(
//                                 "Don't have an account? ",
//                                 style: TextStyle(color: Colors.black),
//                               ),
//                               TextButton(
//                                 onPressed: () => _navigateToSignUp(context),
//                                 child: const Text(
//                                   'Sign Up',
//                                   style: TextStyle(color: Color(0xFF06929B)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           isLoading == true ? const Center(child: CircularProgressIndicator()) : ElevatedButton(
//                               onPressed: phoneSignIn,
//                               // onPressed: authService.phoneSignIn,
//                               child: const Text('Phone Sign In')),
//                           StreamBuilder(
//                             stream: FirebaseFirestore.instance
//                                 .collection('users')
//                                 .get()
//                                 .asStream(),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return const Center(
//                                     child: CircularProgressIndicator());
//                               }
//                               final docs = snapshot.data!.docs;
//                               return Column(
//                                 children: docs
//                                     .map((doc) => Text(doc['fullName']))
//                                     .toList(),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           }),
//     );
//   }
// }

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController emailOrIdController =
      TextEditingController();
  final TextEditingController passwordController =
      TextEditingController(text: '123456789');

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return ErrorWidgetApp(
              message: snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            return const HospitalsPage();
          } else {
            return SignInForm(
              isLoading: isLoading,
              identifierController: emailOrIdController,
              passwordController: passwordController,
              onSignIn: emailOrIdSignIn,
              onSignUp: () => _navigateToSignUp(context),
            );
          }
        },
      ),
    );
  }

  void _navigateToSignUp(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  // Future<void> phoneSignIn() async {
  //   setState(() => isLoading = true);
  //
  //   try {
  //     // Check if the phone number is registered
  //     QuerySnapshot query = await _firestore
  //         .collection('users')
  //         .where('phoneNumber', isEqualTo: phoneController.text)
  //         .get();
  //
  //     QuerySnapshot queryId = await _firestore
  //         .collection('users')
  //         .where('id', isEqualTo: phoneController.text)
  //         .get();
  //
  //     if (query.docs.isEmpty && queryId.docs.isEmpty) {
  //       _showErrorSnackBar(context, 'Phone number not registered');
  //       setState(() => isLoading = false);
  //       return;
  //     } else {
  //       // Get the user document
  //       DocumentSnapshot userDoc = query.docs.first;
  //
  //       final String storedPassword = userDoc['password'];
  //       final String password = passwordController.text;
  //
  //       String hashedPassword =
  //           sha256.convert(utf8.encode(password)).toString();
  //
  //       // Verify the password
  //       // Note: In a real app, you should use proper password hashing
  //       if (hashedPassword != storedPassword) {
  //         _showErrorSnackBar(context, 'Incorrect password');
  //         setState(() => isLoading = false);
  //         return;
  //       }
  //
  //       // Sign in the user
  //       await _auth.verifyPhoneNumber(
  //         phoneNumber: phoneController.text,
  //         verificationCompleted: _onVerificationCompleted,
  //         verificationFailed: _onVerificationFailed,
  //         codeSent: _onCodeSent,
  //         codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
  //       );
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     _showErrorSnackBar(context, 'Phone sign-in failed: $e');
  //   }
  // }
  //
  // void _onVerificationCompleted(PhoneAuthCredential credential) async {
  //   print('Phone sign-in successful');
  //   await _auth.signInWithCredential(credential);
  //   setState(() => isLoading = false);
  //   _navigateToHospitals(context);
  // }
  //
  // void _onVerificationFailed(FirebaseAuthException error) {
  //   print(error.message);
  //   setState(() => isLoading = false);
  //   _showErrorSnackBar(context, 'Verification failed: ${error.message}');
  // }
  //
  // void _onCodeSent(String verificationId, int? forceResendingToken) async {
  //   // For simplicity, we're using a hardcoded SMS code. In a real app, you'd prompt the user to enter the code.
  //   String smsCode = '123456';
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId, smsCode: smsCode);
  //   await _auth.signInWithCredential(credential);
  //   setState(() => isLoading = false);
  //   _navigateToHospitals(context);
  // }
  //
  // void _onCodeAutoRetrievalTimeout(String verificationId) {
  //   // Handle auto-retrieval timeout
  // }


  Future<void> emailOrIdSignIn() async {
    setState(() => isLoading = true);

    try {
      String emailOrId = emailOrIdController.text.trim();
      String password = passwordController.text;

      // Check if the input is an email or ID
      bool isEmail = emailOrId.contains('@');

      // Query Firestore for the user
      QuerySnapshot query;
      if (isEmail) {
        query = await _firestore
            .collection('users')
            .where('email', isEqualTo: emailOrId)
            .get();
      } else {
        query = await _firestore
            .collection('users')
            .where('id', isEqualTo: emailOrId)
            .get();
      }

      if (query.docs.isEmpty) {
        _showErrorSnackBar(context, 'User not found');
        setState(() => isLoading = false);
        return;
      }

      // Get the user document
      DocumentSnapshot userDoc = query.docs.first;

      final String storedPassword = userDoc['password'];
      String hashedPassword = sha256.convert(utf8.encode(password)).toString();

      // Verify the password
      if (hashedPassword != storedPassword) {
        _showErrorSnackBar(context, 'Incorrect password');
        setState(() => isLoading = false);
        return;
      }

      // Sign in the user
      if (isEmail) {
        await _signInWithEmail(emailOrId, password);
      }

      setState(() => isLoading = false);
      _navigateToHospitals(context);
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar(context, 'Sign-in failed: $e');
    }
  }

  Future<void> _signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        throw 'Wrong password provided for that user.';
      } else {
        throw e.message ?? 'An error occurred during sign in.';
      }
    }
  }

  // Future<void> _signInWithCustomToken(String uid) async {
  //   try {
  //     // This part requires a server-side function to generate a custom token
  //     // For demonstration, we're using a placeholder
  //     String customToken = await _getCustomTokenFromServer(uid);
  //     await _auth.signInWithCustomToken(customToken);
  //   } catch (e) {
  //     throw 'Failed to sign in with ID: $e';
  //   }
  // }
  //
  // Future<String> _getCustomTokenFromServer(String uid) async {
  //   // In a real application, you would make an API call to your server
  //   // The server would then use the Firebase Admin SDK to generate a custom token
  //   // For this example, we're just returning a placeholder
  //   // throw UnimplementedError('Custom token generation not implemented');
  //   return 'custom-token-$uid';
  // }

  void _navigateToHospitals(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HospitalsPage()),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class UsersList extends StatelessWidget {
  const UsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return Column(
          children: docs.map((doc) => Text(doc['fullName'])).toList(),
        );
      },
    );
  }
}
