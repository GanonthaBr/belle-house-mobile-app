import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/container_icon.dart';

class Houses extends StatelessWidget {
  const Houses({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: AppDimension.screenHeight / 3.2,
            margin: EdgeInsets.symmetric(
              horizontal: AppDimension.radius14,
              vertical: AppDimension.radius14,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                image: AssetImage('images/BH39.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //back arrow

                //favorite
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ContainerIcon(
                    icon: Icons.favorite_border,
                    iconColor: AppColors.secondaryColor,
                    bgColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          //details
          Container(
            height: AppDimension.distance50 * 2,
            decoration: BoxDecoration(color: Colors.red),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('data'), Text("text")],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
