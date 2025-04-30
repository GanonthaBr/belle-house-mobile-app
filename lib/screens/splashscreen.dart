import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login_screen.dart';
import 'package:mobile_app/services/token_storage.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final TokenStorage _tokenStorage = TokenStorage();
  @override
  void initState() {
    super.initState();
    // check login status and navigate to a screen
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken != null) {
      // Navigate to the main screen if the user is already logged in
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      }
    } else {
      // Navigate to the login screen if no token is found
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context); // Initialize dimensions if needed
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'images/logo.png', // Replace with your app's logo
              width: AppDimension.screenWidth * 0.5,
            ),
            SizedBox(height: AppDimension.distance20),
            // App Name
            Text(
              'Belle House Immobilier',
              style: TextStyle(
                fontSize: AppDimension.fontSize24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
