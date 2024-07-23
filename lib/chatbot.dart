import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:waqti/conferm_screen/conferm_screen.dart';
import 'package:waqti/profile.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference messagesRef = FirebaseFirestore.instance
      .collection('users')
      .doc('Stru6t9pfEX4mtuOamFF')
      .collection('messages');

  final String flaskUrl = "http://192.168.100.10:5000/chatbot";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Upper Rectangle with chatbot icon
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
                        'ChatBot',
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
                    Icons.chat,
                    size: 40,
                    color: Color(0xFF8BE0C1),
                  ),
                ),
                const SizedBox(height: 10), // Add some spacing
              ],
            ),
          ),

          // Chat Messages Section
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
                  stream: messagesRef.orderBy('timestamp', descending: true).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        var message = messages[index];
                        return _buildChatMessage(
                          message['text'],
                          isBot: message['isBot'],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),

          // Input Field for Questions
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your question here...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => _sendMessage(),
                  backgroundColor: const Color(0xFF8BE0C1),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
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

  Widget _buildChatMessage(String message, {required bool isBot}) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isBot ? Colors.white : const Color(0xFF8BE0C1),
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
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isBot ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  void _sendMessage() async {
    String text = _controller.text;
    if (text.isEmpty) return;

    // Save user message
    await messagesRef.add({
      'text': text,
      'isBot': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Get bot response
    try {
      String botResponse = await _getBotResponse(text);
      await messagesRef.add({
        'text': botResponse,
        'isBot': true,
        'timestamp': FieldValue.serverTimestamp(),
      });
    // ignore: empty_catches
    } catch (e) {
    }

    _controller.clear();
  }

  Future<String> _getBotResponse(String text) async {
    final response = await http.post(
      Uri.parse(flaskUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else {
      throw Exception('Failed to load response from Flask server');
    }
  }
}
