import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistoryPage extends StatefulWidget {
  const MedicalHistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MedicalHistoryPageState createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _noteController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _noteController2 = TextEditingController();
  final TextEditingController _dateController3 = TextEditingController();
  final TextEditingController _noteController3 = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMedicalRecord();
  }

  Future<void> _loadMedicalRecord() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('Stru6t9pfEX4mtuOamFF')
        .collection('medical record')
        .limit(1)
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      final medicalRecord = docSnapshot.docs.first.data();
      setState(() {
        _nameController.text = medicalRecord['name'];
        _idController.text = medicalRecord['id'];
        _ageController.text = medicalRecord['age'];
        _genderController.text = medicalRecord['gender'];
        final records = medicalRecord['records'];
        _dateController1.text = records[0]['date'];
        _noteController1.text = records[0]['note'];
        _dateController2.text = records[1]['date'];
        _noteController2.text = records[1]['note'];
        _dateController3.text = records[2]['date'];
        _noteController3.text = records[2]['note'];
      });
    }
  }

  Future<void> _saveMedicalRecord() async {
    final medicalRecord = {
      'name': _nameController.text,
      'id': _idController.text,
      'age': _ageController.text,
      'gender': _genderController.text,
      'records': [
        {'date': _dateController1.text, 'note': _noteController1.text},
        {'date': _dateController2.text, 'note': _noteController2.text},
        {'date': _dateController3.text, 'note': _noteController3.text},
      ],
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc('Stru6t9pfEX4mtuOamFF')
        .collection('medical record')
        .add(medicalRecord);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _dateController1.dispose();
    _noteController1.dispose();
    _dateController2.dispose();
    _noteController2.dispose();
    _dateController3.dispose();
    _noteController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper Section with rounded bottom
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFF8BE0C1),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Navigate back logic
                      },
                    ),
                    centerTitle: true,
                    title: const Text(
                      'Medical History',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.black),
                        onPressed: () {
                          // Notification icon press logic
                        },
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.description,
                      size: 40,
                      color: Color(0xFF8BE0C1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Medical Details Form
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Name:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'ID:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _idController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Age:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _ageController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Gender:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: _genderController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Medical Records Section
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Date:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Note:',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(color: Colors.grey),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _dateController1,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _noteController1,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _dateController2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _noteController2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _dateController3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    controller: _noteController3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          // Save Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: _saveMedicalRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8BE0C1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Save Medical Record'),
            ),
          ),

          const Spacer(),

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
                    // Navigate to profile screen
                  },
                  icon: const Icon(Icons.person),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to home screen
                  },
                  icon: const Icon(Icons.home),
                  color: Colors.black,
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to support screen
                  },
                  icon: const Icon(Icons.headset),
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
