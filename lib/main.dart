import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/houses_mode.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/house_provider.dart';
import 'package:mobile_app/providers/lands_provider.dart';
import 'package:mobile_app/providers/products_provider.dart';
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
        ChangeNotifierProvider(create: (_) => LandsProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ],
      child: MaterialApp(
        title: 'Belle House Immobilier',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

        routes: {
          '/main': (context) => MainScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/house_details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            Property property;

            // Check if arguments is already a Property object or a Map
            if (args is Property) {
              property = args;
            } else if (args is Map<String, dynamic>) {
              // Create Property from Map using fromJson
              property = Property.fromJson(args);
            } else {
              // Handle error case
              return Scaffold(
                appBar: AppBar(
                  title: Text('Error'),
                  backgroundColor: Color(0xff61a1d6),
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text(
                        'Invalid property data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Please try again or contact support.'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Go Back'),
                      ),
                    ],
                  ),
                ),
              );
            }
            return HouseDetailsScreen(
              imagePath: property.imagePath, // Uses images from API
              contractType:
                  property.contractType, // Uses type_of_contract from API
              location: property.location, // Uses area from API
              price: property.price,
              bedrooms: property.bedrooms,
              bathrooms: property.bathrooms,
              kitchens: property.kitchens, // Uses kitchen from API
              description: property.description,
              agentName: property.agentName, // Uses agent_name from API
              agentRole: 'Real Estate Agent', // Default role since not in API
              agentImage:
                  'images/default_agent.png', // Default image since not in API
            );
          },

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
