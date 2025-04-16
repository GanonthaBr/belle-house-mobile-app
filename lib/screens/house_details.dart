import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/details_container_image.dart';
import 'package:mobile_app/widgets/property_details_icon.dart';
import 'package:mobile_app/widgets/title_text.dart';

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
              imagePath: 'images/BH39.jpg',
              bgColor: Colors.black12,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: AppColors.secondaryColor,
              child: Column(
                children: [
                  //title
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                      vertical: AppDimension.radius14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //type of contract
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                              text: "Vente",
                              color: AppColors.black,
                              fontSize: AppDimension.fontSize18,
                            ),
                            SizedBox(height: AppDimension.radius8), //space
                            Row(
                              children: [
                                Icon(Icons.location_on_outlined),
                                TitleText(
                                  text: 'Niamey/Banifandou',
                                  color: AppColors.black,
                                  fontSize: AppDimension.fontSize18,
                                ),
                              ],
                            ),
                          ],
                        ),
                        //price
                        TitleText(
                          text: "1 200 000 FCFA",
                          color: AppColors.black,
                          fontSize: AppDimension.fontSize18,
                        ),
                      ],
                    ),
                  ),
                  //description
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PropertyDetailsIcon(
                          number: 4,
                          item: 'bedrooms',
                          icon: Icons.bed,
                        ),
                        PropertyDetailsIcon(
                          number: 2,
                          item: 'toilettes',
                          icon: Icons.shower,
                        ),
                        PropertyDetailsIcon(
                          number: 1,
                          item: 'cuisine',
                          icon: Icons.kitchen_sharp,
                        ),
                        PropertyDetailsIcon(
                          number: 2,
                          item: 'bedrooms',
                          icon: Icons.bed,
                        ),
                      ],
                    ),
                  ),
                  //text description
                  SizedBox(height: AppDimension.radius14),
                ],
              ),
            ),
          ),
          //details
        ],
      ),
    );
  }
}
