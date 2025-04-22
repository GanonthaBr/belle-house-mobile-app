import 'package:flutter/material.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/house_details.dart';
import 'package:mobile_app/screens/main_screen.dart';

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
      home: MainScreen(),
      routes: {
        '': (context) => MainScreen(),
        '/house_details': (context) => HouseDetailsScreen(),
        '/home_screen': (context) => HomeScreen(),
      },
    );
  }
}
