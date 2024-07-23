import 'package:flutter/material.dart';
// Import your HospitalScreen

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({super.key});
//
//   @override
//   // ignore: library_private_types_in_public_api
//   _SignUpPageState createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _phoneNumberController =
//       TextEditingController(text: '+6281295486104');
//   final TextEditingController _passwordController = TextEditingController();
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   bool isLoading = false;
//
//   Future _onSignUp() async {
//     String fullName = _fullNameController.text.trim();
//     String id = _idController.text.trim();
//     String phoneNumber = _phoneNumberController.text.trim();
//     String password = _passwordController.text.trim();
//
//     setState(() {
//       isLoading = true;
//     });
//
//     if (fullName.isEmpty ||
//         id.isEmpty ||
//         phoneNumber.isEmpty ||
//         password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all fields')),
//       );
//       return;
//     }
//
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       if(_auth.currentUser?.phoneNumber == phoneNumber) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Phone number already registered')),
//         );
//       } else {
//         await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           // ANDROID ONLY!
//
//           // Sign the user in (or link) with the auto-generated credential
//           await _auth.signInWithCredential(credential);
//         },
//         verificationFailed: (FirebaseAuthException error) {
//           if (error.code == 'invalid-phone-number') {
//             print('The provided phone number is not valid.');
//           }
//           print(error.message);
//         },
//         codeSent: (String verificationId, int? forceResendingToken) async {
//           // Update the UI - wait for the user to enter the SMS code
//           String smsCode = '123456';
//
//           // Create a PhoneAuthCredential with the code
//           PhoneAuthCredential credential = PhoneAuthProvider.credential(
//               verificationId: verificationId, smsCode: smsCode);
//
//           // Sign the user in (or link) with the credential
//           await _auth.signInWithCredential(credential);
//           // _updateUserProfile();
//           addUser(
//             fullName: fullName,
//             id: id,
//             phoneNumber: phoneNumber,
//             password: password,
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {},
//       );
//       }
//
//       setState(() {
//         isLoading = false;
//       });
//
//       // Navigate to HospitalScreen after successful sign-up
//       // ignore: use_build_context_synchronously
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       // ignore: use_build_context_synchronously
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to register user: $e')),
//       );
//     }
//   }
//
//   addUser({
//     required String fullName,
//     required String id,
//     required String phoneNumber,
//     required String password,
//   }) async {
//     // Hash the password before storing it
//     String hashedPassword = sha256.convert(utf8.encode(password)).toString();
//     User? user = _auth.currentUser;
//     if (user != null) {
//       await _firestore.collection('users').doc(user.uid).set({
//         'fullName': fullName,
//         'id': id,
//         'uId': user.uid,
//         'phoneNumber': phoneNumber,
//         'password': hashedPassword,
//       }).then((value) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const HospitalsPage()),
//         );
//       }).catchError((error) {
//         setState(() {
//           isLoading = false;
//         });
//         print('Error adding user: $error');
//       });
//     }
//     // ignore: use_build_context_synchronously
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('User registered successfully!')),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         // title: const Text(
//         //   'Sign Up',
//         //   style: TextStyle(
//         //     color: Colors.black,
//         //     fontSize: 24,
//         //     fontWeight: FontWeight.bold,
//         //   ),
//         // ),
//         backgroundColor: const Color(0xFF8BE0C1),
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(30),
//           ),
//         ),
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(65),
//           child: Padding(
//             padding: EdgeInsets.symmetric(vertical: 20.0),
//             child: Text(
//               'Sign Up',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Container(
//             //   height: 200,
//             //   decoration: const BoxDecoration(
//             //     color: Color(0xFF8BE0C1),
//             //     borderRadius:
//             //         BorderRadius.vertical(bottom: Radius.circular(30)),
//             //   ),
//             //   child: const Center(
//             //     child: Text(
//             //       'Sign Up',
//             //       style: TextStyle(
//             //         color: Colors.black,
//             //         fontSize: 24,
//             //         fontWeight: FontWeight.bold,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             // const SizedBox(height: 70),
//             const SizedBox(height: 70),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text(
//                     'Full Name',
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _fullNameController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFFDCEAF3),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'ID',
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _idController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFFDCEAF3),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Phone Number',
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _phoneNumberController,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFFDCEAF3),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Password',
//                     style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: const Color(0xFFDCEAF3),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   isLoading
//                       ? const Center(child: CircularProgressIndicator())
//                       : ElevatedButton(
//                           onPressed: _onSignUp,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF8BE0C1),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 16, horizontal: 50),
//                           ),
//                           child: const Text(
//                             'Sign Up',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import '../../widgets/custom_app_bar.dart';
import '../widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Sign Up'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SignUpForm(),
        ),
      ),
    );
  }
}


