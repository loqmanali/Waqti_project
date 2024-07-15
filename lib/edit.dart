// ignore_for_file: avoid_print, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waqti/chatbot.dart'; 

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  // Use a fixed user ID for testing
  final String testUserId = 'Stru6t9pfEX4mtuOamFF';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Retrieve user document from Firestore using testUserId
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(testUserId).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Update state with user data
        setState(() {
          _fullNameController.text = userDoc['fullName'];
          _idController.text = userDoc['id'];
          _phoneNumberController.text = userDoc['phoneNumber'];
        });
      } else {
        // Handle case where user document does not exist
        print('User document does not exist');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data: User document does not exist')),
        );
      }
    } catch (e) {
      // Handle errors
      print('Failed to load user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _saveUserData() async {
    try {
      // Update user document in Firestore with new data
      await FirebaseFirestore.instance.collection('users').doc(testUserId).update({
        'fullName': _fullNameController.text.trim(),
        'id': _idController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
      });

      // Show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      // Handle errors
      print('Failed to update profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: _saveUserData,
            icon: const Icon(Icons.save, color: Colors.black),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upper Section with rounded bottom
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF8BE0C1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF8BE0C1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Edit Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Details Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your ID:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Enter your ID',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Phone Number:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Enter your phone number',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF8BE0C1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                // Navigate to home
              },
              icon: const Icon(Icons.home),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBotPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}



//-----------------------------------------


/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waqti/chatbot.dart'; // Replace with your chatbot import if different

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  String? userId;

  @override
  void initState() {
    super.initState();
    // Ensure user is logged in and get user ID
    _checkUser();
  }

  Future<void> _checkUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Navigate to login page if user is not logged in
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      setState(() {
        userId = user.uid;
      });
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    if (userId == null) {
      return;
    }

    try {
      // Retrieve user document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      // Check if the document exists
      if (userDoc.exists) {
        // Update state with user data
        setState(() {
          _fullNameController.text = userDoc['fullName'] ?? '';
          _idController.text = userDoc['id'] ?? '';
          _phoneNumberController.text = userDoc['phoneNumber'] ?? '';
        });
      } else {
        // Handle case where user document does not exist
        print('User document does not exist');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data: User document does not exist')),
        );
      }
    } catch (e) {
      // Handle errors
      print('Failed to load user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    }
  }

  Future<void> _saveUserData() async {
    if (userId == null) {
      return;
    }

    try {
      // Update user document in Firestore with new data
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fullName': _fullNameController.text.trim(),
        'id': _idController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
      });

      // Show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      // Handle errors
      print('Failed to update profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: _saveUserData,
            icon: const Icon(Icons.save, color: Colors.black),
          ),
        ],
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Upper Section with rounded bottom
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF8BE0C1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF8BE0C1),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Edit Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile Details Section
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your ID:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Enter your ID',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Enter your name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Phone Number:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      border: InputBorder.none,
                      hintText: 'Enter your phone number',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Color(0xFF8BE0C1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
              icon: const Icon(Icons.person),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                // Navigate to home
              },
              icon: const Icon(Icons.home),
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBotPage()),
                );
              },
              icon: const Icon(Icons.chat_bubble),
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
*/


//-----------------------------------

