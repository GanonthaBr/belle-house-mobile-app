import 'package:flutter/material.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class TextFielSearch extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const TextFielSearch({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimension.screenWidth / 1.5,
      margin: EdgeInsets.only(left: AppDimension.distance20 / 2),
      decoration: BoxDecoration(
        // color: Colors.red,
        borderRadius: BorderRadius.circular(AppDimension.distance20 / 2),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.primaryColorLoose,
        //     // spreadRadius: 1,
        //     blurRadius: 0,
        //     blurStyle: BlurStyle.outer,
        //     offset: Offset(0, 0), // changes position of shadow
        //   ),
        // ],
      ),
      height: AppDimension.distance30 * 2.5,
      child: TextField(
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(
            0,
            AppDimension.distance20 / 2,
            0,
            AppDimension.distance20 / 2,
          ),
          filled: true,
          fillColor: AppColors.primaryColorLoose,
          hintText: 'Tapez pour rechercher',
          hintStyle: TextStyle(
            color: AppColors.secondaryColor,
            fontSize: AppDimension.radius8 * 2,
            letterSpacing: 1.2,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: AppDimension.distance30,
            color: AppColors.secondaryColor,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppDimension.distance20),
          ),
        ),
      ),
    );
  }
}
