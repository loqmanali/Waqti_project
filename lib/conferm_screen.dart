//ZGWMk8ubTYcVVzAXd55lkhtowMj1
/*
import 'package:flutter/material.dart';
import 'package:waqti/conform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification.dart';
import 'profile.dart';
import 'chatbot.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  bool _isLoading = true;
  Position? _userLocation;
  bool _showConfirmation = false;
  String? _selectedHospitalName;
  String? _selectedHospitalAddress;
  String? _selectedHospitalContact;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _isLoading = false;
        _userLocation = position;
      });
    } on PlatformException {
      setState(() {
        _isLoading = false;
        _userLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showConfirmation ? _buildConfirmationPage() : _buildHospitalsList(),
    );
  }

  Widget _buildHospitalsList() {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userLocation == null
                  ? const Center(child: Text('Error getting location'))
                  : Padding(
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
                            Expanded(
                              child: Column(
                                children: [
                                  _buildHospitalTile('Hospital A', _userLocation!, 10.774265, 22.738586),
                                  const SizedBox(height: 70),
                                  _buildHospitalTile('Hospital B', _userLocation!, 24.774265, 46.738586),
                                  const SizedBox(height: 70),
                                  _buildHospitalTile('Hospital C', _userLocation!, 24.774265, 46.738586),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotPage()));
                },
                icon: const Icon(Icons.chat_bubble),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsPage()));
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalTile(String hospitalName, Position userLocation, double hospitalLat, double hospitalLong) {
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      hospitalLat,
      hospitalLong,
    );

    final travelTime = (distance / 500).ceil(); // Assuming average speed of 500 meters per minute

    return GestureDetector(
      onTap: () {
        setState(() {
          _showConfirmation = true;
          _selectedHospitalName = hospitalName;
          _selectedHospitalAddress = '123 Main St, City'; // Replace with actual address
          _selectedHospitalContact = 'Contact: (123) 456-7890'; // Replace with actual contact
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Row(
          children: [
            const Icon(Icons.local_hospital),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(distance / 1000).toStringAsFixed(2)} km - $travelTime min',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // Navigate or perform action for notifications
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
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
                  _buildHospitalDetails(
                    _selectedHospitalName ?? 'Hospital Name',
                    _selectedHospitalAddress ?? 'Hospital Address',
                    _selectedHospitalContact ?? 'Hospital Contact',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmation = false; // Back button logic
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _createReservation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BE0C1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalDetails(String hospitalName, String address, String contact) {
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
            hospitalName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            address,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            contact,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          // Add more details here as needed
        ],
      ),
    );
  }

  void _createReservation() async {
    if (_selectedHospitalName != null &&
        _selectedHospitalAddress != null &&
        _selectedHospitalContact != null) {
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('reservations')
              .add({
            'hospitalName': _selectedHospitalName,
            'hospitalAddress': _selectedHospitalAddress,
            'hospitalContact': _selectedHospitalContact,
            'timestamp': FieldValue.serverTimestamp(),
          });

          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const ReservationConfirmedPage()),
          );
        }
      } catch (e) {
        // Handle error as needed
      }
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: HospitalsPage(),
  ));
}
*/



//---------------------------------------------

