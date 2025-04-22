import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/container_icon.dart';
import 'package:mobile_app/widgets/small_text.dart';
import 'package:mobile_app/widgets/title_text.dart';

class HouseListing extends StatelessWidget {
  const HouseListing({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: AppDimension.screenHeight / 3.7,
          margin: EdgeInsets.only(
            left: AppDimension.radius14,
            right: AppDimension.radius14,
            top: AppDimension.radius14,
            bottom: 0,
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
              image: AssetImage('images/BH39.jpg'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
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
          height: AppDimension.screenHeight / 10,
          margin: EdgeInsets.symmetric(
            horizontal: AppDimension.radius14,
            vertical: 0,
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryColorLoose,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(
                      text: 'BH03, Niamey',
                      color: AppColors.black,
                      fontSize: AppDimension.fontSize18,
                    ),
                    TitleText(
                      text: 'En Location',
                      color: AppColors.black,
                      fontSize: AppDimension.fontSize18,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmallText(
                      text: 'Francophonie',
                      size: AppDimension.radius14,
                    ),
                    SmallText(
                      text: '200 000 FCFA/Mois',
                      size: AppDimension.radius14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
