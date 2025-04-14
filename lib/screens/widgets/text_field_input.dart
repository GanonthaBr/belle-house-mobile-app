import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final Color fillcolor;
  final Color focuscolor;
  final Color bordercolor;
  final Color labelColor;
  final String helperText;
  final String labelText;
  final double fontsize;
  final double borderRadius;

  const InputTextField({
    super.key,
    required this.hintText,
    required this.fillcolor,
    required this.focuscolor,
    required this.bordercolor,
    required this.helperText,
    required this.labelText,
    required this.fontsize,
    required this.borderRadius,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true, // Hides the text for password input
      decoration: InputDecoration(
        helper: Text(helperText),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: fontsize,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.4,
          color: labelColor,
        ),
        filled: true,
        fillColor: fillcolor,
        focusColor: focuscolor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: bordercolor),
        ),
      ),
    );
  }
}