/*
import 'package:flutter/material.dart';
import 'package:waqti/conform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'notification.dart';
import 'profile.dart';
import 'chatbot.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  bool _isLoading = true;
  Position? _userLocation;
  bool _showConfirmation = false;
  String? _selectedHospitalName;
  String? _selectedHospitalAddress;
  String? _selectedHospitalContact;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Use a fixed user ID for testing
  final String testUserId = 'Stru6t9pfEX4mtuOamFF';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _isLoading = false;
        _userLocation = position;
      });
    } on PlatformException {
      setState(() {
        _isLoading = false;
        _userLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showConfirmation ? _buildConfirmationPage() : _buildHospitalsList(),
    );
  }

  Widget _buildHospitalsList() {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userLocation == null
                  ? const Center(child: Text('Error getting location'))
                  : Padding(
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
                            Expanded(
                              child: Column(
                                children: [
                                  _buildHospitalTile('Hospital A', _userLocation!, 10.774265, 22.738586),
                                  const SizedBox(height: 70),
                                  _buildHospitalTile('Hospital B', _userLocation!, 24.774265, 46.738586),
                                  const SizedBox(height: 70),
                                  _buildHospitalTile('Hospital C', _userLocation!, 24.774265, 46.738586),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotPage()));
                },
                icon: const Icon(Icons.chat_bubble),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsPage()));
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalTile(String hospitalName, Position userLocation, double hospitalLat, double hospitalLong) {
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      hospitalLat,
      hospitalLong,
    );

    final travelTime = (distance / 500).ceil(); // Assuming average speed of 500 meters per minute

    return GestureDetector(
      onTap: () {
        setState(() {
          _showConfirmation = true;
          _selectedHospitalName = hospitalName;
          _selectedHospitalAddress = '123 Main St, City'; // Replace with actual address
          _selectedHospitalContact = 'Contact: (123) 456-7890'; // Replace with actual contact
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Row(
          children: [
            const Icon(Icons.local_hospital),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(distance / 1000).toStringAsFixed(2)} km - $travelTime min',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // Navigate or perform action for notifications
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
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
                  _buildHospitalDetails(
                    _selectedHospitalName ?? 'Hospital Name',
                    _selectedHospitalAddress ?? 'Hospital Address',
                    _selectedHospitalContact ?? 'Hospital Contact',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmation = false; // Back button logic
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _createReservation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BE0C1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalDetails(String hospitalName, String address, String contact) {
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
            hospitalName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            address,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            contact,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          // Add more details here as needed
        ],
      ),
    );
  }

  void _createReservation() async {
    if (_selectedHospitalName != null &&
        _selectedHospitalAddress != null &&
        _selectedHospitalContact != null) {
      try {
        await _firestore
            .collection('users')
            .doc(testUserId)
            .collection('reservations')
            .add({
          'hospitalName': _selectedHospitalName,
          'hospitalAddress': _selectedHospitalAddress,
          'hospitalContact': _selectedHospitalContact,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ReservationConfirmedPage()),
        );
      } catch (e) {
        // Handle error as needed
      }
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: HospitalsPage(),
  ));
}
*/


//------------------------------------------------
//new code to test


