import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/icon_element.dart';
import 'package:mobile_app/widgets/property_page_builder.dart';
import 'package:mobile_app/widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //popular properties
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppDimension.distance20 / 2,
                        ),
                        child: TitleText(
                          text: 'PLUS POPULAIRES',
                          fontSize: AppDimension.radius14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      SizedBox(height: AppDimension.distance20 * 2),
                      Padding(
                        padding: EdgeInsets.all(AppDimension.radius8),
                        child: IconElement(
                          icon: Icons.add,
                          color: AppColors.primaryColor,
                          size: AppDimension.distance30,
                          radius: AppDimension.distance20,
                          height: AppDimension.distance50,
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(height: Dimension.sizeFive),
                  //listings
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/house_details');
                      print('Clicked');
                    },
                    child: const PropertyPageBuilder(),
                  ),
                  //news
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: AppDimension.distance20 / 2,
                        ),
                        child: TitleText(
                          text: 'LES ANNONCES',
                          fontSize: AppDimension.radius14,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // listings
                  ListView.builder(
                    // physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: AppDimension.distance20 / 2,
                        ),
                        child: GestureDetector(
                          onTap: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: AppDimension.distance30 / 2,
                              left: AppDimension.distance20 / 2,
                              right: AppDimension.distance20 / 2,
                            ),
                            child: Container(
                              height: AppDimension.distance70 * 2,
                              width: AppDimension.screenWidth / 2,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColorLoose,
                                borderRadius: BorderRadius.circular(
                                  AppDimension.radius8,
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('images/BH39.jpg'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
