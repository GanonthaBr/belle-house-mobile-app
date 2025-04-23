import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:mobile_app/widgets/title_text.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TitleText(
          text: 'Mes Sauvegardes',
          color: AppColors.black,
          fontSize: AppDimension.fontSize24,
        ),
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: AppDimension.distance50 * 2,
        // shape: CircleBorder(),
      ),
      body: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return FavoriteItem(
            image: 'images/BH39.jpg',
            category: 'Maison',
            vendeur: 'Zabarkane',
            price: 200000.00,
          );
        },
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final String image;
  final String category;
  final String vendeur;
  final double price;
  const FavoriteItem({
    required this.image,
    required this.category,
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
                        text: category,
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
                      //buttton to remove
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.delete, color: AppColors.red),
                          ),
                          TitleText(
                            text: 'Supprimer',
                            color: AppColors.red,

                            fontSize: AppDimension.radius14,
                          ),
                        ],
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
