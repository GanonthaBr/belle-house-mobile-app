import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final Color fillcolor;
  final Color focuscolor;
  final Color bordercolor;
  final Color labelColor;
  // final String helperText;
  final String labelText;
  final double fontsize;
  final double borderRadius;
  final bool passwordField;
  final bool fillBg;
  final TextEditingController controller;

  const InputTextField({
    super.key,
    required this.hintText,
    required this.fillcolor,
    required this.focuscolor,
    required this.bordercolor,

    required this.labelText,
    required this.fontsize,
    required this.borderRadius,
    required this.labelColor,
    required this.passwordField,
    required this.fillBg,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: passwordField, // Hides the text for password input
      decoration: InputDecoration(
        // helper: Text(helperText),
        labelText: labelText,
        labelStyle: TextStyle(
          fontSize: fontsize,
          fontWeight: FontWeight.w300,
          letterSpacing: 1.4,
          color: labelColor,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        filled: fillBg,
        fillColor: fillcolor,
        focusColor: focuscolor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: bordercolor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: bordercolor),
        ),
      ),
    );
  }
}
