import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final Color? iconColor;
  final Color bgColor;
  final Function() action;

  const MenuItem({
    super.key,
    required this.title,
    this.color = Colors.white,
    this.bgColor = Colors.white,
    required this.action,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: AppDimension.distance70,
        height: AppDimension.distance70,
        margin: EdgeInsets.all(AppDimension.distance20 / 4),
        decoration: BoxDecoration(
          // color: bgColor,
          border: Border(bottom: BorderSide(color: bgColor, width: 3)),
          borderRadius: BorderRadius.circular(AppDimension.distance20 / 10),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black12,
          //     // spreadRadius: 1,
          //     blurRadius: 1,
          //     offset: Offset(0, 1), // changes position of shadow
          //   ),
          //   BoxShadow(
          //     color: Colors.black12,
          //     // spreadRadius: 1,
          //     blurRadius: 1,
          //     offset: Offset(1, 0), // changes position of shadow
          //   ),
          // ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primaryColor),
              Text(
                title,
                style: TextStyle(
                  fontSize: AppDimension.distance20 / 1.7,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
