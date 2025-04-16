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
      margin: EdgeInsets.only(left: AppDimension.distance20 / 2),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            // spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      height: AppDimension.distance20 * 2,
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
          fillColor: AppColors.secondaryColor,
          hintText: 'Tapez pour rechercher',
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: AppDimension.radius8 * 2,
            letterSpacing: 1.2,
          ),
          prefixIcon: Icon(
            Icons.search,
            size: AppDimension.distance45,
            color: AppColors.primaryColor,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppDimension.distance20 / 2),
          ),
        ),
      ),
    );
  }
}
