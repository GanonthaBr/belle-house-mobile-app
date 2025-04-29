import 'package:flutter/material.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/widgets/button_text.dart';
import 'package:mobile_app/widgets/call_to_action.dart';
import 'package:mobile_app/widgets/text_field_input.dart';
import 'package:mobile_app/widgets/title_text.dart';
import 'package:mobile_app/utils/colors.dart';
import 'package:mobile_app/utils/dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    setState(() {
      _isLoading = true;
    });

    // Mock authentication logic
    final result = await _authService.loginUser(
      username: username,
      password: password,
      phoneNumber: phoneNumber,
    );

    setState(() {
      _isLoading = false;
    });
    if (result['success']) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration successful!')));
        Navigator.pushNamed(context, '/home_screen');
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
                    helperText: 'Entrer votre numero de téléphone',
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
                    helperText: 'Enter your username',
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
                    helperText: "Entrez votre mot de passe",
                    labelText: "Mot de passe",
                    fontsize: AppDimension.fontSize18,
                    borderRadius: AppDimension.radius14,
                    labelColor: AppColors.secondaryColor,
                    passwordField: true,
                  ),
                ),
              ),
              // Login Button
              _isLoading
                  ? CircularProgressIndicator(color: AppColors.primaryColor)
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
