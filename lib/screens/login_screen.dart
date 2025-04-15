import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/button_text.dart';
import 'package:mobile_app/widgets/call_to_action.dart';
import 'package:mobile_app/widgets/text_field_input.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      body: Container(
        height: AppDimension.screenHeight,
        width: AppDimension.screenWidth,
        color: AppColors.secondaryColor,
        child: Padding(
          padding: EdgeInsets.only(top: AppDimension.distance50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleText(
                text: 'Connecter à votre compte',
                fontSize: AppDimension.fontSize24,
                color: AppColors.primaryColor,
              ),
              //logo
              Expanded(
                flex: 2,
                child: Image.asset('images/logo.png', width: 300),
              ),
              //Phone
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.radius14,
                  vertical: 0.0,
                ),
                child: SizedBox(
                  height: AppDimension.screenHeight * 0.08,
                  child: InputTextField(
                    fillBg: true,
                    hintText: 'Numéro de téléphone',
                    fillcolor: AppColors.primaryColor,
                    focuscolor: AppColors.primaryColor,
                    bordercolor: AppColors.primaryColor,
                    helperText: 'Entrer votre numero de téléphone',
                    labelText: "Numéro de téléphone",
                    fontsize: AppDimension.fontSize18,
                    borderRadius: AppDimension.radius14,
                    labelColor: AppColors.secondaryColor,
                    passwordField: false,
                  ),
                ),
              ),
              // password field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.radius14,
                  vertical: 0.0,
                ),
                child: SizedBox(
                  height: AppDimension.screenHeight * 0.08,
                  child: InputTextField(
                    fillBg: true,
                    hintText: 'Mot de passe',
                    fillcolor: AppColors.primaryColor,
                    focuscolor: AppColors.primaryColor,
                    bordercolor: AppColors.primaryColor,
                    helperText: "Entrez votre mot de passe",
                    labelText: "Mot de passe",
                    fontsize: AppDimension.fontSize18,
                    borderRadius: AppDimension.radius14,
                    labelColor: AppColors.secondaryColor,
                    passwordField: true,
                  ),
                ),
              ),

              //TextButton
              TextButtonWidget(
                text: 'Se connecter',
                height: AppDimension.distance50,
                fontSize: AppDimension.fontSize18,
                bgcolor: AppColors.primaryColor,
                borderRadius: AppDimension.radius14,
                textcolor: AppColors.secondaryColor,
              ),
              //CTA
              Padding(
                padding: EdgeInsets.only(
                  top: AppDimension.distance20 / 2,
                  bottom: AppDimension.distance20 * 2,
                ),
                child: CTAComponent(
                  text: 'Pas encore de compte?',
                  actionText: "S'increi",
                  actionTextColor: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
