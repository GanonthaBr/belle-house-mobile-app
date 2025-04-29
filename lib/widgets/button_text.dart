import 'package:flutter/material.dart';
import 'package:mobile_app/utils/dimensions.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final double height;
  final double fontSize;
  final double borderRadius;
  final Color bgcolor;
  final Color textcolor;
  final VoidCallback? onPressed;

  const TextButtonWidget({
    super.key,
    required this.height,
    required this.fontSize,
    required this.borderRadius,
    required this.bgcolor,
    required this.textcolor,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: AppDimension.screenWidth / 1.1,
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            color: textcolor,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}
