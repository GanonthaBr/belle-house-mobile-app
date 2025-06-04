import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/models/houses_model.dart';
import 'package:mobile_app/models/land_model.dart';
import 'package:mobile_app/models/product_model.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/favorites_provider.dart';
import 'package:mobile_app/providers/house_provider.dart';
import 'package:mobile_app/providers/lands_provider.dart';
import 'package:mobile_app/providers/products_provider.dart';
import 'package:mobile_app/screens/commerce_details.dart';
import 'package:mobile_app/screens/favorites_screen.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/house_details.dart';
import 'package:mobile_app/screens/land_details.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/screens/main_screen.dart';
import 'package:mobile_app/screens/message_details.dart';
import 'package:mobile_app/screens/register_screen.dart';
import 'package:mobile_app/screens/splashscreen.dart';
import 'package:mobile_app/widgets/error_widget.dart';
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
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Belle House Immobilier',
        debugShowCheckedModeBanner: false,
        home: AppInitializer(),

        routes: {
          '/main': (context) => MainScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/lands': (context) => RegisterScreen(),
          '/favorites': (context) => FavoritesScreen(),

          '/house_details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;

            Property property;

            if (args is Property) {
              property = args;
            } else if (args is Map<String, dynamic>) {
              property = Property.fromJson(args);
            } else {
              return buildErrorScreen(context, 'Invalid property data');
            }

            return HouseDetailsScreen(property: property);
          },

          // New land route
          '/land_details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;

            Land land;

            if (args is Land) {
              land = args;
            } else if (args is Map<String, dynamic>) {
              land = Land.fromJson(args);
            } else {
              return buildErrorScreen(context, 'Invalid land data');
            }

            return LandDetailsScreen(land: land);
          },
          '/product_details': (context) {
            final args = ModalRoute.of(context)!.settings.arguments;
            // print("ARG $args");
            Product product;

            if (args is Product) {
              product = args;
            } else if (args is Map<String, dynamic>) {
              product = Product.fromJson(args);
            } else {
              return buildErrorScreen(context, 'Invalid product data');
            }

            // Convert Product to format expected by ProductDetailScreen
            return ProductDetailScreen(product: product);
          },

          '/home_screen': (context) => HomeScreen(),
          "/message_details":
              (context) => MessageDetailsScreen(
                receiverName: 'Alissa',
                receiverImage: 'images/logo.png',
              ),
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() async {
    // print('🚀 Initializing app data');

    try {
      // Check if user is logged in first
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkLogin();
      // If user is authenticated, load favorites
      if (authProvider.isAuthenticated == true) {
        final favoritesProvider = Provider.of<FavoritesProvider>(
          context,
          listen: false,
        );

        await favoritesProvider.getFavorites();
      } else {
        print('👤 User not authenticated, skipping favorites load');
      }
    } catch (e) {
      print('❌ Error during app initialization: $e');
    } finally {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return SplashScreen();
  }
}
