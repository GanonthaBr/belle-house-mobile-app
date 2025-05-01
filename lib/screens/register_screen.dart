import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/widgets/phone_input_field.dart';
import 'package:mobile_app/widgets/text_field_input.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    final result = await authProvider.register(
      phoneNumber: phoneNumber,
      password: password,
      username: username,
    );

    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration successful!')));
        Navigator.pushNamed(context, '/login');
      }
      // Navigate to another screen or save the token
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Container(
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
                  Expanded(
                    flex: 2,
                    child: Image.asset('images/logo.png', width: 300),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                      vertical: 0.0,
                    ),
                    child: SizedBox(
                      height: AppDimension.screenHeight * 0.08,
                      child: PhoneInputField(controller: _phoneController),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                      vertical: 0.0,
                    ),
                    child: SizedBox(
                      height: AppDimension.screenHeight * 0.08,
                      child: InputTextField(
                        hintText: 'username',
                        fillcolor: AppColors.primaryColor,
                        focuscolor: AppColors.primaryColor,
                        bordercolor: AppColors.primaryColor,
                        helperText: 'Enter your name',
                        labelText: 'User name',
                        fontsize: AppDimension.fontSize18,
                        borderRadius: AppDimension.radius8,
                        labelColor: AppColors.black,
                        passwordField: false,
                        fillBg: true,
                        controller: _usernameController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                      vertical: 0.0,
                    ),
                    child: SizedBox(
                      height: AppDimension.screenHeight * 0.08,
                      child: InputTextField(
                        controller: _passwordController,
                        hintText: 'Mot de passe',
                        fillcolor: AppColors.primaryColor,
                        focuscolor: AppColors.primaryColor,
                        bordercolor: AppColors.primaryColor,
                        helperText: "Créer un mot de passe",
                        labelText: "Mot de passe",
                        fontsize: AppDimension.fontSize18,
                        borderRadius: AppDimension.radius14,
                        labelColor: AppColors.secondaryColor,
                        passwordField: true,
                        fillBg: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimension.radius14,
                      vertical: 0.0,
                    ),
                    child: SizedBox(
                      height: AppDimension.screenHeight * 0.08,
                      child: InputTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirmer le mot de passe',
                        fillcolor: AppColors.primaryColor,
                        focuscolor: AppColors.primaryColor,
                        bordercolor: AppColors.primaryColor,
                        helperText: "Répétez le mot de passe",
                        labelText: "Confirmer le mot de passe",
                        fontsize: AppDimension.fontSize18,
                        borderRadius: AppDimension.radius14,
                        labelColor: AppColors.secondaryColor,
                        passwordField: true,
                        fillBg: true,
                      ),
                    ),
                  ),
                  authProvider.isLoading
                      ? CircularProgressIndicator(color: AppColors.primaryColor)
                      : TextButton(
                        onPressed: _register,
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimension.distance30,
                            vertical: AppDimension.distance20 / 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimension.radius14,
                            ),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: Text(
                            'S\'inscrire',
                            style: TextStyle(
                              fontSize: AppDimension.fontSize18,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
