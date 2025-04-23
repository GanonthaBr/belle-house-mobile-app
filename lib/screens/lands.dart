import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/houses_listing.dart';

class LandList extends StatelessWidget {
  const LandList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        // physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return HouseListing(
            image: 'images/lands.jpg',
            area: 'Yantala',
            city: 'Niamey',
            price: 200000,
            contractType: 'Location',
            propertyName: 'BH39',
          );
        },
      ),
    );
  }
}
