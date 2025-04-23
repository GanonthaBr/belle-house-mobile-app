import 'package:flutter/material.dart';
import 'package:mobile_app/screens/commerce_details.dart';

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
      home: CommerceDetailsScreen(
        imagePath: 'images/lands.jpg',
        contractType: 'Vente',
        location: 'Franco',
        price: 20000,
        description: 'descriptipn',
        agentImage: 'images/logo.png',
        agentName: 'BH',
        agentRole: 'immobieier',
      ),
      // routes: {
      //   '': (context) => MainScreen(),
      //   '/house_details': (context) => HouseDetailsScreen(),
      //   '/home_screen': (context) => HomeScreen(),
      // },
    );
  }
}
