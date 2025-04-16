import 'package:flutter/material.dart';
import 'package:mobile_app/utils/dimensions.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final Color? color;
  final Color? bgColor;
  final Function() action;

  const MenuItem({
    super.key,
    required this.title,
    this.color = Colors.white,
    this.bgColor = Colors.white,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        width: AppDimension.distance70,
        height: AppDimension.distance30,
        margin: EdgeInsets.all(AppDimension.distance20 / 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppDimension.distance20 / 4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              // spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
            BoxShadow(
              color: Colors.black12,
              // spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(1, 0), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }
}
