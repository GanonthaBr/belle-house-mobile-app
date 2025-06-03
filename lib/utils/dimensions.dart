import 'package:flutter/material.dart';

class AppDimension {
  static double screenHeight = 0;
  static double screenWidth = 0;
  static double fontSize24 = 0;
  static double fontSize18 = 0;

  static double pageViewContainer = 0;
  static double pageViewDetails = 0;
  static double distance20 = 0;
  static double distance30 = 0;
  static double distance50 = 0;
  static double distance70 = 0;
  static double distance45 = 0;
  static double distance5 = 0;

  static double radius14 = 0;
  static double radius8 = 0;

  static void init(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    fontSize24 = screenHeight / 35.85;
    fontSize18 = screenHeight / 51.78;

    pageViewContainer = screenHeight / 3.84;
    pageViewDetails = screenHeight / 11.04;

    distance20 = screenHeight / 46.6;
    distance30 = screenHeight / 31.1;
    distance50 = screenHeight / 18.64;
    distance70 = screenHeight / 13.314;
    distance45 = screenHeight / 20.71;
    distance5 = screenHeight / 156.8;

    radius14 = screenHeight / 66.57;
    radius8 = screenHeight / 116.5;
  }
}
