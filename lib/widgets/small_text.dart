import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double size;
  const SmallText({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Colors.black54, fontSize: size));
  }
}
