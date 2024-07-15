import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart'; // For hashing passwords
import 'dart:convert'; // For UTF8 encoding

class VerificationPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String fullName;
  final String id;
  final String password;

  const VerificationPage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.fullName,
    required this.id,
    required this.password,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _codeController = TextEditingController();

  Future<void> _verifyCode() async {
    String smsCode = _codeController.text.trim();

    if (smsCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the verification code')),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      await _saveUserToFirestore();
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst); // Navigate back to the initial screen
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to verify code: $e')),
      );
    }
  }

  Future<void> _saveUserToFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String hashedPassword = sha256.convert(utf8.encode(widget.password)).toString();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fullName': widget.fullName,
        'id': widget.id,
        'phoneNumber': widget.phoneNumber,
        'password': hashedPassword,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User registered successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Color(0xFF8BE0C1),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: const Center(
                child: Text(
                  'Verify Code',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Verification Code',
                    style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFDCEAF3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _verifyCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BE0C1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
