import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String boardName; // Name of the chat board

  ChatScreen({required this.boardName}); 

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController(); 
  final FirebaseAuth _auth = FirebaseAuth.instance; 

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      User? user = _auth.currentUser; // Get current logged-in user
      if (user != null) {
        try {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(); // Retrieve user from Firestore

          String username = userDoc['username'] ?? 'Anonymous'; 

          // Add message to Firestore
          await FirebaseFirestore.instance
              .collection('boards')
              .doc(widget.boardName)
              .collection('messages')
              .add({
            'content': _messageController.text.trim(), // Message content
            'username': username, // Username of the sender
            'timestamp': FieldValue.serverTimestamp(), // Timestamp of the message
            'userId': user.uid, 
          });

          _messageController.clear(); // clear the input field after sending
        } catch (e) {
          // error if message fails to send
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send message: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName), 
        backgroundColor: Colors.deepPurple, 
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('boards')
                  .doc(widget.boardName)
                  .collection('messages')
                  .orderBy('timestamp', descending: true) 
                  .snapshots(), 
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator()); // loading indicator
                }
                final messages = snapshot.data!.docs; // List of messages
                return ListView.builder(
                  reverse: true, // Display messages in reverse order 
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index]; // Current message
                    var timestamp = message['timestamp'] != null
                        ? (message['timestamp'] as Timestamp).toDate() 
                        : DateTime.now(); 

                    return ListTile(
                      title: Text(
                        message['username'], // Display username
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      subtitle: Text(message['content']), // Display message content
                      trailing: Text(
                        "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')} ${timestamp.hour >= 12 ? 'PM' : 'AM'}", // Display time
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController, 
                    decoration: InputDecoration(
                      labelText: 'Enter your message', 
                      border: OutlineInputBorder(), 
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple), 
                                    onPressed: _sendMessage, //  _sendMessage method when pressed
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

