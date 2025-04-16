import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class PropertyDetailsIcon extends StatelessWidget {
  final int number;
  final String item;
  final IconData icon;
  const PropertyDetailsIcon({
    super.key,
    required this.number,
    required this.item,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimension.distance70,
      width: AppDimension.distance70 + AppDimension.radius8,
      padding: EdgeInsets.all(AppDimension.radius8),
      margin: EdgeInsets.only(right: AppDimension.distance20 / 4),
      decoration: BoxDecoration(
        color: AppColors.gray,
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimension.distance20 / 2),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryColor),
          Text(
            "$number $item",
            style: TextStyle(
              fontSize: AppDimension.distance20 / 2,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
