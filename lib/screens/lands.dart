import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/container_icon.dart';
import 'package:mobile_app/widgets/small_text.dart';
import 'package:mobile_app/widgets/title_text.dart';

class LandList extends StatelessWidget {
  const LandList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/land_details');
            },
            child: LandListing(
              image: 'images/lands.jpg',
              area: 'Yantala',
              city: 'Niamey',
              price: 2000000,
              superficie: 300,
            ),
          );
        },
      ),
    );
  }
}

class LandListing extends StatelessWidget {
  final String image;

  final String city;
  final double superficie;
  final double price;
  final String area;
  const LandListing({
    super.key,
    required this.image,

    required this.city,
    required this.superficie,
    required this.price,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildImage(), _buildDetails()]);
  }

  Widget _buildImage() {
    return Container(
      height: AppDimension.screenHeight / 3.7,
      margin: EdgeInsets.only(
        left: AppDimension.radius14,
        right: AppDimension.radius14,
        top: AppDimension.radius14,
        bottom: 0,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimension.distance20 / 2),
          topRight: Radius.circular(AppDimension.distance20 / 2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [_buildFavoriteIcon()],
      ),
    );
  }

  Widget _buildFavoriteIcon() {
    return Padding(
      padding: EdgeInsets.all(AppDimension.radius8),
      child: ContainerIcon(
        icon: Icons.favorite_border,
        iconColor: AppColors.secondaryColor,
        bgColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      height: AppDimension.screenHeight / 10,
      margin: EdgeInsets.symmetric(
        horizontal: AppDimension.radius14,
        vertical: 0,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryColorLoose,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimension.distance20 / 2),
          bottomRight: Radius.circular(AppDimension.distance20 / 2),
        ),
      ),
      child: Column(children: [_buildTitle(), _buildPriceAndArea()]),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(AppDimension.radius8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primaryColor),
              TitleText(
                text: city,
                color: AppColors.black,
                fontSize: AppDimension.fontSize18,
              ),
            ],
          ),
          TitleText(
            text: '$superficie m2',
            color: AppColors.black,
            fontSize: AppDimension.fontSize18,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndArea() {
    return Padding(
      padding: EdgeInsets.all(AppDimension.radius8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SmallText(text: area, size: AppDimension.radius14),
          SmallText(
            text: superficie == 'Location' ? "$price FCFA/Mois" : "$price FCFA",
            size: AppDimension.radius14,
          ),
        ],
      ),
    );
  }
}
