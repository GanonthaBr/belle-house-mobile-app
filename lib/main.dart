import 'package:flutter/material.dart';
import 'package:mobile_app/screens/welcome_screen_architecture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belle House Immobilier',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreenArchitecture(),
    );
  }
}
