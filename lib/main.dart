import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart'; 
import 'settings_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase 
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Chatboards', 
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, 
      ),
      //screen routes
      initialRoute: '/', 
      routes: {
        '/': (context) => SplashScreen(), 
        '/login': (context) => LoginScreen(), 
        '/register': (context) => RegisterScreen(), 
        '/home': (context) => HomeScreen(), 
        '/chat': (context) => ChatScreen(
              boardName: ModalRoute.of(context)?.settings.arguments as String,
            ), 
        '/profile': (context) => ProfileScreen(), 
        '/settings': (context) => SettingsScreen(), 
      },
    );
  }
}