/*
import 'package:flutter/material.dart';
import 'package:waqti/conform.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'notification.dart';
import 'profile.dart';
import 'chatbot.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  bool _isLoading = true;
  Position? _userLocation;
  bool _showConfirmation = false;
  String? _selectedHospitalName;
  String? _selectedHospitalAddress;
  String? _selectedHospitalContact;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Use a fixed user ID for testing
  final String testUserId = 'Stru6t9pfEX4mtuOamFF';

  final List<Map<String, dynamic>> _hospitals = [
    {"name": "King Fahd Armed Forces Hospital in Jeddah", "crowdLevel": "..."},
    {"name": "KING ABDULAZIZ MEDICAL CITY - JEDDAH", "crowdLevel": "..."},
    {"name": "KING ABDULLAH SPECILIZED CHILDREN HOSPITAL - RIYADH", "crowdLevel": "..."},
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadCrowdLevels();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _isLoading = false;
        _userLocation = position;
      });
    } on PlatformException {
      setState(() {
        _isLoading = false;
        _userLocation = null;
      });
    }
  }

  Future<Map<String, dynamic>> fetchCrowdLevels() async {
    final response = await http.get(Uri.parse('http://192.168.100.10:5000/forecast'));
    //final response = await http.get(Uri.parse('http://localhost:5000/forecast'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load crowd levels');
    }
  }

  void _loadCrowdLevels() async {
    try {
      final crowdLevels = await fetchCrowdLevels();
      setState(() {
        for (var hospital in _hospitals) {
          hospital['crowdLevel'] = crowdLevels[hospital['name']];
        }
        // ترتيب المستشفيات بناءً على مستوى الازدحام
        _hospitals.sort((a, b) => a['crowdLevel'].compareTo(b['crowdLevel']));
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showConfirmation ? _buildConfirmationPage() : _buildHospitalsList(),
    );
  }

  Widget _buildHospitalsList() {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userLocation == null
                  ? const Center(child: Text('Error getting location'))
                  : Padding(
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
                            Expanded(
                              child: ListView.builder(
                                itemCount: _hospitals.length,
                                itemBuilder: (context, index) {
                                  final hospital = _hospitals[index];
                                  // استخدم إحداثيات وهمية للتوضيح
                                  final double hospitalLat = 24.774265 + index * 0.01;
                                  final double hospitalLong = 46.738586 + index * 0.01;
                                  return _buildHospitalTile(hospital, _userLocation!, hospitalLat, hospitalLong);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotPage()));
                },
                icon: const Icon(Icons.chat_bubble),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsPage()));
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalTile(Map<String, dynamic> hospital, Position userLocation, double hospitalLat, double hospitalLong) {
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      hospitalLat,
      hospitalLong,
    );

    final travelTime = (distance / 500).ceil(); // Assuming average speed of 500 meters per minute

    return GestureDetector(
      onTap: () {
        setState(() {
          _showConfirmation = true;
          _selectedHospitalName = hospital['name'];
          _selectedHospitalAddress = '123 Main St, City'; // Replace with actual address
          _selectedHospitalContact = 'Contact: (123) 456-7890'; // Replace with actual contact
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
        child: Row(
          children: [
            const Icon(Icons.local_hospital),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospital['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${(distance / 1000).toStringAsFixed(2)} km - $travelTime min',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Crowd Level: ${hospital['crowdLevel']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // Navigate or perform action for notifications
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
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
                  _buildHospitalDetails(
                    _selectedHospitalName ?? 'Hospital Name',
                    _selectedHospitalAddress ?? 'Hospital Address',
                    _selectedHospitalContact ?? 'Hospital Contact',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmation = false; // Back button logic
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _createReservation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BE0C1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalDetails(String hospitalName, String address, String contact) {
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
            hospitalName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            address,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            contact,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          // Add more details here as needed
        ],
      ),
    );
  }

  void _createReservation() async {
    if (_selectedHospitalName != null &&
        _selectedHospitalAddress != null &&
        _selectedHospitalContact != null) {
      try {
        await _firestore
            .collection('users')
            .doc(testUserId)
            .collection('reservations')
            .add({
          'hospitalName': _selectedHospitalName,
          'hospitalAddress': _selectedHospitalAddress,
          'hospitalContact': _selectedHospitalContact,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ReservationConfirmedPage()),
        );
      } catch (e) {
        // Handle error as needed
      }
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: HospitalsPage(),
  ));
}
*/


//-----------------------------------------------------

//this code is the best one 


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:waqti/conform.dart';
import 'dart:convert';

