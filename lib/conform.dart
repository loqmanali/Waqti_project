import 'package:flutter/material.dart';
import 'package:waqti/conferm_screen.dart';
import 'package:waqti/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReservationConfirmedPage(),
    );
  }
}

class ReservationConfirmedPage extends StatelessWidget {
  const ReservationConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper Rectangle with search bar and notifications icon
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
                          // Navigate or perform action for notifications
                        },
                        icon: const Icon(Icons.person),
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {
                          // Navigate or perform action for profile
                        },
                        icon: const Icon(Icons.notifications),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check_circle,
                    size: 40,
                    color: Color(0xFF8BE0C1),
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing
              ],
            ),
          ),

          // Confirmation Message Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Your reservation has been successfully confirmed',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'To view your reservation, go to my reservations page',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
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
                    // Navigate to chat bot or perform chat bot action
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsPage()));
                  },
                  icon: const Icon(Icons.home),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to profile or perform profile action
                  },
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
}
