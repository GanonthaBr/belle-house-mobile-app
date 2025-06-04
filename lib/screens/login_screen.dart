import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/widgets/button_text.dart';
import 'package:mobile_app/widgets/call_to_action.dart';
import 'package:mobile_app/widgets/text_field_input.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  void _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    //authentication logic
    final result = await authProvider.login(
      username: username,
      password: password,
      phoneNumber: phoneNumber,
    );

    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Connecté avec succès')));
        Navigator.pushReplacementNamed(context, '/main');
      }
      // Navigate to another screen or save the token
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Erreur de connection')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppDimension.init(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<AuthProvider>(
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
                      text: 'Connecter à votre compte',
                      fontSize: AppDimension.fontSize24,
                      color: AppColors.primaryColor,
                    ),
                    // Logo
                    Expanded(
                      flex: 2,
                      child: Image.asset('images/logo.png', width: 300),
                    ),
                    // Phone
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                        vertical: 0.0,
                      ),
                      child: SizedBox(
                        height: AppDimension.screenHeight * 0.08,
                        child: InputTextField(
                          controller: _phoneController,
                          fillBg: true,
                          hintText: 'Numéro de téléphone',
                          fillcolor: AppColors.primaryColor,
                          focuscolor: AppColors.primaryColor,
                          bordercolor: AppColors.primaryColor,
                          // helperText: 'Entrer votre numero de téléphone',
                          labelText: "Numéro de téléphone",
                          fontsize: AppDimension.fontSize18,
                          borderRadius: AppDimension.radius14,
                          labelColor: AppColors.secondaryColor,
                          passwordField: false,
                        ),
                      ),
                    ),
                    // Username
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                        vertical: 0.0,
                      ),
                      child: SizedBox(
                        height: AppDimension.screenHeight * 0.08,
                        child: InputTextField(
                          controller: _usernameController,
                          fillBg: true,
                          hintText: 'username',
                          fillcolor: AppColors.primaryColor,
                          focuscolor: AppColors.primaryColor,
                          bordercolor: AppColors.primaryColor,
                          // helperText: 'Enter your username',
                          labelText: "Username",
                          fontsize: AppDimension.fontSize18,
                          borderRadius: AppDimension.radius14,
                          labelColor: AppColors.secondaryColor,
                          passwordField: false,
                        ),
                      ),
                    ),
                    // Password field
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimension.radius14,
                        vertical: 0.0,
                      ),
                      child: SizedBox(
                        height: AppDimension.screenHeight * 0.08,
                        child: InputTextField(
                          controller: _passwordController,
                          fillBg: true,
                          hintText: 'Mot de passe',
                          fillcolor: AppColors.primaryColor,
                          focuscolor: AppColors.primaryColor,
                          bordercolor: AppColors.primaryColor,
                          // helperText: "Entrez votre mot de passe",
                          labelText: "Mot de passe",
                          fontsize: AppDimension.fontSize18,
                          borderRadius: AppDimension.radius14,
                          labelColor: AppColors.secondaryColor,
                          passwordField: true,
                        ),
                      ),
                    ),
                    // Login Button
                    authProvider.isLoading
                        ? CircularProgressIndicator(
                          color: AppColors.primaryColor,
                        )
                        : TextButtonWidget(
                          text: 'Se connecter',
                          height: AppDimension.distance50,
                          fontSize: AppDimension.fontSize18,
                          bgcolor: AppColors.primaryColor,
                          borderRadius: AppDimension.radius14,
                          textcolor: AppColors.secondaryColor,
                          onPressed: _login,
                        ),
                    // CTA
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Pas encore de compte?'),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/register',
                              );
                            },
                            child: Text(
                              "S'incrire",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
