import 'package:flutter/material.dart';
import 'screen/login_screen.dart';
import 'screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? token;
  String? username;
  int? userId;

  void onLoginSuccess(String t, String u, int i) {
    setState(() {
      token = t;
      username = u;
      userId = i;
    });
  }

  void logout() {
    setState(() {
      token = null;
      username = null;
      userId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: token == null ? LoginScreen(onLoginSuccess: onLoginSuccess) : HomeScreen(token: token!, username: username!, userId: userId ?? 0),
    );
  }
}