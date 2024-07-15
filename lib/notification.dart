import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waqti/conferm_screen.dart';
import 'package:waqti/profile.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper Rectangle with notification icon
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF8BE0C1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      const Text(
                        'Notification',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48), // Placeholder for symmetry
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.notifications,
                    size: 40,
                    color: Color(0xFF8BE0C1),
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing
              ],
            ),
          ),

          // Notification Messages Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc('Stru6t9pfEX4mtuOamFF')
                      .collection('support_message')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final messages = snapshot.data!.docs;
                    List<Widget> messageWidgets = [];
                    for (var message in messages) {
                      final messageText = message['message'];
                      final adminResponse = message['adminResponse'] ?? 'No response yet';
                      final messageWidget = _buildNotificationMessage(messageText, adminResponse);
                      messageWidgets.add(messageWidget);
                    }
                    return ListView(
                      children: messageWidgets,
                    );
                  },
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          Container(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                  },
                  icon: const Icon(Icons.person),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsPage()));
                  },
                  icon: const Icon(Icons.home),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_bubble),
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationMessage(String userMessage, String adminResponse) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Message: $userMessage',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 10),
          Text(
            'Admin Response: $adminResponse',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
