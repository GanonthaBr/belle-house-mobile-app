import 'package:flutter/material.dart';
import 'package:mobile_app/utils/dimensions.dart';

class WelcomeScreenDescriptionText extends StatelessWidget {
  final String text;

  const WelcomeScreenDescriptionText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppDimension.fontSize18,
        letterSpacing: 1.1,
        wordSpacing: 1.1,
        fontWeight: FontWeight.w300,
      ),
      textAlign: TextAlign.center,
    );
  }
}
