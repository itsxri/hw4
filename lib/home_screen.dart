import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> rooms = [
    {'name': 'Blueberry Room', 'icon': 'assets/blueberry.png'},
    {'name': 'Lemon Room', 'icon': 'assets/lemon.png'},
    {'name': 'Peach Room', 'icon': 'assets/peach.png'},
    {'name': 'Strawberry Room', 'icon': 'assets/strawberry.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Rooms'),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.deepPurple),
              title: Text('Message Boards'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.deepPurple),
              title: Text('Profile'),
              onTap: () => Navigator.pushNamed(context, '/profile'), // Navigate to ProfileScreen
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.deepPurple),
              title: Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50], // Light blue background
        ),
        child: ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              elevation: 5,
              shadowColor: Colors.blueAccent,
              child: ListTile(
                leading: Image.asset(
                  rooms[index]['icon']!,
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  rooms[index]['name']!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: rooms[index]['name'],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
