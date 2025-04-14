import 'package:flutter/material.dart';
import 'package:mobile_app/screens/widgets/button_text.dart';
import 'package:mobile_app/screens/widgets/phone_input_field.dart';
import 'package:mobile_app/screens/widgets/text_field_input.dart';
import 'package:mobile_app/screens/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    // print(AppDimension.screenHeight);
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
                text: 'Créer votre compte',
                fontSize: AppDimension.fontSize24,
                color: AppColors.primaryColor,
              ),
              //logo
              Expanded(
                flex: 2,
                child: Image.asset('images/logo.png', width: 300),
              ),
              // Phone number field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.radius14,
                  vertical: 0.0,
                ),
                child: SizedBox(
                  height: AppDimension.screenHeight * 0.1,
                  child: PhoneInputField(),
                ),
              ),
              // password field
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.radius14,
                  vertical: 0.0,
                ),
                child: InputTextField(
                  hintText: 'Mot de passe',
                  fillcolor: AppColors.primaryColor,
                  focuscolor: AppColors.primaryColor,
                  bordercolor: AppColors.primaryColor,
                  helperText: "Creer un mot de passe",
                  labelText: "Mot de passe",
                  fontsize: AppDimension.fontSize18,
                  borderRadius: AppDimension.radius14,
                  labelColor: AppColors.secondaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimension.radius14,
                  vertical: 0.0,
                ),
                child: InputTextField(
                  hintText: 'Mot de passe',
                  fillcolor: AppColors.primaryColor,
                  focuscolor: AppColors.primaryColor,
                  bordercolor: AppColors.primaryColor,
                  helperText: "Répetez le mot de passe",
                  labelText: "Tapez mot de passe",
                  fontsize: AppDimension.fontSize18,
                  borderRadius: AppDimension.radius14,
                  labelColor: AppColors.secondaryColor,
                ),
              ),
              //TextButton
              TextButtonWidget(
                text: 'S\'inscrire',
                height: AppDimension.distance50,
                fontSize: AppDimension.fontSize18,
                bgcolor: AppColors.primaryColor,
                borderRadius: AppDimension.radius14,
                textcolor: AppColors.secondaryColor,
              ),
              //CTA
              Padding(
                padding: EdgeInsets.only(top: AppDimension.distance20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Avez-vous déjà un compte?'),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Se connecter',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppDimension.fontSize18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