import 'notification.dart';
import 'profile.dart';
import 'chatbot.dart';

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HospitalsPageState createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  bool _isLoading = true;
  Position? _userLocation;
  bool _showConfirmation = false;
  String? _selectedHospitalName;
  String? _selectedHospitalAddress;
  String? _selectedHospitalContact;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Use a fixed user ID for testing
  final String testUserId = 'Stru6t9pfEX4mtuOamFF';

  final List<Map<String, dynamic>> _hospitals = [
    {"name": "King Fahd Armed Forces Hospital in Jeddah", "crowdLevel": 0.0},
    {"name": "KING ABDULAZIZ MEDICAL CITY - JEDDAH", "crowdLevel": 0.0},
    {"name": "KING ABDULLAH SPECILIZED CHILDREN HOSPITAL - RIYADH", "crowdLevel": 0.0},
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _loadCrowdLevels();
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _isLoading = false;
        _userLocation = position;
      });
    } on PlatformException {
      setState(() {
        _isLoading = false;
        _userLocation = null;
      });
    }
  }

  Future<Map<String, dynamic>> fetchCrowdLevels() async {
    final response = await http.get(Uri.parse('http://192.168.100.10:5000/hospital_info'));///forecast
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load crowd levels');
    }
  }

  void _loadCrowdLevels() async {
    try {
      final crowdLevels = await fetchCrowdLevels();
      setState(() {
        for (var hospital in _hospitals) {
          hospital['crowdLevel'] = (crowdLevels[hospital['name']].values.first as num).toDouble();
        }
        _hospitals.sort((a, b) => a['crowdLevel'].compareTo(b['crowdLevel']));
      });
    } catch (e) {
      // Handle error
    }
  }

  Color _getCrowdLevelColor(double crowdLevel) {
    if (crowdLevel < 5000) {
      return Colors.green;
    } else if (crowdLevel < 10000) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showConfirmation ? _buildConfirmationPage() : _buildHospitalsList(),
    );
  }

  Widget _buildHospitalsList() {
    return Column(
      children: [
        Container(
          height: 170,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _userLocation == null
                  ? const Center(child: Text('Error getting location'))
                  : Padding(
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
                            Expanded(
                              child: ListView.builder(
                                itemCount: _hospitals.length,
                                itemBuilder: (context, index) {
                                  final hospital = _hospitals[index];
                                  // استخدم إحداثيات وهمية للتوضيح
                                  final double hospitalLat = 24.774265 + index * 0.01;
                                  final double hospitalLong = 46.738586 + index * 0.01;
                                  return _buildHospitalTile(hospital, _userLocation!, hospitalLat, hospitalLong);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        ),
        Container(
          height: 100,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBotPage()));
                },
                icon: const Icon(Icons.chat_bubble),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HospitalsPage()));
                },
                icon: const Icon(Icons.home),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalTile(Map<String, dynamic> hospital, Position userLocation, double hospitalLat, double hospitalLong) {
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      hospitalLat,
      hospitalLong,
    );

    final travelTime = (distance / 500).ceil(); // Assuming average speed of 500 meters per minute

    return GestureDetector(
      onTap: () {
        setState(() {
          _showConfirmation = true;
          _selectedHospitalName = hospital['name'];
          _selectedHospitalAddress = '123 Main St, City'; // Replace with actual address
          _selectedHospitalContact = 'Contact: (123) 456-7890'; // Replace with actual contact
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
            Text(hospital['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            LinearProgressIndicator(
              value: hospital['crowdLevel'] / 20000, // Assuming max crowd level is 20000
              color: _getCrowdLevelColor(hospital['crowdLevel']),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 10),
            Text('Crowd Level: ${hospital['crowdLevel'].toStringAsFixed(2)}'),
            Text('Distance: ${(distance / 1000).toStringAsFixed(2)} km'),
            Text('Travel Time: $travelTime min'),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            color: Color(0xFF8BE0C1),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  // Navigate or perform action for notifications
                },
                icon: const Icon(Icons.notifications),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Search for hospitals',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
                },
                icon: const Icon(Icons.person),
                color: Colors.white,
              ),
            ],
          ),
        ),
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
                  _buildHospitalDetails(
                    _selectedHospitalName ?? 'Hospital Name',
                    _selectedHospitalAddress ?? 'Hospital Address',
                    _selectedHospitalContact ?? 'Hospital Contact',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showConfirmation = false; // Back button logic
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _createReservation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8BE0C1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHospitalDetails(String hospitalName, String address, String contact) {
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
            hospitalName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            address,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          Text(
            contact,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          // Add more details here as needed
        ],
      ),
    );
  }

  void _createReservation() async {
    if (_selectedHospitalName != null &&
        _selectedHospitalAddress != null &&
        _selectedHospitalContact != null) {
      try {
        await _firestore
            .collection('users')
            .doc(testUserId)
            .collection('reservations')
            .add({
          'hospitalName': _selectedHospitalName,
          'hospitalAddress': _selectedHospitalAddress,
          'hospitalContact': _selectedHospitalContact,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const ReservationConfirmedPage()),
        );
      } catch (e) {
        // Handle error as needed
      }
    }
  }
}
void main() {
  runApp(const MaterialApp(
    home: HospitalsPage(),
  ));
}


//----------------------------


