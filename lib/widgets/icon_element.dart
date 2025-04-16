import 'package:flutter/material.dart';
import 'package:mobile_app/utils/dimensions.dart';

class IconElement extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final Color? bgColor;
  final double radius;
  final double height;
  const IconElement({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
    this.bgColor = Colors.transparent,
    required this.radius,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.all(AppDimension.fontSize24 / 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            // spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Center(child: Icon(icon, color: color, size: size)),
    );
  }
}
