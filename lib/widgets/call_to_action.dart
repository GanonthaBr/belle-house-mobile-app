import 'package:flutter/material.dart';
import 'package:mobile_app/utils/dimensions.dart';

class CTAComponent extends StatelessWidget {
  final String text;
  final String actionText;
  final Color actionTextColor;
  const CTAComponent({
    super.key,
    required this.text,
    required this.actionText,
    required this.actionTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(
          onPressed: () {},
          child: Text(
            actionText,
            style: TextStyle(
              color: actionTextColor,
              fontWeight: FontWeight.w400,
              fontSize: AppDimension.fontSize18,
            ),
          ),
        ),
      ],
    );
  }
}
