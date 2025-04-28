import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';

class Commerce extends StatelessWidget {
  const Commerce({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Expanded(
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/commerce_details');
            },
            child: _EcommerceProduct(
              image: 'images/sofa.png',
              name: 'Sofa',
              vendeur: 'Zabarkane',
              price: 200000.00,
            ),
          );
        },
      ),
    );
  }
}

class _EcommerceProduct extends StatelessWidget {
  final String image;
  final String name;
  final String vendeur;
  final double price;
  const _EcommerceProduct({
    required this.image,
    required this.name,
    required this.vendeur,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimension.distance20 / 2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.primaryColorLoose),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimension.distance20 / 2),
          ),
        ),
        height: AppDimension.screenHeight / 6,
        child: Row(
          children: [
            //
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppDimension.radius8),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(image),
                    ),
                    // border: Border(right: BorderSide()),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gray,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppDimension.distance20 / 2),
                    bottomRight: Radius.circular(AppDimension.distance20 / 2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: AppDimension.radius8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        text: name,
                        color: AppColors.black,
                        fontSize: AppDimension.fontSize18,
                      ),
                      SizedBox(height: AppDimension.distance20 / 2),
                      Padding(
                        padding: EdgeInsets.only(
                          right: AppDimension.distance20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primaryColor,
                            ),
                            TitleText(
                              text: vendeur,
                              color: AppColors.black,
                              fontSize: AppDimension.radius14,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppDimension.distance20 / 2),
                      TitleText(
                        text: "$price FCFA",
                        color: AppColors.primaryColor,
                        fontSize: AppDimension.radius14,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //
          ],
        ),
      ),
    );
  }
}
