import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'personal_info_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  String? _email; // Stores user's email
  String? _name; // Stores user's name

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load user data 
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser; // Get the current logged-in user
    if (user != null) {
      setState(() {
        _email = user.email; // Set email for display
      });

      //  user data from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _name = userDoc['username'] ?? 'Anonymous'; // Set username for display
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), 
        backgroundColor: Colors.green, 
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.lightGreen[100]!], 
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16.0), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information', 
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green[900],
              ),
            ),
            SizedBox(height: 20), 
            Card(
              margin: EdgeInsets.symmetric(vertical: 10), 
              elevation: 4, 
              shadowColor: Colors.green[400], 
              child: ListTile(
                title: Text('Name: ${_name ?? 'Loading...'}'), // Display name
                subtitle: Text('Email: ${_email ?? 'Loading...'}'), // Display email
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPersonalInfoScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700], 
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: Text('Edit Profile', style: TextStyle(fontSize: 18)), 
            ),
          ],
        ),
      ),
    );
  }
}
