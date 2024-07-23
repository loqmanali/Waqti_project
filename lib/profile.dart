import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waqti/auth/pages/login_screen.dart';
import 'package:waqti/support.dart';
import 'package:waqti/edit.dart';
import 'app_router.dart';
import 'book.dart';
import 'package:waqti/medical.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getUserData() async {
    User? user = _auth.currentUser;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(user?.uid).get();
    print(snapshot.data());
    return snapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8BE0C1),
        title: const Text('Profile'),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: SizedBox(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      drawer: const ReservationDrawer(),
      body: FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    child: const Text('Log Out'),
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInPage()));
                      });
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data;
            return Column(
              children: [
                // Upper Section with rounded bottom
                // Container(
                //   // height: 200,
                //   decoration: const BoxDecoration(
                //     color: Color(0xFF8BE0C1),
                //     borderRadius:
                //         BorderRadius.vertical(bottom: Radius.circular(30)),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           'Profile',
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 20,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                // Profile Details Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Hello ${user?['fullName']},',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const CircleAvatar(
                          radius: 40,
                          child: Icon(Icons.person, size: 40),
                        ),
                        const SizedBox(height: 30),
                        _buildProfileButton(
                          context: context,
                          icon: Icons.edit,
                          text: 'Edit Profile',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfilePage()));
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildProfileButton(
                          context: context,
                          icon: Icons.medical_services,
                          text: 'Medical Records',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MedicalHistoryPage()));
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildProfileButton(
                          context: context,
                          icon: Icons.event_note,
                          text: 'My Bookings',
                          onPressed: () {
                            scaffoldKey.currentState!
                                .openDrawer(); // Open the drawer
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildProfileButton(
                          context: context,
                          icon: Icons.support,
                          text: 'Support',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SupportScreen()));
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildProfileButton(
                          context: context,
                          icon: Icons.logout,
                          text: 'Log Out',
                          onPressed: () {
                            _showSignOutDialog(
                                context); // Show sign-out confirmation dialog
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation Bar
                Container(
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8BE0C1),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.person),
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.home),
                        color: Colors.black,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.headset),
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No user signed in'),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildProfileButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF8BE0C1),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SignInPage())); // Close the bottom sheet
                      });
                      // Implement your log out logic here
                      // For example, navigate to login screen or clear user session
                    },
                    child: const Text('Yes, Log Out'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReservationDrawer extends StatelessWidget {
  const ReservationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF8BE0C1),
            ),
            child: Text(
              'My Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Current'),
            onTap: () {
              // Handle current tap
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReservationScreen()));
            },
          ),
          ListTile(
            title: const Text('Expired'),
            onTap: () {
              // Handle expired tap
              // You can implement navigation logic here
            },
          ),
        ],
      ),
    );
  }
}
