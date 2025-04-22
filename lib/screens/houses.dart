import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/houses_listing.dart';

class Houses extends StatelessWidget {
  const Houses({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return HouseListing();
        },
      ),
    );
  }
}
