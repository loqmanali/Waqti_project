import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../conferm_screen/conferm_screen.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController =
  TextEditingController(text: '+6281295486104');
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isLoading = false;

  Future<void> _onSignUp() async {
    String fullName = _fullNameController.text.trim();
    String id = _idController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    if (!_validateInputs(fullName, id, email, password)) return;

    setState(() => isLoading = true);

    try {
      await _signUpUser(
        fullName: fullName,
        id: id,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      _showErrorSnackBar('Failed to register user: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _validateInputs(
      String fullName, String id, String email, String password) {
    if (fullName.isEmpty || id.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return false;
    }
    if (!_isValidEmail(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> _signUpUser({
    required String fullName,
    required String id,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _addUser(
        uid: userCredential.user!.uid,
        fullName: fullName,
        id: id,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      _navigateToHospitalsPage();
      _showSuccessSnackBar('User registered successfully!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showErrorSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _showErrorSnackBar('The account already exists for that email.');
      } else {
        _showErrorSnackBar(e.message ?? 'An error occurred during sign up.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred during sign up.');
    }
  }

  Future<void> _addUser({
    required String uid,
    required String fullName,
    required String id,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    String hashedPassword = sha256.convert(utf8.encode(password)).toString();
    await _firestore.collection('users').doc(uid).set({
      'fullName': fullName,
      'id': id,
      'uId': uid,
      'email': email,
      'password': hashedPassword,
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  void _navigateToHospitalsPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HospitalsPage()),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 70),
        CustomTextField(
          controller: _fullNameController,
          label: 'Full Name',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _emailController,
          label: 'Email',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _idController,
          label: 'ID',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _phoneNumberController,
          label: 'Phone Number',
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: _passwordController,
          label: 'Password',
          obscureText: true,
        ),
        const SizedBox(height: 16),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomButton(
          onPressed: _onSignUp,
          text: 'Sign Up',
        ),
      ],
    );
  }
}
