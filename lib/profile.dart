import 'package:flutter/material.dart';
import 'package:waqti/login_screen.dart';
import 'package:waqti/support.dart'; 
import 'package:waqti/edit.dart'; 
import 'book.dart'; 
import 'package:waqti/medical.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8BE0C1),
        title: const Text('Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
      body: Builder(
        builder: (BuildContext context) {
          return Column(
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Hello Faisal',
                        style: TextStyle(
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildProfileButton(
                        context: context,
                        icon: Icons.medical_services,
                        text: 'Medical Records',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalHistoryPage()));
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildProfileButton(
                        context: context,
                        icon: Icons.event_note,
                        text: 'My Bookings',
                        onPressed: () {
                          scaffoldKey.currentState!.openDrawer(); // Open the drawer
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildProfileButton(
                        context: context,
                        icon: Icons.support,
                        text: 'Support',
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SupportScreen()));
                        },
                      ),
                      const SizedBox(height: 15),
                      _buildProfileButton(
                        context: context,
                        icon: Icons.logout,
                        text: 'Log Out',
                        onPressed: () {
                          _showSignOutDialog(context); // Show sign-out confirmation dialog
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInPage())); // Close the bottom sheet
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ReservationScreen()));
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
