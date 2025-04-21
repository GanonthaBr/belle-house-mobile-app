import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';

class PopularProperty extends StatelessWidget {
  final Image image;
  final double price;
  final String area;
  final String city;
  final int bed;
  final int bedroom;
  final String type;
  const PopularProperty({
    super.key,
    required this.image,
    required this.price,
    required this.area,
    required this.bed,
    required this.city,
    required this.bedroom,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        //image with like (heart) button in a stack widget
        SizedBox(
          height: AppDimension.pageViewContainer,
          width: AppDimension.screenWidth,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimension.distance20 / 2),
                ),
                child: image,
              ),
              Positioned(
                left: 2,
                top: 2,
                child: IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),

        //property details
        Positioned(
          bottom: -AppDimension.distance20 / 3,
          left: AppDimension.distance20 * 2,
          right: AppDimension.distance20 * 2,
          child: Container(
            constraints: BoxConstraints(
              minHeight: AppDimension.pageViewDetails,
            ),
            padding: EdgeInsets.only(
              left: AppDimension.distance20 / 2,
              top: AppDimension.distance20 / 2,
              right: AppDimension.distance20 / 2,
              bottom: AppDimension.distance20 / 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(AppDimension.distance20),
              ),
              color: AppColors.secondaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 2,
                  offset: Offset(-2, -5),
                ),
                BoxShadow(color: Colors.black12, offset: Offset(-2, -5)),
              ],
            ),
            height: AppDimension.pageViewDetails,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //price and type
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(
                      text: type,
                      color: Colors.black,
                      fontSize: AppDimension.radius14,
                    ),
                    TitleText(
                      text: '$price FCFA',
                      color: AppColors.primaryColor,
                      fontSize: AppDimension.radius14,
                    ),
                  ],
                ),
                SizedBox(height: AppDimension.distance20 / 4),
                //area and city
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColors.black,
                      size: AppDimension.radius14,
                    ),
                    Text(
                      city,
                      style: TextStyle(fontSize: AppDimension.radius14),
                    ),
                    const Text('-'),
                    Text(area),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
