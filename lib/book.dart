import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ReservationScreen(),
    );
  }
}

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  String fullName = '';
  String userId = '';
  String hospitalName = '';
  String bookingDate = 'Loading...';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      // Fixed document ID for testing
      String documentId = 'Stru6t9pfEX4mtuOamFF';

      // Get the user document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(documentId)
          .get();

      if (userDoc.exists) {
        // Get the first reservation document
        QuerySnapshot reservationsSnapshot = await userDoc.reference.collection('reservations').get();

        if (reservationsSnapshot.docs.isNotEmpty) {
          var reservationDoc = reservationsSnapshot.docs.first;

          setState(() {
            fullName = userDoc['fullName']?.toString() ?? '';
            userId = userDoc['id']?.toString() ?? '';
            hospitalName = reservationDoc['hospitalName']?.toString() ?? '';
            bookingDate = reservationDoc['timestamp']?.toDate().toString() ?? '';
          });
        } else {
          // Handle case where there are no reservations
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No reservations found for this user')),
          );
        }
      } else {
        // Handle case where the user document does not exist
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User document does not exist')),
        );
      }
    } catch (e) {
      // Handle error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Reservation'),
      ),
      body: Column(
        children: [
          // Upper Rectangle with checklist icon
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF8BE0C1),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context); // Navigate back logic
                        },
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                      ),
                      const Text(
                        'My Reservation',
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
                    Icons.checklist_outlined,
                    size: 40,
                    color: Color(0xFF8BE0C1),
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing
              ],
            ),
          ),

          // Reservation Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildReservationDetail('Your ID:', userId),
                    const SizedBox(height: 20),
                    _buildReservationDetail('Your Name:', fullName),
                    const SizedBox(height: 20),
                    _buildReservationDetail('Date:', bookingDate),
                    const SizedBox(height: 20),
                    _buildReservationDetail('Hospital Name:', hospitalName),
                    const SizedBox(height: 20),
                    _buildReservationDetail('Time Remaining:', '20min'),
                    const SizedBox(height: 50),
                    Center(
                      child: Image.asset('assets/Barcode.png'), // Replace with your barcode image asset
                    ),
                    const SizedBox(height: 10),
                    const Center(child: Text('1235')), // Replace with your barcode number or placeholder
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildReservationDetail(String label, String detail) {
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
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 5),
          Text(
            detail,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Container(
        height: 70.0,
        decoration: const BoxDecoration(
          color: Color(0xFF8BE0C1),
          boxShadow: [
            BoxShadow(
              color: Colors.white, // Change the shadow color here
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Stack(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.black, size: 30), // Adjust the size of the profile icon here
                  onPressed: () {
                    // Navigate to profile screen
                  },
                ),
                const SizedBox(width: 60), // Add spacing between icons
                IconButton(
                  icon: const Icon(Icons.headset_mic, color: Colors.black, size: 30), // Adjust the size of the headset icon here
                  onPressed: () {
                    // Navigate to chat bot screen
                  },
                ),
              ],
            ),
            Center(
              heightFactor: 0.5, // Adjust this value to move the circle up or down
              child: Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.home, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

