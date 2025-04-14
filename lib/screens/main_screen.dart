import 'package:flutter/material.dart';
import 'package:mobile_app/screens/register_screen.dart';
import 'package:mobile_app/utils/colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Bar'),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: RegisterScreen(),
    );
  }
}
