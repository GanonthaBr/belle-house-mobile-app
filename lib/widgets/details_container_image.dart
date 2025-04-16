import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/container_icon.dart';

class DetailsContainerImage extends StatelessWidget {
  final String imagePath;
  final Color bgColor;
  const DetailsContainerImage({
    super.key,
    required this.imagePath,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(AppDimension.fontSize18),
          bottomLeft: Radius.circular(AppDimension.fontSize18),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimension.distance20 / 2,
          vertical: AppDimension.distance20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //back arrow
            ContainerIcon(
              icon: Icons.arrow_back,
              iconColor: AppColors.secondaryColor,
              bgColor: AppColors.primaryColor,
            ),
            //favorite
            ContainerIcon(
              icon: Icons.favorite_border,
              iconColor: AppColors.secondaryColor,
              bgColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
