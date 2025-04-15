import 'package:flutter/material.dart';
import 'package:mobile_app/utils/dimensions.dart';

class ContainerIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  const ContainerIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimension.distance45,
      width: AppDimension.distance45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: bgColor,
      ),
      child: IconButton(onPressed: () {}, icon: Icon(icon, color: iconColor)),
    );
  }
}
