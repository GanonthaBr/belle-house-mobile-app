import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/screens/commerce_details.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/house_details.dart';
import 'package:mobile_app/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // debugPaintSizeEnabled = true;
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

      /// The `routes` property in the `MaterialApp` widget is used to define named routes in a Flutter
      /// application. In the provided code snippet:
      routes: {
        '': (context) => MainScreen(),
        '/house_details':
            (context) => CommerceDetailsScreen(
              imagePath: 'images/lands.jpg',
              contractType: 'Vente',
              location: 'Franco',
              price: 20000,
              description: 'descriptipn',
              agentImage: 'images/logo.png',
              agentName: 'BH',
              agentRole: 'immobieier',
            ),
        '/home_screen': (context) => HomeScreen(),
      },
    );
  }
}

// CommerceDetailsScreen(
//         imagePath: 'images/lands.jpg',
//         contractType: 'Vente',
//         location: 'Franco',
//         price: 20000,
//         description: 'descriptipn',
//         agentImage: 'images/logo.png',
//         agentName: 'BH',
//         agentRole: 'immobieier',
//       ),
