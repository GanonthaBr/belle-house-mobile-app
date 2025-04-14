import 'package:flutter/material.dart';

class AppDimension {
  static late double screenHeight;
  static late double screenWidth;
  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  static double fontSize24 = screenHeight / 35.85;
  static double fontSize18 = screenHeight / 51.78;

  static double distance20 = screenHeight / 46.6;
  static double distance50 = screenHeight / 18.64;

  static double radius14 = screenHeight / 66.57;
}
