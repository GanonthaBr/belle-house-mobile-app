import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/button_text.dart';
import 'package:mobile_app/widgets/call_to_action.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/widgets/welcome_screen_description_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class WelcomeScreenCommerce extends StatelessWidget {
  const WelcomeScreenCommerce({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      body: SizedBox(
        height: AppDimension.screenHeight,
        width: AppDimension.screenWidth,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(color: AppColors.secondaryColor),
            ),
            Expanded(
              flex: 3,
              child: Container(
                width: AppDimension.screenWidth,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimension.fontSize24),
                    topRight: Radius.circular(AppDimension.fontSize24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: AppDimension.radius14),
                      child: TitleText(
                        text: 'Commerce Général!',
                        color: AppColors.secondaryColor,
                        fontSize: AppDimension.fontSize24,
                      ),
                    ),
                    //description
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                        vertical: AppDimension.radius14,
                      ),
                      child: Center(
                        child: WelcomeScreenDescriptionText(
                          text:
                              "Achetez divers articles à bon prix et directement à partir de notre App en quelques clicks",
                        ),
                      ),
                    ),
                    //dot indicator
                    Container(height: 100),
                    //button
                    TextButtonWidget(
                      height: AppDimension.distance50,
                      fontSize: AppDimension.fontSize24,
                      borderRadius: AppDimension.fontSize18,
                      bgcolor: AppColors.secondaryColor,
                      textcolor: AppColors.primaryColor,
                      text: 'S\'incrire',
                    ),
                    CTAComponent(
                      text: "Avez-vous déjà un compte?",
                      actionText: "se connecter",
                      actionTextColor: AppColors.secondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
