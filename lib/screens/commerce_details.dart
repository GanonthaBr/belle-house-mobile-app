import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/descrption_text.dart';
import 'package:mobile_app/widgets/details_call_to_action.dart';
import 'package:mobile_app/widgets/details_container_image.dart';
import 'package:mobile_app/widgets/small_text.dart';
import 'package:mobile_app/widgets/title_text.dart';

class CommerceDetailsScreen extends StatelessWidget {
  final String imagePath;
  final String contractType;
  final String location;
  final double price;
  final String description;
  final String agentName;
  final String agentRole;
  final String agentImage;

  const CommerceDetailsScreen({
    super.key,
    required this.imagePath,
    required this.contractType,
    required this.location,
    required this.price,
    required this.description,
    required this.agentName,
    required this.agentRole,
    required this.agentImage,
  });

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
              imagePath: imagePath,
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
                              text: contractType,
                              color: AppColors.primaryColor,
                              fontSize: AppDimension.fontSize18,
                            ),
                            SizedBox(height: AppDimension.radius8), //space
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primaryColor,
                                ),
                                TitleText(
                                  text: location,
                                  color: AppColors.primaryColor,
                                  fontSize: AppDimension.fontSize18,
                                ),
                              ],
                            ),
                          ],
                        ),
                        //price
                        TitleText(
                          text: price.toString(),
                          color: AppColors.primaryColor,
                          fontSize: AppDimension.fontSize18,
                        ),
                      ],
                    ),
                  ),
                  //more images
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MoreImage(image: 'images/lands.jpg'),
                        MoreImage(image: 'images/lands.jpg'),
                        MoreImage(image: 'images/lands.jpg'),
                      ],
                    ),
                  ),
                  //text description
                  SizedBox(height: AppDimension.radius14),
                  TitleText(
                    text: "Description",
                    color: AppColors.black,
                    fontSize: AppDimension.fontSize18,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DescriptionText(text: description),
                    ),
                  ),
                  //location
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        left: AppDimension.distance20 * 2,
                        right: AppDimension.distance20 * 2,
                        bottom: AppDimension.distance20 / 2,
                      ),
                      child: const CTAContainer(
                        text: 'Voir Localisation',
                        icon: Icons.location_on_outlined,
                        bgColor: AppColors.secondaryColor,
                        iconColor: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  //agent
                  TitleText(
                    text: 'Details du Contacts',
                    fontSize: AppDimension.fontSize18,
                    color: AppColors.black,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: AppDimension.distance45,
                            width: AppDimension.distance45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimension.distance45,
                              ),
                              image: DecorationImage(
                                image: AssetImage(agentImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: AppDimension.distance20 / 2),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleText(
                                text: agentName,
                                color: AppColors.primaryColor,
                                fontSize: AppDimension.fontSize18,
                              ),
                              SmallText(
                                text: agentRole,
                                size: AppDimension.radius14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //details
        ],
      ),
      bottomNavigationBar: Container(
        height: AppDimension.distance45 * 2,
        padding: EdgeInsets.only(
          left: AppDimension.distance20,
          right: AppDimension.distance20,
          top: AppDimension.distance20,
          bottom: AppDimension.distance20,
        ),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppDimension.distance20),
            topRight: Radius.circular(AppDimension.distance20),
          ),
        ),
        child: Row(
          children: [
            //call button
            const Expanded(
              flex: 3,
              child: CTAContainer(
                icon: Icons.call,
                text: "Appeler",
                bgColor: AppColors.primaryColor,
                iconColor: AppColors.secondaryColor,
              ),
            ),
            SizedBox(width: AppDimension.distance20),
            const Expanded(
              flex: 2,
              child: CTAContainer(
                icon: Icons.inbox_outlined,
                text: 'Message',
                bgColor: AppColors.secondaryColor,
                iconColor: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoreImage extends StatelessWidget {
  final String image;
  const MoreImage({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimension.screenHeight / 10,
      width: AppDimension.screenWidth / 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
      ),
    );
  }
}
