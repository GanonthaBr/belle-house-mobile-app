import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/details_container_image.dart';

class HouseDetailsScreen extends StatelessWidget {
  const HouseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: Column(
        children: [
          //image
          Expanded(
            flex: 3,
            child: DetailsContainerImage(
              imagePath: 'images/logo.png',
              bgColor: Colors.black12,
            ),
          ),
          Expanded(flex: 4, child: Container(color: AppColors.secondaryColor)),
          //details
        ],
      ),
    );
  }
}
