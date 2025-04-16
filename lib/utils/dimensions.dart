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
  static double distance30 = screenHeight / 31.1;
  static double distance50 = screenHeight / 18.64;
  static double distance70 = screenHeight / 13.314;
  static double distance45 = screenHeight / 20.71;

  static double radius14 = screenHeight / 66.57;
  static double radius8 = screenHeight / 116.5;
}
