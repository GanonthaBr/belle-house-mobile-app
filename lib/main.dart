import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/house_provider.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/house_details.dart';
import 'package:mobile_app/screens/land_details.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/main_screen.dart';
import 'package:mobile_app/screens/message_details.dart';
import 'package:mobile_app/screens/register_screen.dart';
import 'package:mobile_app/screens/splashscreen.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HouseProvider()),
      ],
      child: MaterialApp(
        title: 'Belle House Immobilier',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

        routes: {
          '/main': (context) => MainScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/house_details':
              (context) => HouseDetailsScreen(
                imagePath: 'images/BH39.jpg',
                contractType: 'Vente',
                location: 'location',
                price: 2000,
                bedrooms: 2,
                bathrooms: 2,
                kitchens: 2,
                description: "description",
                agentName: "BH",
                agentRole: 'agentRole',
                agentImage: 'images/logo.png',
              ),

          '/home_screen': (context) => HomeScreen(),
          "/message_details":
              (context) => MessageDetailsScreen(
                receiverName: 'Alissa',
                receiverImage: 'images/logo.png',
              ),
          '/land_details':
              (context) => LandDetailsScreen(
                imagePath: 'images/lands.jpg',
                contractType: 'Vente',
                location: 'Franco',
                price: 20000,
                description: 'descriptipn',
                agentImage: 'images/logo.png',
                agentName: 'BH',
                agentRole: 'immobieier',
              ),
        },
      ),
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
